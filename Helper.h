#ifndef HELPER_H
#define HELPER_H

#include <QObject>
#include <QSettings>

class Helper : public QObject
{
    Q_OBJECT
public:
    explicit Helper(QObject *parent = 0);

signals:

public slots:
    QVariant getSetting(const QString &settingname, QVariant def);

    void setSetting(const QString& settingname, QVariant val);
    bool settingExists(const QString &settingname);

private:
    QSettings settings;

};

#endif // HELPER_H
