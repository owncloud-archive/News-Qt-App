import QtQuick 1.1

Rectangle {
    id: root

    Item {
        id: content
        height: root.height
        width: root.width * 3
        x: 0
        y: 0

        Behavior on x {
            NumberAnimation { duration: 200 }
        }

        Intro {
            id: intro
            height: root.height
            width: root.width
            anchors.top: parent.top
            anchors.left: parent.left

            onContinueClicked: {
                //navigate to feeds

                console.log("continue");

                _ownCloudURL = intro.ownCloudURL;
                _username = intro.username;
                _password = intro.password;

                saveSettings();

                content.x = -root.width
            }

        }

        Feeds {
            id:feeds
            height: root.height
            width: root.width
            anchors.top: parent.top
            anchors.left: intro.right

            onBackClicked: {
                //navigate to intro
                content.x = 0
            }

            onFeedClicked: {
                console.log(feedId);
                NewsInterface.viewItems(feedId);
                content.x = root.width * -2
            }
        }

        Items {
            id:items
            height: root.height
            width: root.width
            anchors.top: parent.top
            anchors.left: feeds.right

            onBackClicked: {
                //navigate to intro
                content.x = -root.width
            }

            onItemClicked: {
                console.log(itemId);
            }
        }

    }

    Component.onCompleted: {
        loadSettings();
    }


    property string _ownCloudURL: ""
    property string _username: ""
    property string _password: ""

    function loadSettings() {
        console.log("Loading Settings");
        _ownCloudURL = Helper.getSetting("ownCloudURL", "");
        _username = Helper.getSetting("username", "");
        _password = Helper.getSetting("password", "");

        console.log(_ownCloudURL, _username, _password);

        if (_ownCloudURL != "") {
            intro.ownCloudURL = _ownCloudURL;
        }

        if (_username != "") {
            intro.username = _username;
        }

        if (_password != "") {
            intro.password = _password;
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
