import bb.cascades 1.0
import com.kdab.components 1.0

NavigationPane {
    id: navigationPane

    property string ownCloudURL: ""
    property string username: ""
    property string password: ""
    property int daysToRetain: 0
    property int numberItemsToSync: 0

    function loadSettings() {
        console.log("Loading Settings");
        ownCloudURL = Helper.getSetting("ownCloudURL", "");
        username = Helper.getSetting("username", "");
        password = Helper.getSetting("password", "");
        daysToRetain = Helper.getSetting("daysToRetain", 14);
        numberItemsToSync = Helper.getSetting("numberItemsToSync", 20);

        if (ownCloudURL != "") {
            txtOwnCloud.text = ownCloudURL
        }

        if (username != "") {
            txtUsername.text = username;
        }

        if (password != "") {
            txtPassword.text = password;
        }
    }

    function saveSettings() {
        console.log("Saving Settings");
        Helper.setSetting("ownCloudURL", ownCloudURL);
        Helper.setSetting("username", username);
        Helper.setSetting("password", password);
        Helper.setSetting("daysToRetain", daysToRetain);
        Helper.setSetting("numberItemsToSync", numberItemsToSync);
    }

    Page {

        Container {
            topPadding: 30
            leftPadding: 30
            bottomPadding: 30
            rightPadding: 30

            ImageView {
                imageSource: "ownNews1024.png"
                scalingMethod: ScalingMethod.AspectFit
            }

            Label {
                text: "ownCloud URL:"
            }

            TextField {
                id: txtOwnCloud
                hintText: "http://www.yourdomain.com/owncloud"
            }

            Label {
                text: "Username:"
            }

            TextField {
                id: txtUsername

            }

            Label {
                text: "Password:"
            }

            TextField {
                id: txtPassword
                inputMode: TextFieldInputMode.Password
            }

            Container {
                layout: StackLayout {
                    orientation:  LayoutOrientation.LeftToRight
                }

                Button {

                    text: qsTr("Continue")

                    onClicked: {
                        ownCloudURL = txtOwnCloud.text;
                        username = txtUsername.text;
                        password = txtPassword.text;

                        saveSettings();

                        var page = getFeedPage();
                        navigationPane.push(page);
                    }

                    property Page feedPage

                    function getFeedPage() {
                        if (! feedPage) {
                            feedPage = feedPageDefinition.createObject();
                        }
                        return feedPage;
                    }

                    attachedObjects: [
                        ComponentDefinition {
                            id: feedPageDefinition
                            source: "FeedPage.qml"
                        }
                    ]
                }
                Button {
                    text: qsTr("Advanced")
                    onClicked: {
                        var page = getAdvancedPage();
                        navigationPane.push(page);
                    }

                    property Page advancedPage

                    function getAdvancedPage() {
                        if (! advancedPage) {
                            advancedPage = advancedPageDefinition.createObject();
                            advancedPage.daysToRetainChanged.connect(daysToRetainChanged);
                            advancedPage.numberItemsToSyncChanged.connect(numberItemsToSyncChanged);

                            advancedPage.setDaysToRetain(daysToRetain);
                            advancedPage.setNumItemsToSync(numberItemsToSync);
                        }
                        return advancedPage;
                    }

                    attachedObjects: [
                        ComponentDefinition {
                            id: advancedPageDefinition
                            source: "AdvancedPage.qml"
                        }
                    ]
                }

            }
        }
    }
    onCreationCompleted: {
        console.log("NavigationPane - onCreationCompleted()");
        OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.All;
        Qt.NewsInterface = NewsInterface;

        loadSettings();
    }

    function daysToRetainChanged(days)
    {
        console.log(days)
        daysToRetain = days;
    }

    function numberItemsToSyncChanged(numitems)
    {
        numberItemsToSync = numitems;
    }


}


