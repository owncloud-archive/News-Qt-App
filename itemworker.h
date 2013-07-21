#ifndef ITEMWORKER_H
#define ITEMWORKER_H

#include <QObject>

class QSqlDatabase;

class ItemWorker : public QObject
{
    Q_OBJECT
public:
    explicit ItemWorker(QSqlDatabase *db, const QByteArray& json, QObject *parent = 0);
    
public slots:
    void process();

signals:
    void finished();
    void error(QString err);

    
private:
    void parseItems();
    void addItem(int id, int feedid, const QString &title, const QString &body, const QString &link, const QString& author, unsigned int pubdate, bool unread, bool starred, const QString& guid, const QString& guidhash);

    QSqlDatabase *m_db;
    QByteArray m_json;
};

#endif // ITEMWORKER_H
