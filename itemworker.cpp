#include "itemworker.h"

#include <QVariant>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include "json.h"


ItemWorker::ItemWorker(QSqlDatabase *db, const QByteArray &json, QObject *parent) :
    QObject(parent)
{
    m_db = db;
    m_json = json;
}

void ItemWorker::process()
{
    parseItems();
    emit finished();
}


void ItemWorker::parseItems()
{
    bool ok;
    QVariant data = QtJson::parse(m_json, ok);

    //OLD API QList<QVariant> items = data.toMap()["ocs"].toMap()["data"].toMap()["items"].toList();
    QList<QVariant> items = data.toMap()["items"].toList();

    qDebug() << "Item Count" << items.length();


    foreach(QVariant item, items) {
        QVariantMap map = item.toMap();
        addItem(map["id"].toInt(), map["feedId"].toInt(), map["title"].toString(), map["body"].toString(), map["url"].toString(), map["author"].toString(), map["pubDate"].toUInt(), map["unread"].toBool(), map["starred"].toBool(), map["guid"].toString(), map["guidHash"].toString());
    }
}


void ItemWorker::addItem(int id, int feedid, const QString &title, const QString &body, const QString &link, const QString& author, unsigned int pubdate, bool unread, bool starred, const QString& guid, const QString& guidhash)
{
    if (m_db->isOpen()) {
        QSqlQuery qry;
        qry.prepare("INSERT OR REPLACE INTO items(id, feedid, title, body, link, author, pubdate, unread, starred, guid, guidhash) VALUES(:id, :feedid, :title, :body, :link, :author, :pubdate, :unread, :starred, :guid, :guidhash)");
        qry.bindValue(":id", id);
        qry.bindValue(":feedid", feedid);
        qry.bindValue(":title", title);
        qry.bindValue(":body", body);
        qry.bindValue(":link", link);
        qry.bindValue(":author", author);
        qry.bindValue(":pubdate", pubdate);
        qry.bindValue(":unread", unread);
        qry.bindValue(":starred", starred);
        qry.bindValue(":guid", guid);
        qry.bindValue(":guidhash", guidhash);

//        qDebug() << "Adding item " << feedid << title << pubdate;

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
