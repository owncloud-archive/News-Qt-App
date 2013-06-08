import bb.cascades 1.0
import com.kdab.components 1.0
import uk.co.piggz 1.0

Page {
    id: itemPage
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            onTriggered: {
                navigationPane.pop()
            }
        }
    }
    Container {
        layout: DockLayout {}

        ListView {
            dataModel: abstractItemsModel

            listItemComponents: [
                ListItemComponent {
                    type: ""
                    NewsItem {
                        title: ListItemData.itemtitle
                        body: ListItemData.itembody
                        link: ListItemData.itemlink
                        author: ListItemData.itemauthor
                        pubdate: ListItemData.itempubdate
                        unread: ListItemData.itemunread
                        starred: ListItemData.itemstarred
                    }

                }
            ]


            attachedObjects: [
                AbstractItemModel {
                    id: abstractItemsModel

                    sourceModel: NewsInterface.itemsModel
                }
            ]
        }

    }
}


