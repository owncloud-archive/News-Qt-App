// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: pgzinput
    property color fillColor: "#cccccc"
    property int fontSize: 20
    property alias  text: input.text

    Rectangle {
        anchors.centerIn: parent
        width: rectPGZButton.width - 10
        height: rectPGZButton.height - 10
        color: "white"
        radius: 7
        z: 1

        TextInput {
            id: input
            anchors.fill: parent
            font.pixelSize: fontSize
            color: "#444444"
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Rectangle {
        id: rectPGZButton
        anchors.fill:parent
        radius: 10
        color: fillColor
        z: 0

    }

}
