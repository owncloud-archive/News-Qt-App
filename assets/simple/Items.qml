import QtQuick 1.1

Rectangle {
    signal backClicked();
    signal itemClicked(int itemId, string itemTitle, string itemBody, bool itemUnread, bool itemStarred, string itemAuthor, string itemPubDate);

    PGZBusy {
        anchors.centerIn: parent
        width: 200
        height: 200
        running: NewsInterface.busy
        z: 5
    }

    Component {
        id: itemDelegate

        Rectangle {
            width: parent.width
            height: 128

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#dddddd" }
                GradientStop { position: 0.33; color: "#ffffff" }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    itemClicked(itemid, itemtitle, itembody, itemunread, itemstarred, itemauthor, itempubdate);
                }
            }

            Rectangle {
                height: 1
                width: parent.width
                color: "#bbbbbb"
            }


            Column {
                anchors.fill: parent
                anchors.margins: 5
                Text {
                    id: txtTitle
                    text: itemtitle
                    font.pointSize: 14
                    font.bold: itemunread
                }

                Text {
                    id: txtBody
                    text: itembody
                    font.pointSize: 12
                    color: "#888888"
                    wrapMode: Text.Wrap
                    anchors.left: parent.left
                    anchors.right: parent.right
                    clip: true
                    maximumLineCount: 3


                }
            }


        }

    }

    ListView {
        id:lvItems

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.right:  parent.right
        anchors.bottom: btnBack.top
        anchors.bottomMargin: 5
        anchors.topMargin: 5

        clip: true

        model: NewsInterface.itemsModel
        delegate: itemDelegate
    }



    PGZButton {
        id:btnBack
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 10

        height: 100
        width: 200

        buttonText: "Back"

        onButtonClicked: {
            backClicked();
        }
    }

}
