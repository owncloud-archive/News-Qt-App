#include "itemsmodel.h"
#include <bb/data/JsonDataAccess>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>

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
    bb::data::JsonDataAccess jda;
    QVariant data = jda.loadFromBuffer(json);

    QList<QVariant> items = data.toMap()["ocs"].toMap()["data"].toMap()["items"].toList();

    qDebug() << "Item Count" << items.length();

    m_items.clear();
    foreach(QVariant item, items) {
        QVariantMap map = item.toMap();
        addItem(map["id"].toInt(), map["feedId"].toInt(), map["title"].toString(), map["body"].toString(),map["url"].toString(),map["author"].toString());
    }

}


void ItemsModel::setDatabase(QSqlDatabase *db)
{
    m_db = db;

    if (m_db->isOpen()) {
        QSqlQuery qry;

        qry.prepare( "CREATE TABLE IF NOT EXISTS items (id INTEGER UNIQUE PRIMARY KEY, feedid INTEGER, title VARCHAR(1024), body VARCHAR(2048), link VARCHAR(2048), author VARCHAR(1024))" );
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
        qry.prepare("SELECT id, feedid, title, body, link, author FROM items WHERE feedid = :fid ORDER BY id DESC");
        qry.bindValue(":fid", feedId);

        bool ret = qry.exec();
        if(!ret) {
            qDebug() << qry.lastError();
        } else {
            beginResetModel();
            m_items.clear();
            while (qry.next()) {
                QVariantMap item;
                item["id"] = qry.value(0).toInt();
                item["feedid"] = qry.value(1).toInt();
                item["title"] = qry.value(2).toString();
                item["body"] = qry.value(3).toString();
                item["link"] = qry.value(4).toString();
                item["author"] = qry.value(5).toString();
                m_items << item;

            }
            endResetModel();
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

    return names;
}


void ItemsModel::addItem(int id, int feedid, const QString &title, const QString &body, const QString &link, const QString& author)
{
    if (m_db->isOpen()) {
        QSqlQuery qry;
        qry.prepare("INSERT OR REPLACE INTO items(id, feedid, title, body, link, author) VALUES(:id, :feedid, :title, :body, :link, :author)");
        qry.bindValue(":id", id);
        qry.bindValue(":feedid", feedid);
        qry.bindValue(":title", title);
        qry.bindValue(":body", body);
        qry.bindValue(":link", link);
        qry.bindValue(":author", author);

        bool ret = qry.exec();
        if(!ret)
            qDebug() << qry.lastError();
        else {
            qDebug() << "item inserted!";
            QVariantMap item;
            item["id"] = id;
            item["feedid"] = feedid;
            item["title"] = title;
            item["body"] = body;
            item["link"] = link;
            item["author"] = author;
            m_items << item;
        }
    }
}
