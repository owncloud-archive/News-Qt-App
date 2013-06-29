import bb.cascades 1.0
import com.kdab.components 1.0
import uk.co.piggz 1.0

Page {
    id: feedPage
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            onTriggered: {
                navigationPane.pop()
            }
        }
    }

    actions: [
            ActionItem {
                id: actionSync
                title: "Sync"
                onTriggered: NewsInterface.sync(ownCloudURL, username, password)
                ActionBar.placement: ActionBarPlacement.OnBar
                enabled: !NewsInterface.busy
            }
        ]

    Container {
        layout: DockLayout {}

        ActivityIndicator {
                id: myIndicator
                preferredWidth: 250
                running: NewsInterface.busy
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
            }

        ListView {
            dataModel: abstractFeedsModel

            listItemComponents: [
                ListItemComponent {
                    type: ""

                    FeedItem {
                        title: ListItemData.feedtitle
                        link: ListItemData.feedurl
                        favicon: ListItemData.feedicon
                    }

                }
            ]

            onTriggered: {
                var selectedItem = dataModel.data(indexPath);
                console.log (selectedItem.feedtitle);
                NewsInterface.viewItems(selectedItem.feedid);

                var page = getItemPage();
                navigationPane.push(page);
            }


            property Page itemPage

            function getItemPage() {
                if (! itemPage) {
                    itemPage = itemPageDefinition.createObject();
                }
                return itemPage;
            }

            function busyChanged(busy) {
                console.log("Busy Changed");
                myIndicater.running = busy;
                actionSync.enabled = !busy;
            }

            attachedObjects: [
                ComponentDefinition {
                    id: itemPageDefinition
                    source: "ItemPage.qml"
                },
                AbstractItemModel {
                    id: abstractFeedsModel
                    sourceModel: NewsInterface.feedsModel
                }

            ]
        }

    }
}


