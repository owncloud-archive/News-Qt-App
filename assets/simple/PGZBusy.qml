import QtQuick 1.1

Item {
    id: busy
    property bool running: false
    property color background: "#cccccc"
    visible: running

    property int count: 0

    Timer {
        id: tmr
        interval: 100
        repeat: true
        running: busy.running
        onTriggered: {
            count++;
            if (count > 8) {
                count = 1;
            }
        }
    }

    Grid {
        columns: 3
        anchors.fill: parent
        spacing: 2

        Rectangle {
            id: r1
            width: busy.width / 3
            height: width
            color: background
            opacity: (busy.count == 1) ? 0.1 : 1
        }

        Rectangle {
            width: busy.width / 3
            height: width
            color: background
            opacity: (busy.count == 2) ? 0.1 : 1
        }

        Rectangle {
            width: busy.width / 3
            height: width
            color: background
            opacity: (busy.count == 3) ? 0.1 : 1
        }

        Rectangle {
            width: busy.width / 3
            height: width
            color: background
            opacity: (busy.count == 8) ? 0.1 : 1
        }

        Rectangle {
            width: busy.width / 3
            height: width
            color: background
        }

        Rectangle {
            width: busy.width / 3
            height: width
            color: background
            opacity: (busy.count == 4) ? 0.1 : 1
        }

        Rectangle {
            width: busy.width / 3
            height: width
            color: background
            opacity: (busy.count == 7) ? 0.1 : 1
        }

        Rectangle {
            width: busy.width / 3
            height: width
            color: background
            opacity: (busy.count == 6) ? 0.1 : 1
        }

        Rectangle {
            width: busy.width / 3
            height: width
            color: background
            opacity: (busy.count == 5) ? 0.1 : 1
        }

    }

}
