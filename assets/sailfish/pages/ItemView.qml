import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Silica.theme 1.0
import uk.co.piggz 1.0

Page {
    id: itemView
    signal backClicked();

    property string title: ""
    property string body: ""
    property string link: ""
    property string author: ""
    property string pubdate: ""
    property bool unread: false
    property bool starred: false


    SilicaFlickable {

        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: "Open in Browser"
                onClicked: {
                    Qt.openUrlExternally(link);
                }
            }
            MenuItem {
                text: "Open in Instapaper"
                onClicked: {
                    Qt.openUrlExternally("http://mobilizer.instapaper.com/m?u=" + link);
                }
            }
        }

        Column {

            height: childrenRect.height
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: title
            }

            Item {
                id: authorRow
                anchors.left: parent.left
                anchors.right: parent.right

                height: childrenRect.height
                anchors.margins: 5
                Label {
                    id: txtAuthor
                    text: author
                    color: Theme.secondaryHighlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    anchors.left: parent.left
                    width: parent.width / 2
                    clip: true
                    wrapMode: Text.WordWrap
                }

                Label {
                    id: txtPubDate
                    text: pubdate
                    color: Theme.secondaryHighlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    anchors.right: parent.right
                    width: parent.width / 2
                    clip: true
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignRight
                }
            }

            Label {

                id: txtBody
                text: "<html>" + strip_tags(body, "<a><b><p><strong><em><i>") + "</html>"
                textFormat: Text.RichText
                font.pointSize: 12
                wrapMode: Text.Wrap
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 5

                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeExtraSmall

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
}
