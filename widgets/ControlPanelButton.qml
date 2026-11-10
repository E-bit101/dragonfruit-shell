import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell
import "./"

Rectangle {
    width: 95
    height: 35
    radius: 3
    color: mouseArea.containsMouse ? '#10ffffff' : "#00000000"

    RowLayout {
        anchors.leftMargin: 8
        anchors.fill: parent
        Wifi { iconSize: 20 }
        Battery { iconSize: 24 }
        Audio { iconSize: 20 }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            popup.visible = !popup.visible;
            if (popup.visible) { popup.menuVisible = true }
            calendar.visible = false;
        }
    }
}