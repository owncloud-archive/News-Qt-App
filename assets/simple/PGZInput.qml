// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: pgzinput
    property color fillColor: "#cccccc"
    property int fontSize: 20
    property alias  text: input.text
    property bool password: false

    property int preferredHeight: input.font.pixelSize + 25

    Component.onCompleted: {
        height = preferredHeight;
    }

    Rectangle {
        id: rectOuter
        radius: 10
        color: fillColor
        z: 0
        anchors.fill: parent



        Rectangle {
            id:rectInner
            anchors.fill: parent
            anchors.margins: 5
            color: "white"
            radius: 7
            z: 1


            TextInput {
                id: input
                anchors.fill: parent
                anchors.margins: 5
                font.pointSize: fontSize

                color: "#444444"
                horizontalAlignment: Text.AlignHCenter
                anchors.verticalCenter: parent.verticalCenter
                echoMode: password ? TextInput.Password : TextInput.Normal
            }
        }
    }



}
