#ifndef NEWSINTERFACE_H
#define NEWSINTERFACE_H

#include <QObject>
#include <QSqlDatabase>

#include "feedsmodel.h"
#include "itemsmodel.h"

class QNetworkAccessManager;
class QNetworkReply;
class QAuthenticator;
class QNetworkRequest;

class NewsInterface : public QObject
{
    Q_OBJECT
    Q_PROPERTY(FeedsModel* feedsModel READ feedsModel CONSTANT)
    Q_PROPERTY(ItemsModel* itemsModel READ itemsModel CONSTANT)
    Q_PROPERTY(bool busy READ isBusy NOTIFY busyChanged)


public:
    explicit NewsInterface(QObject *parent = 0);

    bool isBusy();
    FeedsModel *feedsModel() const;
    ItemsModel* itemsModel() const;

    Q_INVOKABLE void sync(const QString &url, const QString& username, const QString &password, int daysToRetain = 14, int numItemsToSync = 20);
    Q_INVOKABLE void viewItems(int feedId);
    Q_INVOKABLE void recreateDatabase();
    Q_INVOKABLE void setItemRead(long itemId, bool read);
    Q_INVOKABLE void setItemStarred(int feedId, const QString& itemGUIDHash, bool starred);

signals:
    void busyChanged(bool busy);

private:
    QNetworkAccessManager *m_networkManager;
    QSqlDatabase m_db;

    FeedsModel *m_feedsModel;
    ItemsModel* m_itemsModel;   

    static const QString rootPath;
    static const QString format;
    QString serverPath;
    QString feedsPath;
    QString itemsPath;
    QString m_username;
    QString m_password;
    int m_daysToRetain;
    int m_numItemsToSync;

    bool m_busy;

    QList<int> m_feedsToSync;

    void getFeeds();
    void getItems(int feedId);
    void syncNextFeed();
    void addAuthHeader(QNetworkRequest *r);

private slots:
    void slotAuthenticationRequired ( QNetworkReply * reply, QAuthenticator * authenticator );
    void slotReplyFinished ( QNetworkReply* );
    void slotItemProcessFinished();
};

#endif // NEWSINTERFACE_H
