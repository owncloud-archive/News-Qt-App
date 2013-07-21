import bb.cascades 1.0
import "DateFunctions.js" as DateFunctions

Container {
    id: listItemContainer
    property int itemid: 0
    property string title: ""
    property string body: ""
    property string link: ""
    property string author: ""
    property date pubdate: new Date()
    property bool unread: false
    property bool starred: false
    property string guid: ""
    property string guidhash: ""
    property int feedid: 0

    leftPadding: 30
    rightPadding:30
    topPadding: 15
    bottomPadding: 15

    background: listItemContainer.ListItem.active ? Color.create("#18AFE2") : back.imagePaint

    Container {
        layout: StackLayout {
            orientation:  LayoutOrientation.LeftToRight
        }

        Container {
            layout: DockLayout {        }

            layoutProperties: StackLayoutProperties {
                spaceQuota: 1.0
            }

            Label {
                id: lblTitle
                multiline: true
                text: title
                horizontalAlignment: HorizontalAlignment.Left
                verticalAlignment: VerticalAlignment.Top

                maxWidth: 600

                textStyle {
                    base: SystemDefaults.TextStyles.TitleText
                    color: Color.Black
                    fontWeight: unread ? FontWeight.Bold : FontWeight.Normal
                }
            }

            //Use this view until updating the star status works
            ImageView {
                horizontalAlignment: HorizontalAlignment.Right
                verticalAlignment: VerticalAlignment.Top
                preferredWidth: 96
                preferredHeight: 96
                imageSource: starred ? "star-filled.png" : "star-unfilled.png"
            }

            /*
            ImageToggleButton {
                id: btnStar
                horizontalAlignment: HorizontalAlignment.Right
                verticalAlignment: VerticalAlignment.Top
                preferredWidth: 96
                preferredHeight: 96
                checked: starred
                imageSourceDefault: "star-unfilled.png"
                imageSourceChecked: "star-filled.png"

                onCheckedChanged: {
                    Qt.NewsInterface.setItemStarred(feedid, guidhash, checked);
                }
            }
            */
        }

    }

    Container {

        layout: StackLayout {
            orientation:  LayoutOrientation.LeftToRight
        }

        Container {
            layout: DockLayout {
            }

            layoutProperties: StackLayoutProperties {
                spaceQuota: 1.0
            }

            Label {
                id: lblAuthor
                text: author

                horizontalAlignment: HorizontalAlignment.Left
                verticalAlignment: VerticalAlignment.Top

                textStyle {
                    base: SystemDefaults.TextStyles.TitleText
                    color: Color.Black
                    fontSize: FontSize.Small
                }
            }
            Label {
                id: lblDate
                text: DateFunctions.timeDifference(new Date(), new Date(pubdate));

                horizontalAlignment: HorizontalAlignment.Right
                verticalAlignment: VerticalAlignment.Top

                textStyle {
                    base: SystemDefaults.TextStyles.TitleText
                    color: Color.Black
                    fontSize: FontSize.Small
                }
            }
        }
    }

    Label {
        id: lblBody
        multiline: true
        autoSize {
            maxLineCount: 3
        }

        text: body

        textStyle {
            base: SystemDefaults.TextStyles.BodyText
            color: Color.DarkGray
            textAlign: TextAlign.Left
        }

    }


    attachedObjects: [
        ImagePaintDefinition {
            id: back
            imageSource: "asset:///gradient.png"
            repeatPattern: RepeatPattern.X
        }
    ]

}
