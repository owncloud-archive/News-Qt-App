#include "newsinterface.h"

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QAuthenticator>
#include <QDebug>
#include <bb/data/JsonDataAccess>


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
    m_db.setDatabaseName("data/ownnews.sqlite");

    m_db.open(); //TODO error checking

    m_feedsModel = new FeedsModel(this);
    m_feedsModel->setDatabase(&m_db);

    m_itemsModel = new ItemsModel(this);
    m_itemsModel->setDatabase(&m_db);
}

void NewsInterface::sync(const QString &url, const QString& username, const QString &password)
{
    serverPath = url;
    m_username = username;
    m_password = password;
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

    m_busy = false;
    emit(busyChanged(m_busy));

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
        syncNextFeed();
        return;
    }
}

void NewsInterface::getFeeds()
{
    if (!m_busy) {
        m_busy = true;
        emit(busyChanged(m_busy));

        QUrl url(serverPath + feedsPath);
        url.setUserName(m_username);
        url.setPassword(m_password);
       // url.addQueryItem("format", format);

        qDebug() << url;

        m_networkManager->get(QNetworkRequest(url));

    }
}

void NewsInterface::getItems(int feedId)
{
    if (!m_busy) {
        m_busy = true;
        emit(busyChanged(m_busy));

        qDebug() << "Getting items for feed " << feedId;
        QUrl url(serverPath + itemsPath);
        url.setUserName(m_username);
        url.setPassword(m_password);
        url.addQueryItem("id", QString::number(feedId));
        url.addQueryItem("batchSize", "20");
        url.addQueryItem("offset", "0");
        url.addQueryItem("type", "0");
        url.addQueryItem("format", format);
        url.addQueryItem("getRead", "true");

        qDebug() << url;

        m_networkManager->get(QNetworkRequest(url));
    }
}

void NewsInterface::syncNextFeed()
{
    if (!m_feedsToSync.isEmpty()) {
        int id = m_feedsToSync.takeFirst();
        getItems(id);
    }
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
    m_itemsModel->setFeed(feedId);
}

void NewsInterface::recreateDatabase()
{
    m_itemsModel->recreateTable();
}
