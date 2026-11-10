import QtQuick
import Quickshell

PanelWindow {
    anchors {
        bottom: true
        right: true
    }

    margins {
        bottom: 6
        right: 6
    }

    implicitWidth: 350
    implicitHeight: 400

    visible: false

    color: '#00000000'

    Rectangle {
        anchors.fill: parent
        color: '#aa262626'
        radius: 4
    }
}