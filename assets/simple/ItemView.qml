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

        contentHeight: itemContent.height + 50

        Rectangle {
            width: parent.width
            height: 256

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#dddddd" }
                GradientStop { position: 0.33; color: "#ffffff" }
            }
        }

        Item {
            id: itemContent
            width: parent.width
            height: childrenRect.height

            Item {
                id:titleRow
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: childrenRect.height

                Text {
                    id: txtTitle
                    text: title
                    font.pointSize: 14
                    font.bold: unread
                    anchors.left: parent.left
                    width: parent.width - 64
                }

                Image {
                    id: imgStar
                    anchors.right: parent.right
                    source: starred ? "../star-filled.png" : "../star-unfilled.png"
                    width: 64
                    height: 64

                }
            }


            Item {
                id: authorRow
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: titleRow.bottom

                height: childrenRect.height
                anchors.margins: 5
                Text {
                    id: txtAuthor
                    text: author
                    font.pointSize: 12
                    anchors.left: parent.left
                    width: parent.width / 2
                    clip: true
                    wrapMode: Text.WordWrap
                }

                Text {
                    id: txtPubDate
                    text: pubdate
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
                text: "<html>" + strip_tags(body, "<a><b><p><strong><em><i>") + "</html>"
                textFormat: Text.RichText
                font.pointSize: 12
                wrapMode: Text.Wrap
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: authorRow.bottom
                anchors.margins: 5

                onLinkActivated: {
                    console.log(link, ".activated");
                    Qt.openUrlExternally(link);
                }

                function strip_tags (input, allowed) {
                    allowed = (((allowed || "") + "").toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join(''); // making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
                    var tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,
                            commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi;
                    return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {
                        return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : '';
                    });
                }

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

    PGZButton {
        id:btnOpen
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 10

        height: 100
        width: 200

        buttonText: "Visit"

        onButtonClicked: {
            Qt.openUrlExternally(link);
        }
    }


}
