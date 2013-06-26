#include "itemsmodel.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDateTime>
#include <QTextDocument>
#include <QRegExp>
#include <QDebug>

#ifdef Q_OS_BLACKBERRY
#include <bb/data/JsonDataAccess>
#else
#include <qjson/parser.h>
#endif

ItemsModel::ItemsModel(QObject *parent) : QAbstractListModel(parent)
{
    setRoleNames(roleNames());
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
#ifdef Q_OS_BLACKBERRY
    bb::data::JsonDataAccess jda;
    QVariant data = jda.loadFromBuffer(json);
#else
    QJson::Parser parser;
    bool ok;
    QVariant data = parser.parse (json, &ok);
#endif

    //OLD API QList<QVariant> items = data.toMap()["ocs"].toMap()["data"].toMap()["items"].toList();
    QList<QVariant> items = data.toMap()["items"].toList();

    qDebug() << "Item Count" << items.length();

    m_items.clear();
    foreach(QVariant item, items) {
        QVariantMap map = item.toMap();
        addItem(map["id"].toInt(), map["feedId"].toInt(), map["title"].toString(), map["body"].toString(), map["url"].toString(), map["author"].toString(), map["pubDate"].toUInt(), map["unread"].toBool(), map["starred"].toBool());
    }

}


void ItemsModel::setDatabase(QSqlDatabase *db)
{
    m_db = db;

    if (m_db->isOpen()) {
        QSqlQuery qry;

        qry.prepare( "CREATE TABLE IF NOT EXISTS items (id INTEGER UNIQUE PRIMARY KEY, feedid INTEGER, title VARCHAR(1024), body VARCHAR(2048), link VARCHAR(2048), author VARCHAR(1024), pubdate INT, unread INT, starred INT)" );
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
        qry.prepare("SELECT id, feedid, title, body, link, author, pubdate, unread, starred FROM items WHERE feedid = :fid ORDER BY pubdate DESC");
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

                txt.setHtml(qry.value(3).toString());
                item["body"] = txt.toPlainText().trimmed();

                //item["title"] = qry.value(2).toString().remove(QRegExp("<[^>]*>")).trimmed();
                //item["body"] = qry.value(3).toString().remove(QRegExp("<[^>]*>")).trimmed();
                item["link"] = qry.value(4).toString();
                item["author"] = qry.value(5).toString();
                item["pubdate"] = QDateTime::fromTime_t(qry.value(6).toUInt());
                item["unread"] = qry.value(7).toBool();
                item["starred"] = qry.value(8).toBool();

                qDebug() << item["body"];

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

        qry.prepare( "CREATE TABLE IF NOT EXISTS items (id INTEGER UNIQUE PRIMARY KEY, feedid INTEGER, title VARCHAR(1024), body VARCHAR(2048), link VARCHAR(2048), author VARCHAR(1024), pubdate INTEGER, unread INTEGER, starred INTEGER)" );
        ret = qry.exec();

        if(!ret) {
            qDebug() << qry.lastError();
        } else {
            qDebug() << "Items table created!";
        }
    }
}



QHash<int, QByteArray> ItemsModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[ItemId] = "itemid";
    names[ItemFeedId] = "itemfeedid";
    names[ItemTitle] = "itemtitle";
    names[ItemBody] = "itembody";
    names[ItemLink] = "itemlink";
    names[ItemAuthor] = "itemauthor";
    names[ItemPubDate] = "itempubdate";
    names[ItemUnread] = "itemunread";
    names[ItemStarred] = "itemstarred";

    return names;
}


void ItemsModel::addItem(int id, int feedid, const QString &title, const QString &body, const QString &link, const QString& author, unsigned int pubdate, bool unread, bool starred)
{
    if (m_db->isOpen()) {
        QSqlQuery qry;
        qry.prepare("INSERT OR REPLACE INTO items(id, feedid, title, body, link, author, pubdate, unread, starred) VALUES(:id, :feedid, :title, :body, :link, :author, :pubdate, :unread, :starred)");
        qry.bindValue(":id", id);
        qry.bindValue(":feedid", feedid);
        qry.bindValue(":title", title);
        qry.bindValue(":body", body);
        qry.bindValue(":link", link);
        qry.bindValue(":author", author);
        qry.bindValue(":pubdate", pubdate);
        qry.bindValue(":unread", unread);
        qry.bindValue(":starred", starred);

        qDebug() << "Adding item " << feedid << title << pubdate;

        bool ret = qry.exec();
        if(!ret)
            qDebug() << qry.lastError();
//        else {
//            qDebug() << "item inserted!";
            //TODO
#if 0
            QVariantMap item;
            item["id"] = id;
            item["feedid"] = feedid;
            item["title"] = title;
            item["body"] = body;
            item["link"] = link;
            item["author"] = author;
            item["pubdate"] = QDateTime::fromTime_t(pubdate);
            item["unread"] = unread;
            item["starred"] = starred;

            m_items << item;
#endif
//        }
    }
}
