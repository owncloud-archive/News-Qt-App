import bb.cascades 1.0

Container {
    id: listItemContainer
    property alias title: titleLabel.text
    property alias link: linkLabel.text
    property string favicon: ""

    leftPadding: 30
    topPadding: 15
    bottomPadding: 15

    background: listItemContainer.ListItem.active ? Color.create("#18AFE2") : Color.create("#018AFE2")


    Container {

        Label {
            id: titleLabel

            textStyle {
                base: SystemDefaults.TextStyles.TitleText
                color: Color.Black
            }
        }

        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }

            rightPadding: 80

            Label {
                id: linkLabel

                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }

                textStyle {
                    base: SystemDefaults.TextStyles.BodyText
                    color: Color.DarkGray
                    textAlign: TextAlign.Right
                }
            }
        }

    }

    /*
    ImageView {
        imageSource: "asset:///images/separator_line.png"
    }
    */
}
