// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {

    signal buttonClicked()
    property color fillColor: "#999999"
    property string buttonText: ""

    Rectangle {
        anchors.centerIn: parent
        width: rectPGZButton.width - 10
        height: rectPGZButton.height - 10
        opacity: 0.3
        color: "white"
        radius: 7
        z: 2
    }

    Text {
        anchors.fill: parent
        text: buttonText
        font.pixelSize: 30
        color: "#444444"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        z: 1
    }

    Rectangle {
        id: rectPGZButton
        anchors.fill:parent
        radius: 10
        color: fillColor
        state: "RELEASED"
        z: 0


        states: [
                 State {
                     name: "PRESSED"
                     PropertyChanges { target: rectPGZButton; color: "#666666"}
                 },
                 State {
                     name: "RELEASED"
                     PropertyChanges { target: rectPGZButton; color: fillColor}
                 }
             ]

             transitions: [
                 Transition {
                     from: "PRESSED"
                     to: "RELEASED"
                     ColorAnimation { target: rectPGZButton; duration: 100}
                 },
                 Transition {
                     from: "RELEASED"
                     to: "PRESSED"
                     ColorAnimation { target: rectPGZButton; duration: 100}
                 }
             ]

    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            buttonClicked();
        }

        onPressed: {
            rectPGZButton.state = "PRESSED"
        }

        onReleased: {
            rectPGZButton.state = "RELEASED"
        }
    }

}
