#include "ownCloudNews.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>

#include "newsinterface.h"
#include "feedsmodel.h"
#include "Helper.h"

ownCloudNews::ownCloudNews(bb::cascades::Application *app)
    : QObject(app)
{
    bb::cascades::QmlDocument *qml = bb::cascades::QmlDocument::create("asset:///main.qml").parent(this);

    NewsInterface *newsInterface = new NewsInterface();
    qml->setContextProperty("NewsInterface", newsInterface);

    Helper *helper = new Helper();
    qml->setContextProperty("Helper", helper);

    bb::cascades::AbstractPane *root = qml->createRootObject<bb::cascades::AbstractPane>();

    app->setScene(root);
}


