import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Silica.theme 1.0


Page {
    id: page
    
    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        
        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: "Settings"
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
        }
        
        // Tell SilicaFlickable the height of its content.
        contentHeight: childrenRect.height
        
        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: "ownNews Reader"
            }

            Label {
                x: Theme.paddingLarge
                text: "ownCloud URL:"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            TextField {
                id: txtOwnCloudURL
                x: Theme.paddingLarge
                placeholderText: "http://www.yourdomain.com/owncloud"
                anchors.right: parent.right
                anchors.left: parent.left
                inputMethodHints: Qt.ImhNoPredictiveText
            }
            Label {
                x: Theme.paddingLarge
                text: "Username:"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            TextField {
                id: txtOwnCloudUsername
                x: Theme.paddingLarge
                anchors.right: parent.right
                anchors.left: parent.left
            }
            Label {
                x: Theme.paddingLarge
                text: "Passowrd:"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            TextField {
                id: txtOwnCloudPassword
                x: Theme.paddingLarge
                anchors.right: parent.right
                anchors.left: parent.left
                echoMode: TextInput.PasswordEchoOnEdit
            }

            Button {
                id: btnContinue
                text: "Continue"

                onClicked: {

                    console.log("continue");

                    _ownCloudURL = txtOwnCloudURL.text;
                    _username = txtOwnCloudUsername.text;
                    _password = txtOwnCloudPassword.text;

                    saveSettings();

                    pageStack.push(Qt.resolvedUrl("FeedPage.qml"))
                }
            }

        }


    }

    Component.onCompleted: {
        loadSettings();
    }

    function loadSettings() {
        console.log("Loading Settings");
        _ownCloudURL = Helper.getSetting("ownCloudURL", "");
        _username = Helper.getSetting("username", "");
        _password = Helper.getSetting("password", "");

        console.log(_ownCloudURL, _username, _password);

        if (_ownCloudURL != "") {
            txtOwnCloudURL.text = _ownCloudURL;
        }

        if (_username != "") {
            txtOwnCloudUsername.text = _username;
        }

        if (_password != "") {
            txtOwnCloudPassword.text = _password;
        }
    }

    function saveSettings() {
        console.log("Saving Settings");
        Helper.setSetting("ownCloudURL", _ownCloudURL);
        Helper.setSetting("username", _username);
        Helper.setSetting("password", _password);

        console.log(_ownCloudURL, _username, _password);
    }



}


