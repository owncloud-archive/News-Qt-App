import bb.cascades 1.0

Container {
    id: listItemContainer
    property alias title: titleLabel.text
    property alias link: linkLabel.text
    property string favicon: ""

    leftPadding: 30
    topPadding: 15
    bottomPadding: 15
    rightPadding: 30

    background: listItemContainer.ListItem.active ? Color.create("#18AFE2") : back.imagePaint

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
                orientation:  LayoutOrientation.LeftToRight
            }

            Container {
                layout: DockLayout {
                }

                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1.0
                }


                Label {
                    id: linkLabel

                    horizontalAlignment: HorizontalAlignment.Right
                    verticalAlignment: VerticalAlignment.Top

                    textStyle {
                        base: SystemDefaults.TextStyles.TitleText
                        color: Color.DarkGray
                        fontSize: FontSize.Small
                    }
                }
            }
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
