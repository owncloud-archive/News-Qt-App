#include "feedsmodel.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include "json.h"

FeedsModel::FeedsModel(QObject *parent) :
    QAbstractListModel(parent)
{
#if QT_VERSION < QT_VERSION_CHECK(5,0,0)
    setRoleNames(roleNames());
#endif
}

QHash<int, QByteArray> FeedsModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[FeedId] = "feedid";
    names[FeedTitle] = "feedtitle";
    names[FeedURL] = "feedurl";
    names[FeedIcon] = "feedicon";

    return names;
}

QList<int> FeedsModel::feedIds()
{
    QList<int> ids;

    foreach(QVariantMap feed, m_feeds) {
        ids << feed["id"].toInt();
    }

    return ids;
}

void FeedsModel::addFeed(int id, const QString &title, const QString &url, const QString &icon)
{
    if (m_db->isOpen()) {
        QSqlQuery qry;
        qry.prepare("INSERT OR REPLACE INTO feeds(id, title, url, icon) VALUES(:id, :title, :url, :icon)");
        qry.bindValue(":id", id);
        qry.bindValue(":title", title);
        qry.bindValue(":url", url);
        qry.bindValue(":icon", icon);

        bool ret = qry.exec();
        if(!ret)
            qDebug() << qry.lastError();
        else {
            qDebug() << "feed inserted!";
            QVariantMap feed;
            feed["id"] = id;
            feed["title"] = title;
            feed["url"] = url;
            feed["icon"] = icon;
            m_feeds << feed;
        }
    }
}

void FeedsModel::loadData()
{
    if (m_db->isOpen()) {
        qDebug() << "Loading feed data";
        QSqlQuery qry;
        qry.prepare("SELECT id, title, url, icon FROM feeds");

        bool ret = qry.exec();
        if(!ret) {
            qDebug() << qry.lastError();
        } else {
            beginResetModel();
            while (qry.next()) {
                QVariantMap feed;
                feed["id"] = qry.value(0).toInt();
                feed["title"] = qry.value(1).toString();
                feed["url"] = qry.value(2).toString();
                feed["icon"] = qry.value(3).toString();
                m_feeds << feed;
            }
            endResetModel();
        }
    }
}


QVariant FeedsModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < m_feeds.count()) {
        if (role == FeedId) {
            return m_feeds.at(index.row())["id"];
        } else if (role == FeedTitle) {
            return m_feeds.at(index.row())["title"];
        } else if (role == FeedURL) {
            return m_feeds.at(index.row())["url"];
        } else if (role == FeedIcon) {
            return m_feeds.at(index.row())["icon"];
        }
    }

    return QVariant();
}

int FeedsModel::rowCount(const QModelIndex &parent) const
{
    return m_feeds.count();
}

void FeedsModel::parseFeeds(const QByteArray &json)
{
    bool ok;
    QVariant data = QtJson::parse(json, ok);

    qDebug() << json;
    QList<QVariant> feeds = data.toMap()["feeds"].toList();

    qDebug() << "Feed Count" << feeds.length();

    beginResetModel();

    m_feeds.clear();
    foreach(QVariant feed, feeds) {
        QVariantMap map = feed.toMap();
        addFeed(map["id"].toInt(), map["title"].toString(), map["url"].toString(), map["faviconLink"].toString());
    }

    endResetModel();
}

void FeedsModel::setDatabase(QSqlDatabase *db)
{
    m_db = db;

    if (m_db->isOpen()) {
        QSqlQuery qry;

        qry.prepare( "CREATE TABLE IF NOT EXISTS feeds (id INTEGER UNIQUE PRIMARY KEY, title VARCHAR(1024), url VARCHAR(2048), icon VARCHAR(2048))" );
        bool ret = qry.exec();
        if(!ret) {
            qDebug() << qry.lastError();
        } else {
            qDebug() << "Feed table created!";
        }

        loadData();
    }

}
