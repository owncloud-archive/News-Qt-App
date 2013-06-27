import QtQuick 1.1

Rectangle {
    id: intro
    signal continueClicked();
    signal settingsClicked();

    property alias ownCloudURL: inpOwnCloudUrl.text
    property alias username: inpUsername.text
    property alias password: inpPassword.text

    Image {
        id: imgLogo
        source: "../ownNews1024.png"
        width: parent.width - 10
        height: width * (sourceSize.height / sourceSize.width)
        x: 5
        y: 5
        fillMode: Image.PreserveAspectFit
    }

    Column {
        anchors.topMargin: 40
        anchors.top: imgLogo.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10

        Text {
            text: "ownCloud URL:"
            font.pixelSize: 30
        }

        PGZInput {
            id: inpOwnCloudUrl
            width: parent.width
            height: 40
        }
        Text {
            text: "Username:"
            font.pixelSize: 30
        }

        PGZInput {
            id: inpUsername
            width: parent.width
            height: 40
        }
        Text {
            text: "Password:"
            font.pixelSize: 30
        }

        PGZInput {
            id: inpPassword
            width: parent.width
            height: 40
            password: true
        }

    }

    PGZButton {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 10

        height: 100
        width: 200

        buttonText: "Continue"

        onButtonClicked: {
            console.log(ownCloudURL, username, password);
            continueClicked();
        }
    }

    PGZButton {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 10
        buttonText: "Settings"
        height: 100
        width: 200

        onButtonClicked: {

        }
    }

    Component.onCompleted: {
        inpOwnCloudUrl.text = ownCloudURL;
    }

}
