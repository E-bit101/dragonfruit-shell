import QtQuick
import Quickshell.Io
import "./"
import "../util"

Rectangle {
    width: 35
    height: 35
    radius: 5
    color: mouseArea.containsMouse ? '#10ffffff' : "#00000000"

    Application {
        width: parent.width - 5
        height: parent.height - 5
        anchors.centerIn: parent
    
        iconName: "goverlay"
    }


    Process {
        id: launcher
        command: ["sh", "-c", SystemInfo.launchercmd]
        running: false
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: launcher.running = true
    }
}