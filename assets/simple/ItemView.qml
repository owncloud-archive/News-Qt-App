import QtQuick 1.1

Rectangle {
    signal backClicked();

    property string title: ""
    property string body: ""
    property string link: ""
    property string author: ""
    property string pubdate: ""
    property bool unread: false
    property bool starred: false


    Flickable {
        anchors.top: parent.top
        anchors.bottom: btnBack.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10

        flickableDirection: Flickable.VerticalFlick
        clip: true

        Column {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 10

            Text {
                id: txtTitle
                text: title
                font.pointSize: 14
                font.bold: itemunread
                wrapMode: Text.Wrap
                anchors.left: parent.left
                anchors.right: parent.right
            }

            Row {
                spacing: 10
                anchors.left: parent.left
                anchors.right: parent.right
                Text {
                    id: txtAuthor
                    text: author
                    font.pointSize: 12
                }

                Text {
                    id: txtPubDate
                    text: pubdate
                    font.pointSize: 12
                    anchors.right: parent.right
                }
            }

            Text {
                id: txtBody
                text: body
                font.pointSize: 12
                color: "#888888"
                wrapMode: Text.Wrap
                anchors.left: parent.left
                anchors.right: parent.right

            }
        }


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
