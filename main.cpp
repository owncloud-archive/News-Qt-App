#include "ownCloudNews.hpp"

#ifdef Q_OS_BLACKBERRY
#include <bb/cascades/Application>
#include <Qt/qdeclarativedebug.h>
#include "abstractitemmodel.h"
#else
#include <QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer/qmlapplicationviewer.h"
#include "Helper.h"
#endif

#include "feedsmodel.h"
#include "itemsmodel.h"
#include "newsinterface.h"

Q_DECL_EXPORT int main(int argc, char **argv)
{
#ifdef Q_OS_BLACKBERRY
    bb::cascades::Application app(argc, argv);
#else
    QApplication  *app(createApplication(argc, argv));
    QmlApplicationViewer *viewer(QmlApplicationViewer::create());
#endif


    QCoreApplication::setOrganizationName("PGZ");
    QCoreApplication::setOrganizationDomain("piggz.co.uk");
    QCoreApplication::setApplicationName("pgz-ownNews");

#ifdef Q_OS_BLACKBERRY
    qmlRegisterType<AbstractItemModel>("com.kdab.components", 1, 0, "AbstractItemModel");
#endif
    qmlRegisterType<FeedsModel>("uk.co.piggz", 1, 0, "FeedsModel");
    qmlRegisterType<ItemsModel>("uk.co.piggz", 1, 0, "ItemsModel");

#ifdef Q_OS_BLACKBERRY
    new ownCloudNews(&app);
    return bb::cascades::Application::exec();
#else
    NewsInterface *newsInterface = new NewsInterface();
    viewer->rootContext()->setContextProperty("NewsInterface", newsInterface);

    Helper *helper = new Helper();
    viewer->rootContext()->setContextProperty("Helper", helper);

    viewer->setOrientation(QmlApplicationViewer::ScreenOrientationLockLandscape);
    viewer->setSource(QUrl("qrc:/assets/simple/main.qml"));
    viewer->setResizeMode(QDeclarativeView::SizeRootObjectToView);
    viewer->setGeometry(100, 100, 480, 848);
    viewer->show();
    return app->exec();
#endif
}

