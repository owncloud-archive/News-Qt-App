import QtQuick 1.1

Rectangle {
    id: intro
    signal continueClicked();
    signal settingsClicked();

    property alias ownCloudURL: inpOwnCloudUrl.text
    property alias username: inpUsername.text
    property alias password: inpPassword.text

    property bool landscape: (height < width)

    Flickable {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: btnContinue.top

        flickableDirection: Flickable.VerticalFlick
        clip: true

        Image {
            id: imgLogo
            source: "../ownNews1024.png"
            width: landscape ?  parent.width / 2 - 10 : parent.width - 10
            height: width * (sourceSize.height / sourceSize.width)
            x: 5
            y: 5
            fillMode: Image.PreserveAspectFit
        }

        Column {
            anchors.topMargin: 40
            anchors.top: landscape ? imgLogo.top : imgLogo.bottom
            anchors.left: landscape ? imgLogo.right : parent.left
            anchors.right: parent.right
            anchors.margins: 10
            spacing: 10

            Text {
                text: "ownCloud URL:"
                font.pointSize: 12
                font.bold: true
            }

            PGZInput {
                id: inpOwnCloudUrl
                width: parent.width
                fontSize: 12

            }
            Text {
                text: "Username:"
                font.pointSize: 12
                font.bold: true
            }

            PGZInput {
                id: inpUsername
                width: parent.width
                fontSize: 12
            }

            Text {
                text: "Password:"
                font.pointSize: 12
                font.bold: true
            }

            PGZInput {
                id: inpPassword
                width: parent.width
                height: 40
                password: true
                fontSize: 14
            }

        }

    }

    PGZButton {
        id: btnContinue
        anchors.bottom: parent.bottom
        anchors.right: parent.right
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
        anchors.left: parent.left
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
