#include "Helper.h"
#include <QDebug>

Helper::Helper(QObject *parent) :
    QObject(parent)
{
}

QVariant Helper::getSetting(const QString &settingname, QVariant def)
{
    return settings.value("settings/" + settingname, def);
}

void Helper::setSetting(const QString &settingname, QVariant val)
{
    settings.setValue("settings/" + settingname, val);
}

bool Helper::settingExists(const QString &settingname)
{
    return settings.contains("settings/" + settingname);
}
