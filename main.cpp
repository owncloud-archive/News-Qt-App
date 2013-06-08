#include "ownCloudNews.hpp"

#include <bb/cascades/Application>
#include <Qt/qdeclarativedebug.h>
#include "abstractitemmodel.h"
#include "feedsmodel.h"
#include "itemsmodel.h"
#include "newsinterface.h"

Q_DECL_EXPORT int main(int argc, char **argv)
{
    bb::cascades::Application app(argc, argv);
    QCoreApplication::setOrganizationName("PGZ");
    QCoreApplication::setOrganizationDomain("piggz.co.uk");
    QCoreApplication::setApplicationName("pgz-ownNews");

    qmlRegisterType<QAbstractItemModel>();
    qmlRegisterType<AbstractItemModel>("com.kdab.components", 1, 0, "AbstractItemModel");
    qmlRegisterType<FeedsModel>("uk.co.piggz", 1, 0, "FeedsModel");
    qmlRegisterType<ItemsModel>("uk.co.piggz", 1, 0, "ItemsModel");

    new ownCloudNews(&app);
    
    return bb::cascades::Application::exec();
}

