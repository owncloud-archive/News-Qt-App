#include "ownCloudNews.hpp"

#ifdef Q_OS_BLACKBERRY
#include <bb/cascades/Application>
#include <Qt/qdeclarativedebug.h>
#include "abstractitemmodel.h"
#elif defined(MER_EDITION_SAILFISH)
#warning sailfish
#include <QGuiApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QtQml>
#include "Helper.h"
#include "newsinterface.h"
#include "sailfishapplication.h"
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
#elif defined(MER_EDITION_SAILFISH)
    QScopedPointer<QGuiApplication> app(Sailfish::createApplication(argc, argv));
    QScopedPointer<QQuickView> view(Sailfish::createView());
#else
    QApplication  *app(createApplication(argc, argv));
    QmlApplicationViewer *viewer(QmlApplicationViewer::create());
#endif

    //Used for settings storage
    QCoreApplication::setOrganizationName("PGZ");
    QCoreApplication::setOrganizationDomain("piggz.co.uk");
    QCoreApplication::setApplicationName("pgz-ownNews");

#ifdef Q_OS_BLACKBERRY
    qmlRegisterType<QAbstractItemModel>();
    qmlRegisterType<AbstractItemModel>("com.kdab.components", 1, 0, "AbstractItemModel");
#endif
    qmlRegisterType<FeedsModel>("uk.co.piggz", 1, 0, "FeedsModel");
    qmlRegisterType<ItemsModel>("uk.co.piggz", 1, 0, "ItemsModel");

#ifdef Q_OS_BLACKBERRY
    new ownCloudNews(&app);
    return bb::cascades::Application::exec();
#elif defined(MER_EDITION_SAILFISH)
    NewsInterface *newsInterface = new NewsInterface();
    view->rootContext()->setContextProperty("NewsInterface", newsInterface);

    Helper *helper = new Helper();
    view->rootContext()->setContextProperty("Helper", helper);

    Sailfish::setView(view.data(), "main.qml");
    Sailfish::showView(view.data());

    Sailfish::showView(view.data());

    return app->exec();
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

