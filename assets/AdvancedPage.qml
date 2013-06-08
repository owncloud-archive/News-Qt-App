import bb.cascades 1.0
import com.kdab.components 1.0
import uk.co.piggz 1.0

Page {
    id: advancedPage
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            onTriggered: {
                navigationPane.pop()
            }
        }
    }

    Container {
        topPadding: 30
        leftPadding: 30
        bottomPadding: 30
        rightPadding: 30

        Button {

            text: qsTr("Recreate Database")

            onClicked: {
                NewsInterface.recreateDatabase();
            }
        }
    }
}


