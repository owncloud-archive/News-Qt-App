#include "newsinterface.h"

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QAuthenticator>
#include <QDebug>

#if QT_VERSION >= QT_VERSION_CHECK(5,0,0)
#   include <QUrlQuery>
#endif

//const QString NewsInterface::rootPath = "/ocs/v1.php/apps/news/";
const QString NewsInterface::rootPath = "/index.php/apps/news/api/v1-2/";
const QString NewsInterface::format = "json";

NewsInterface::NewsInterface(QObject *parent) : QObject(parent)
{
    m_networkManager = new QNetworkAccessManager();

    m_busy = false;

    feedsPath = rootPath + "feeds";
    itemsPath = rootPath + "items";

    connect(m_networkManager, SIGNAL(authenticationRequired(QNetworkReply*,QAuthenticator*)), this, SLOT(slotAuthenticationRequired(QNetworkReply*,QAuthenticator*)));
    connect(m_networkManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(slotReplyFinished(QNetworkReply*)));

    m_db = QSqlDatabase::addDatabase("QSQLITE");
#ifdef Q_OS_BLACKBERRY
    m_db.setDatabaseName("data/ownnews.sqlite");
#else
    m_db.setDatabaseName("ownnews.sqlite");
#endif

    m_db.open(); //TODO error checking

    m_feedsModel = new FeedsModel(this);
    m_feedsModel->setDatabase(&m_db);

    m_itemsModel = new ItemsModel(this);
    m_itemsModel->setDatabase(&m_db);

    connect(m_itemsModel, SIGNAL(feedParseComplete()), this, SLOT(slotItemProcessFinished()));
}

void NewsInterface::sync(const QString &url, const QString& username, const QString &password, int daysToRetain, int numItemsToSync)
{
    serverPath = url;
    m_username = username;
    m_password = password;
    m_daysToRetain = daysToRetain;
    m_numItemsToSync = numItemsToSync;

    getFeeds();
}

void NewsInterface::slotAuthenticationRequired ( QNetworkReply * reply, QAuthenticator * authenticator )
{
    qDebug() << "Asked to authenticate";
    authenticator->setUser(m_username);
    authenticator->setPassword(m_password);
}

void NewsInterface::slotReplyFinished(QNetworkReply* reply)
{
    qDebug() << "Reply from " << reply->url().path();

    if (reply->url().path().endsWith(feedsPath))
    {
        qDebug() << "Reply from feeds";
        m_feedsModel->parseFeeds(reply->readAll());
        m_feedsToSync = m_feedsModel->feedIds();
        syncNextFeed();
        return;
    }

    if (reply->url().path().endsWith(itemsPath))
    {
        qDebug() << "Reply from items";
        m_itemsModel->parseItems(reply->readAll());
        return;
    }

    if (reply->url().path().endsWith("/read"))
    {
        qDebug() << "Reply from item read";
        return;
    }

    if (reply->url().path().endsWith("/unread"))
    {
        qDebug() << "Reply from item unread";
        return;
    }

    if (reply->url().path().endsWith("/star"))
    {
        qDebug() << "Reply from item star" << reply->attribute( QNetworkRequest::HttpStatusCodeAttribute );

        return;
    }

    if (reply->url().path().endsWith("/unstar"))
    {
        qDebug() << "Reply from item unstar";
        return;
    }



    m_busy = false;
    emit(busyChanged(m_busy));
}

void NewsInterface::slotItemProcessFinished()
{
    syncNextFeed();
}

void NewsInterface::getFeeds()
{
    if (!m_busy) {
        m_busy = true;
        emit(busyChanged(m_busy));

        QUrl url(serverPath + feedsPath);
        url.setUserName(m_username);
        url.setPassword(m_password);

        qDebug() << url;

        QNetworkRequest r(url);
        addAuthHeader(&r);

        QNetworkReply *reply = m_networkManager->get(r);
        connect(reply, SIGNAL(sslErrors(QList<QSslError>)), reply, SLOT(ignoreSslErrors()));
    }
}

void NewsInterface::getItems(int feedId)
{
    if (!m_busy) {
        m_busy = true;
        emit(busyChanged(m_busy));
    }
    qDebug() << "Getting items for feed " << feedId;

    QUrl url(serverPath + itemsPath);
    url.setUserName(m_username);
    url.setPassword(m_password);

#if QT_VERSION < QT_VERSION_CHECK(5,0,0)
    url.addQueryItem("id", QString::number(feedId));
    url.addQueryItem("batchSize", QString::number(m_numItemsToSync));
    url.addQueryItem("offset", "0");
    url.addQueryItem("type", "0");
    url.addQueryItem("format", format);
    url.addQueryItem("getRead", "true");
#else
    QUrlQuery q;
    q.addQueryItem("id", QString::number(feedId));
    q.addQueryItem("batchSize", QString::number(m_numItemsToSync));
    q.addQueryItem("offset", "0");
    q.addQueryItem("type", "0");
    q.addQueryItem("format", format);
    q.addQueryItem("getRead", "true");
    url.setQuery(q);
#endif
    qDebug() << url;

    QNetworkReply *reply = m_networkManager->get(QNetworkRequest(url));
    connect(reply, SIGNAL(sslErrors(QList<QSslError>)), reply, SLOT(ignoreSslErrors()));
}

void NewsInterface::syncNextFeed()
{
    qDebug() << "Syncing next feed";

    if (!m_feedsToSync.isEmpty()) {
        int id = m_feedsToSync.takeFirst();
        getItems(id);
        return;
    }

    m_itemsModel->deleteOldData(m_daysToRetain);
    m_busy = false;
    emit(busyChanged(m_busy));
}

FeedsModel* NewsInterface::feedsModel() const
{
    return m_feedsModel;
}

ItemsModel* NewsInterface::itemsModel() const
{
    return m_itemsModel;
}

bool NewsInterface::isBusy()
{
    qDebug() << "Busy: " << m_busy;
    return m_busy;
}

void NewsInterface::viewItems(int feedId)
{
    qDebug() << "Viewing feed" << feedId;
    m_itemsModel->setFeed(feedId);
}

void NewsInterface::recreateDatabase()
{
    m_itemsModel->recreateTable();
}

void NewsInterface::setItemRead(long itemId, bool read)
{
    qDebug() << "Setting item read " << itemId;

    QUrl url(serverPath + itemsPath + "/" + QString::number(itemId) + (read ? "/read" : "/unread"));
    url.setUserName(m_username);
    url.setPassword(m_password);

    qDebug() << url;

    m_networkManager->put(QNetworkRequest(url), "");

}

void NewsInterface::setItemStarred(int feedId, const QString& itemGUIDHash, bool starred)
{
    qDebug() << "Setting item starred " << itemGUIDHash;

    QUrl url(serverPath + itemsPath + "/" + QString::number(feedId) + "/" + itemGUIDHash + (starred ? "/star" : "/unstar"));
    url.setUserName(m_username);
    url.setPassword(m_password);

    qDebug() << url;

    m_networkManager->put(QNetworkRequest(url), "");
}

void NewsInterface::addAuthHeader(QNetworkRequest *r)
{
    if (r) {
        QString concatenated = m_username + ":" + m_password;
        QByteArray data = concatenated.toLocal8Bit().toBase64();
        QString headerData = "Basic " + data;
        r->setRawHeader("Authorization", headerData.toLocal8Bit());
    }
}
