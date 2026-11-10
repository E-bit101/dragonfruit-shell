import Quickshell
import QtQuick
import "../util"

Rectangle {
    color: mouseArea.containsMouse ? '#10ffffff' : "#00000000"
    width: clock.width + 10
    height: 35
    radius: 3

    Text {
        anchors.centerIn: parent
        id: clock

        color: '#ffffff'

        text: SystemInfo.time
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 11
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            calendar.visible = !calendar.visible;
            popup.visible = false;
        }
    }
}
