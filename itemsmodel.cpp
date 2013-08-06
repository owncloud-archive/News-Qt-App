#include "itemsmodel.h"
#include "itemworker.h"

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDateTime>
#include <QTextDocument>
#include <QRegExp>
#include <QDebug>
#include <QThread>

ItemsModel::ItemsModel(QObject *parent) : QAbstractListModel(parent)
{
#if QT_VERSION < QT_VERSION_CHECK(5,0,0)
    setRoleNames(roleNames());
#endif
}

QVariant ItemsModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < m_items.count()) {
        if (role == ItemId) {
            return m_items.at(index.row())["id"];
        } else if (role == ItemFeedId) {
            return m_items.at(index.row())["feedid"];
        } else if (role == ItemTitle) {
            return m_items.at(index.row())["title"];
        } else if (role == ItemBody) {
            return m_items.at(index.row())["body"];
        } else if (role == ItemBodyHTML) {
            return m_items.at(index.row())["bodyhtml"];
        } else if (role == ItemLink) {
            return m_items.at(index.row())["link"];
        } else if (role == ItemAuthor) {
            return m_items.at(index.row())["author"];
        } else if (role == ItemPubDate) {
            return m_items.at(index.row())["pubdate"];
        } else if (role == ItemUnread) {
            return m_items.at(index.row())["unread"];
        } else if (role == ItemStarred) {
            return m_items.at(index.row())["starred"];
        } else if (role == ItemGUID) {
            return m_items.at(index.row())["guid"];
        } else if (role == ItemGUIDHash) {
            return m_items.at(index.row())["guidhash"];
        }
    }

    return QVariant();
}

int ItemsModel::rowCount(const QModelIndex &parent) const
{
    return m_items.count();
}

void ItemsModel::parseItems(const QByteArray &json)
{
    m_items.clear();

    QThread* thread = new QThread;
    ItemWorker* worker = new ItemWorker(m_db, json);
    worker->moveToThread(thread);
    //connect(worker, SIGNAL(error(QString)), this, SLOT(errorString(QString)));
    connect(thread, SIGNAL(started()), worker, SLOT(process()));
    connect(worker, SIGNAL(finished()), thread, SLOT(quit()));
    connect(worker, SIGNAL(finished()), worker, SLOT(deleteLater()));
    connect(worker, SIGNAL(finished()), this, SLOT(slotWorkerFinished()));
    connect(thread, SIGNAL(finished()), thread, SLOT(deleteLater()));
    thread->start();
}

void ItemsModel::slotWorkerFinished()
{
    emit feedParseComplete();
}

void ItemsModel::setDatabase(QSqlDatabase *db)
{
    m_db = db;

    if (m_db->isOpen()) {
        QSqlQuery qry;

        qry.prepare( "CREATE TABLE IF NOT EXISTS items (id INTEGER UNIQUE PRIMARY KEY, \
                     feedid INTEGER, \
                     title VARCHAR(1024), \
                     guid VARCHAR(1024), \
                     guidhash VARCHAR(1024), \
                     body VARCHAR(2048), \
                     link VARCHAR(2048), \
                     author VARCHAR(1024), \
                     pubdate INTEGER, \
                     unread INTEGER, \
                     starred INTEGER)" );

        bool ret = qry.exec();
        if(!ret) {
            qDebug() << qry.lastError();
        } else {
            qDebug() << "Items table created!";
        }
    }
}

void ItemsModel::setFeed(int feedId)
{
    if (m_db->isOpen()) {
        QSqlQuery qry;
        qry.prepare("SELECT id, feedid, title, guid, guidhash, body, link, author, pubdate, unread, starred FROM items WHERE feedid = :fid ORDER BY pubdate DESC");
        qry.bindValue(":fid", feedId);

        bool ret = qry.exec();
        if(!ret) {
            qDebug() << qry.lastError();
        } else {
            beginResetModel();
            m_items.clear();

            QTextDocument txt;

            while (qry.next()) {
                QVariantMap item;
                item["id"] = qry.value(0).toInt();
                item["feedid"] = qry.value(1).toInt();

                txt.setHtml(qry.value(2).toString());
                item["title"] = txt.toPlainText().trimmed();

                item["guid"] = qry.value(3).toString();
                item["guidhash"] = qry.value(4).toString();

                txt.setHtml(qry.value(5).toString());
                item["body"] = txt.toPlainText().trimmed();

                item["bodyhtml"] = qry.value(5).toString();
                item["link"] = qry.value(6).toString();
                item["author"] = qry.value(7).toString();
                item["pubdate"] = QDateTime::fromTime_t(qry.value(8).toUInt());
                item["unread"] = qry.value(9).toBool();
                item["starred"] = qry.value(10).toBool();

                m_items << item;

            }
            endResetModel();
        }
    }
}

void ItemsModel::recreateTable()
{
    if (m_db->isOpen()) {
        QSqlQuery qry;

        qry.prepare( "DROP TABLE items" );
        bool ret = qry.exec();

        qry.prepare( "CREATE TABLE IF NOT EXISTS items (id INTEGER UNIQUE PRIMARY KEY, \
                     feedid INTEGER, \
                     title VARCHAR(1024), \
                     guid VARCHAR(1024), \
                     guidhash VARCHAR(1024), \
                     body VARCHAR(2048), \
                     link VARCHAR(2048), \
                     author VARCHAR(1024), \
                     pubdate INTEGER, \
                     unread INTEGER, \
                     starred INTEGER)" );
        ret = qry.exec();

        if(!ret) {
            qDebug() << qry.lastError();
        } else {
            qDebug() << "Items table created!";
        }
    }
}

void ItemsModel::deleteOldData(int days)
{
    qDebug() << "Deleting data older than " << days << " days";
    
    if (m_db->isOpen()) {
        QSqlQuery qry;

        QDateTime now = QDateTime::currentDateTime();
        now = now.addDays(-days);

        qry.prepare( "DELETE FROM items WHERE pubdate < :pubdate" );
        qry.bindValue(":pubdate", now.toTime_t());
        qDebug() << now << qry.lastQuery();
        qDebug() << qry.boundValues();

        bool ret = qry.exec();

        if(!ret) {
            qDebug() << qry.lastError();
        } else {
            qDebug() << "Items table cleared of old items!";
        }
    }
}



QHash<int, QByteArray> ItemsModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[ItemId] = "itemid";
    names[ItemFeedId] = "itemfeedid";
    names[ItemTitle] = "itemtitle";
    names[ItemGUID] = "itemguid";
    names[ItemGUIDHash] = "itemguidhash";
    names[ItemBody] = "itembody";
    names[ItemBodyHTML] = "itembodyhtml";
    names[ItemLink] = "itemlink";
    names[ItemAuthor] = "itemauthor";
    names[ItemPubDate] = "itempubdate";
    names[ItemUnread] = "itemunread";
    names[ItemStarred] = "itemstarred";

    return names;
}

