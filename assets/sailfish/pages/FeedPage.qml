import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Silica.theme 1.0
import uk.co.piggz 1.0

Page {
    id: feedpage
    SilicaListView {
        id: listView
        model: NewsInterface.feedsModel
        anchors.fill: parent
        header: PageHeader {
            title: "Feeds"
        }
        delegate: feedDelegate

        /*BackgroundItem {
            Label {
                x: Theme.paddingLarge
                text: "Item " + index
            }
            onClicked: console.log("Clicked " + index)
        }*/

        PullDownMenu {
            MenuItem {
                text: "Sync"
                onClicked: {
                    NewsInterface.sync(_ownCloudURL, _username, _password, 10)
                }
            }
        }
    }

    Component {
        id: feedDelegate

        BackgroundItem {
            width: ListView.view.width
            height: contentItem.childrenRect.height

            onClicked: {
                if (!NewsInterface.busy) {
                    console.log("click", feedid);
                    NewsInterface.viewItems(feedid);
                    pageStack.push(Qt.resolvedUrl("ItemPage.qml"))
                }
            }

            Item {
                width: parent.width
                height: childrenRect.height + 10
                anchors.margins: 5

                Column {
                    spacing: 5
                    x: Theme.paddingLarge
                    Label {
                        id: txtTitle
                        text: feedtitle
                        font.pixelSize: Theme.fontSizeLarge
                        font.bold: true
                    }

                    Label {
                        id: txtLink
                        text: feedurl
                        anchors.right: parent.right
                        color: Theme.secondaryHighlightColor
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }

            }

        }
    }
}





