import QtQuick 1.1

Rectangle {
    signal backClicked();
    signal itemClicked(int itemId, string itemTitle, string itemBody, bool itemUnread, bool itemStarred, string itemAuthor, string itemPubDate, string itemLink);

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
            height: colContent.height + 10

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#dddddd" }
                GradientStop { position: 0.33; color: "#ffffff" }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    itemClicked(itemid, itemtitle, itembodyhtml, itemunread, itemstarred, itemauthor, itempubdate, itemlink);
                }
            }

            Rectangle {
                height: 1
                width: parent.width
                color: "#bbbbbb"
            }


            Column {
                id: colContent
                height: childrenRect.height
                width: parent.width
                y: 5
                spacing: 5

                Item {

                    anchors.left: parent.left
                    anchors.right: parent.right

                    height: childrenRect.height

                    Text {
                        id: txtTitle
                        text: itemtitle
                        font.pointSize: 14
                        font.bold: itemunread
                        anchors.left: parent.left
                        width: parent.width - 64
                    }

                    Image {
                        id: imgStar
                        anchors.right: parent.right
                        source: itemstarred ? "../star-filled.png" : "../star-unfilled.png"
                        width: 64
                        height: 64

                    }
                }

                Item {
                    id: titleRow
                    anchors.left: parent.left
                    anchors.right: parent.right

                    height: childrenRect.height
                    anchors.margins: 0

                    Text {
                        id: txtAuthor
                        text: itemauthor
                        font.pointSize: 12
                        anchors.left: parent.left
                        width: parent.width / 2
                        clip: true
                        wrapMode: Text.WordWrap
                    }

                    Text {
                        id: txtPubDate
                        text: timeDifference(new Date(), new Date(itempubdate));
                        font.pointSize: 12
                        anchors.right: parent.right
                        width: parent.width / 2
                        clip: true
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignRight
                    }
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
