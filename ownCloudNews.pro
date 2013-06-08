TEMPLATE = app

# Additional import path used to resolve QML modules in Creator's code model

LIBS += -lbbdata -lbb -lbbcascades
QT += declarative xml network sql

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    ownCloudNews.cpp \
    newsinterface.cpp \
    feedsmodel.cpp \
    abstractitemmodel.cpp \
    itemsmodel.cpp \
    Helper.cpp

HEADERS += ownCloudNews.hpp \
    newsinterface.h \
    feedsmodel.h \
    abstractitemmodel.h \
    itemsmodel.h \
    Helper.h

OTHER_FILES += bar-descriptor.xml \
    assets/main.qml \
    assets/FeedItem.qml \
    assets/FeedPage.qml \
    assets/ItemPage.qml \
    assets/NewsItem.qml \
    assets/AdvancedPage.qml



