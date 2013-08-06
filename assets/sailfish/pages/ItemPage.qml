import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Silica.theme 1.0
import uk.co.piggz 1.0

Page {
    id: itempage
    SilicaListView {
        id: listView
        model: NewsInterface.itemsModel
        anchors.fill: parent
        header: PageHeader {
            title: "Items"
        }
        delegate: itemDelegate


    }

    Component {
        id: itemDelegate

        BackgroundItem {
            width: ListView.view.width
            height: contentItem.childrenRect.height

            onClicked: {
                pageStack.push(itemView)

                itemView.title = itemtitle;
                itemView.body = itembodyhtml;
                itemView.link = itemlink;
                itemView.author = itemauthor;
                itemView.pubdate = timeDifference(new Date(), itempubdate);
                itemView.unread = itemunread;
                itemView.starred = itemstarred;

                NewsInterface.setItemRead(itemid, true);
            }

            Column {
                id: colContent
                height: childrenRect.height
                spacing: 5
                x: Theme.paddingLarge
                width: parent.width - (Theme.paddingLarge * 2)

                Item {

                    anchors.left: parent.left
                    anchors.right: parent.right

                    height: childrenRect.height

                    Label {
                        id: txtTitle
                        text: itemtitle
                        font.pixelSize: Theme.fontSizeLarge
                        font.bold: itemunread
                        anchors.left: parent.left
                        width: parent.width - 64
                    }

                    /*
                    Image {
                        id: imgStar
                        anchors.right: parent.right
                        source: itemstarred ? "../star-filled.png" : "../star-unfilled.png"
                        width: 64
                        height: 64

                    }
                    */
                }

                Item {
                    id: titleRow
                    anchors.left: parent.left
                    anchors.right: parent.right

                    height: childrenRect.height
                    anchors.margins: 0

                    Label {
                        id: txtAuthor
                        text: itemauthor
                        color: Theme.secondaryHighlightColor
                        font.pixelSize: Theme.fontSizeSmall
                        anchors.left: parent.left
                        width: parent.width / 2
                        clip: true
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        id: txtPubDate
                        text: timeDifference(new Date(), new Date(itempubdate));
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
                    text: itembody
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeExtraSmall
                    wrapMode: Text.Wrap
                    anchors.left: parent.left
                    anchors.right: parent.right
                    clip: true
                    maximumLineCount: 3

                }
            }


        }
    }
}





