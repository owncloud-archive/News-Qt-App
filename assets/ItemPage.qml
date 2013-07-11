import bb.cascades 1.0
import com.kdab.components 1.0
import uk.co.piggz 1.0
import "DateFunctions.js" as DateFunctions

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

            onTriggered: {
                var selectedItem = dataModel.data(indexPath);
                console.log (selectedItem.itemtitle);

                var page = getItemViewPage();
                navigationPane.push(page);

                page.title = selectedItem.itemtitle;
                page.body = selectedItem.itembodyhtml;
                page.link = selectedItem.itemlink;
                page.author = selectedItem.itemauthor;
                page.pubdate = DateFunctions.timeDifference(new Date(), selectedItem.itempubdate);
                page.unread = selectedItem.itemunread;
                page.starred = selectedItem.itemstarred;
            }


            property Page itemViewPage

            function getItemViewPage() {
                if (! itemViewPage) {
                    itemViewPage = itemPageDefinition.createObject();
                }
                return itemViewPage;
            }

            attachedObjects: [
                ComponentDefinition {
                    id: itemPageDefinition
                    source: "ItemView.qml"
                },
                AbstractItemModel {
                    id: abstractItemsModel

                    sourceModel: NewsInterface.itemsModel
                }
            ]
        }

    }


}


