import bb.cascades 1.0

Container {
    id: listItemContainer
    property string title: ""
    property string body: ""
    property string link: ""
    property string author: ""
    property string pubdate: ""
    property bool unread: false
    property bool starred: false

    leftPadding: 30
    rightPadding:30
    topPadding: 15
    bottomPadding: 15

    background: listItemContainer.ListItem.active ? Color.create("#18AFE2") : back.imagePaint

    Container {

        Label {
            id: lblTitle
            multiline: true
            text: title

            textStyle {
                base: SystemDefaults.TextStyles.TitleText
                color: Color.Black
                fontWeight: unread? FontWeight.Bold : FontWeight.Normal
            }
        }

        Container {
            layout: StackLayout {
                orientation:  LayoutOrientation.LeftToRight
            }

            Label {
                id: lblAuthor
                text: author

                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }

                textStyle {
                    base: SystemDefaults.TextStyles.TitleText
                    color: Color.Black
                    fontSize: FontSize.Small
                }
            }
            Label {
                id: lblDate
                text: pubdate
                horizontalAlignment: HorizontalAlignment.Right
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }

                textStyle {
                    base: SystemDefaults.TextStyles.TitleText
                    color: Color.Black
                    fontSize: FontSize.Small
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
        /*
        WebView {
            id: bodyHtml
            //multiline: true
            html: "<html>" + body + "</html>"

            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }

            textStyle {
                base: SystemDefaults.TextStyles.BodyText
                color: Color.DarkGray
                textAlign: TextAlign.Left
            }

        }*/

    }
    attachedObjects: [
            ImagePaintDefinition {
                id: back
                imageSource: "asset:///gradient.png"
                repeatPattern: RepeatPattern.X
            }
        ]

}
