import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Label {
        id: label
        anchors.centerIn: parent
        text: "newsFish"
    }
    
    CoverActionList {
        id: coverAction
        
        CoverAction {
            iconSource: "image://theme/icon-cover-sync"
            onTriggered: {
                 NewsInterface.sync(_ownCloudURL, _username, _password, 10)
            }
        }
    }
}


