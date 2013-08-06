#ifndef ITEMSMODEL_H
#define ITEMSMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QVariantMap>
#include <QSqlDatabase>
#include <QMetaType>

class ItemsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        ItemId = Qt::UserRole + 1,
        ItemFeedId,
        ItemTitle,
        ItemGUID,
        ItemGUIDHash,
        ItemBody,
        ItemBodyHTML,
        ItemLink,
        ItemAuthor,
        ItemPubDate,
        ItemUnread,
        ItemStarred
    };

    explicit ItemsModel(QObject *parent = 0);
    
    virtual QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    virtual int rowCount(const QModelIndex& parent = QModelIndex()) const;
    virtual QHash<int, QByteArray> roleNames() const;

    void parseItems(const QByteArray& json);
    void setDatabase(QSqlDatabase *db);
    void setFeed(int feedId);
    void recreateTable();
    void deleteOldData(int days);



signals:
    void feedParseComplete();

private slots:
    void slotWorkerFinished();

private:

    QList<QVariantMap> m_items;

    QSqlDatabase *m_db;

};

Q_DECLARE_METATYPE(ItemsModel*);

#endif // ITEMSMODEL_H
