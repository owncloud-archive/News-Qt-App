#ifndef NEWSINTERFACE_H
#define NEWSINTERFACE_H

#include <QObject>
#include <QSqlDatabase>

#include "feedsmodel.h"
#include "itemsmodel.h"

class QNetworkAccessManager;
class QNetworkReply;
class QAuthenticator;

class NewsInterface : public QObject
{
    Q_OBJECT
public:
    explicit NewsInterface(QObject *parent = 0);
    Q_PROPERTY(FeedsModel* feedsModel READ feedsModel CONSTANT)
    Q_PROPERTY(ItemsModel* itemsModel READ itemsModel CONSTANT)
    Q_PROPERTY(bool busy READ isBusy)

public slots:
    void sync(const QString &url, const QString& username, const QString &password);
    void viewItems(int feedId);

signals:

private:
    QNetworkAccessManager *m_networkManager;
    QSqlDatabase m_db;

    FeedsModel *m_feedsModel;
    FeedsModel *feedsModel() const;

    ItemsModel* m_itemsModel;
    ItemsModel* itemsModel() const;

    static const QString rootPath;
    static const QString format;
    QString serverPath;
    QString feedsPath;
    QString itemsPath;
    QString m_username;
    QString m_password;

    bool m_busy;
    bool isBusy();

    QList<int> m_feedsToSync;

    void getFeeds();
    void getItems(int feedId);
    void syncNextFeed();

private slots:
    void slotAuthenticationRequired ( QNetworkReply * reply, QAuthenticator * authenticator );
    void slotReplyFinished ( QNetworkReply* );
};

#endif // NEWSINTERFACE_H
