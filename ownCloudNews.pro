TEMPLATE = app
VERSION = 0.2

android {
    include(qmlapplicationviewer/qmlapplicationviewer.pri)

    RESOURCES += \
    assets.qrc
}

#need something better here to detect sailfish
!android{
!blackberry{
    message(SailfishOS build)

    DEFINES += MER_EDITION_SAILFISH
    MER_EDITION = sailfish
    include(sailfishapplication/sailfishapplication.pri)

    # QML files and folders
    qml.files =  assets/sailfish/pages assets/sailfish/cover assets/sailfish/main.qml

    # The .desktop file
    desktop.files = newsFish.desktop

    OTHER_FILES = \
        rpm/ownCloudNews.yaml

    QT += sql
}
}

blackberry{
    LIBS += -lbbdata -lbb -lbbcascades

    # The .cpp file which was generated for your project. Feel free to hack it.
    SOURCES += ownCloudNews.cpp \
        abstractitemmodel.cpp

    HEADERS += ownCloudNews.hpp \
        abstractitemmodel.h

}

# Additional import path used to resolve QML modules in Creator's code model

#QT += declarative xml network sql

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    newsinterface.cpp \
    feedsmodel.cpp \
    itemsmodel.cpp \
    Helper.cpp \
    itemworker.cpp \
    json.cpp

HEADERS += newsinterface.h \
    feedsmodel.h \
    itemsmodel.h \
    Helper.h \
    itemworker.h \
    json.h

blackberry {
OTHER_FILES += bar-descriptor.xml \
    assets/main.qml \
    assets/FeedItem.qml \
    assets/FeedPage.qml \
    assets/ItemPage.qml \
    assets/NewsItem.qml \
    assets/AdvancedPage.qml \
    assets/ItemView.qml
}

android {
    OTHER_FILES += assets/simple/PGZButton.qml \
    assets/simple/main.qml \
    assets/simple/Intro.qml \
    assets/simple/Feeds.qml \
    assets/simple/PGZInput.qml \
    assets/simple/PGZBusy.qml \
    assets/simple/Items.qml \
    assets/simple/ItemView.qml \
    android/src/org/kde/necessitas/ministro/IMinistroCallback.aidl \
    android/src/org/kde/necessitas/ministro/IMinistro.aidl \
    android/src/org/kde/necessitas/origo/QtActivity.java \
    android/src/org/kde/necessitas/origo/QtApplication.java \
    android/res/values-et/strings.xml \
    android/res/values-es/strings.xml \
    android/res/values-ms/strings.xml \
    android/res/layout/splash.xml \
    android/res/values-de/strings.xml \
    android/res/values-pl/strings.xml \
    android/res/values-el/strings.xml \
    android/res/values-ja/strings.xml \
    android/res/values-it/strings.xml \
    android/res/values-zh-rCN/strings.xml \
    android/res/values-ro/strings.xml \
    android/res/values-rs/strings.xml \
    android/res/values-pt-rBR/strings.xml \
    android/res/values-nb/strings.xml \
    android/res/values-zh-rTW/strings.xml \
    android/res/values-fr/strings.xml \
    android/res/values-id/strings.xml \
    android/res/values-nl/strings.xml \
    android/res/values/strings.xml \
    android/res/values-fa/strings.xml \
    android/res/values-ru/strings.xml \
    android/version.xml \
    android/AndroidManifest.xml \
    android/res/drawable/icon.png \
    android/res/drawable/logo.png \
    android/res/drawable-mdpi/icon.png \
    android/res/drawable-hdpi/icon.png \
    android/res/drawable-ldpi/icon.png \
    android/res/values/libs.xml
}



OTHER_FILES += \
    assets/DateFunctions.js \
    assets/star-unfilled.png \
    assets/star-filled.png
