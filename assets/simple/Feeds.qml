import QtQuick 1.1

Rectangle {
    signal backClicked();
    signal feedClicked(int feedId);

    PGZBusy {
        anchors.centerIn: parent
        width: 200
        height: 200
        running: NewsInterface.busy
        z: 5
    }

    Component {
        id: feedDelegate

        Rectangle {
            width: parent.width
            height: 64

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#dddddd" }
                GradientStop { position: 0.33; color: "#ffffff" }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (!NewsInterface.busy) {
                        console.log("click", feedid);
                        feedClicked(feedid);
                    }
                }
            }

            Rectangle {
                height: 1
                width: parent.width
                color: "#bbbbbb"
            }


            Row {
                anchors.fill: parent
                spacing: 10
                anchors.margins: 5

                Rectangle {
                    radius: 4
                    width: 54
                    height: 54

                    color: "#cccccc"

                    Image {
                        id: imgIcon
                        source: feedicon
                        y: 8
                        width: 48
                        height: 48
                        anchors.centerIn: parent

                        smooth: true

                    }
                }
                Column {
                    Text {
                        id: txtTitle
                        text: feedtitle
                        font.pointSize: 14
                        font.bold: true
                    }

                    Text {
                        id: txtLink
                        text: feedurl
                        font.pointSize: 12
                        color: "#888888"
                        anchors.right: parent.right



                    }
                }
            }

        }

    }

    ListView {
        id:lvFeeds

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.right:  parent.right
        anchors.bottom: btnBack.top
        anchors.bottomMargin: 5
        anchors.topMargin: 5

        clip: true

        model: NewsInterface.feedsModel
        delegate: feedDelegate
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

    PGZButton {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 10
        buttonText: "Sync"
        height: 100
        width: 200

        onButtonClicked: {
            NewsInterface.sync(_ownCloudURL, _username, _password, 10)
        }
    }

}
