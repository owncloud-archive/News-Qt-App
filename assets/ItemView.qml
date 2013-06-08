import bb.cascades 1.0
import com.kdab.components 1.0
import uk.co.piggz 1.0

Page {
    id: itemView
    property string title: ""
    property string body: ""
    property string link: ""
    property string author: ""
    property string pubdate: ""
    property bool unread: false
    property bool starred: false

    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            onTriggered: {
                navigationPane.pop()
            }
        }
    }

    Container {

        leftPadding: 30
        rightPadding:30
        topPadding: 15
        bottomPadding: 15

        Label {
            id: lblTitle
            multiline: true
            text: title

            textStyle {
                base: SystemDefaults.TextStyles.TitleText
                color: Color.Black
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

            text: body

            textStyle {
                base: SystemDefaults.TextStyles.BodyText
                color: Color.DarkGray
                textAlign: TextAlign.Left
            }

        }
    }
}


