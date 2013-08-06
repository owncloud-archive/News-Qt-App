#ifndef FEEDSMODEL_H
#define FEEDSMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QVariantMap>
#include <QSqlDatabase>
#include <QMetaType>
class FeedsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        FeedId = Qt::UserRole+1,
        FeedTitle,
        FeedURL,
        FeedIcon
    };

    explicit FeedsModel(QObject *parent = 0);
    
    virtual QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    virtual int rowCount(const QModelIndex& parent = QModelIndex()) const;
    virtual QHash<int, QByteArray> roleNames() const;

    void parseFeeds(const QByteArray& json);
    void setDatabase(QSqlDatabase *db);
    QList<int> feedIds();

private:


    QList<QVariantMap> m_feeds;

    QSqlDatabase *m_db;

    void addFeed(int id, const QString& title, const QString& url, const QString& icon);
    void loadData();

};

Q_DECLARE_METATYPE(FeedsModel*);

#endif // FEEDSMODEL_H
