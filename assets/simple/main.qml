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
                content.x = root.width * -3
                item.title = itemTitle;
                item.body = itemBody;
                item.author = itemAuthor;
                item.unread = itemUnread;
                item.starred = itemStarred;
                item.pubdate = timeDifference(new Date(), new Date(itemPubDate));
            }
        }

        ItemView {
            id: item

            height: root.height
            width: root.width
            anchors.top: parent.top
            anchors.left: items.right

            onBackClicked: {
                //navigate to intro
                content.x = root.width * -2
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

    function timeDifference(current, previous) {
        var msPerMinute = 60 * 1000;
        var msPerHour = msPerMinute * 60;
        var msPerDay = msPerHour * 24;
        var msPerMonth = msPerDay * 30;
        var msPerYear = msPerDay * 365;

        var elapsed = current - previous;

        if (elapsed < msPerMinute) {
             return Math.round(elapsed/1000) + ' seconds ago';
        }

        else if (elapsed < msPerHour) {
             return Math.round(elapsed/msPerMinute) + ' minutes ago';
        }

        else if (elapsed < msPerDay ) {
             return Math.round(elapsed/msPerHour ) + ' hours ago';
        }

        else if (elapsed < msPerMonth) {
            return 'approximately ' + Math.round(elapsed/msPerDay) + ' days ago';
        }

        else if (elapsed < msPerYear) {
            return 'approximately ' + Math.round(elapsed/msPerMonth) + ' months ago';
        }

        else {
            return 'approximately ' + Math.round(elapsed/msPerYear ) + ' years ago';
        }
    }
}
