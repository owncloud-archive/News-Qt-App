TEMPLATE = app

!blackberry {
    include(qmlapplicationviewer/qmlapplicationviewer.pri)
    include(connys-qt-components/qt-components.pri)
}

# Additional import path used to resolve QML modules in Creator's code model

QT += declarative xml network sql



# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    newsinterface.cpp \
    feedsmodel.cpp \
    itemsmodel.cpp \
    Helper.cpp

HEADERS += newsinterface.h \
    feedsmodel.h \
    itemsmodel.h \
    Helper.h

OTHER_FILES += bar-descriptor.xml \
    assets/main.qml \
    assets/FeedItem.qml \
    assets/FeedPage.qml \
    assets/ItemPage.qml \
    assets/NewsItem.qml \
    assets/AdvancedPage.qml \
    assets/ItemView.qml \
    assets/main-mobile.qml \
    assets/simple/PGZButton.qml \
    assets/simple/main.qml \
    assets/simple/Intro.qml \
    assets/simple/Feeds.qml \
    assets/simple/PGZInput.qml \
    assets/simple/PGZBusy.qml \
    assets/simple/Items.qml

blackberry{
    LIBS += -lbbdata -lbb -lbbcascades

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += ownCloudNews.cpp \
    abstractitemmodel.cpp

HEADERS += ownCloudNews.hpp \
    abstractitemmodel.h

}

!blackberry {
    LIBS += -lqjson
}

RESOURCES += \
    assets.qrc

