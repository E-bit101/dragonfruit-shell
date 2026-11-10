import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../ControlWidgets" as CW
import "../ControlWidgets/Actions" as Actions
import "../util"

// Requires: nmcli, bluetoothctl, powerprofilesctl, wlsunset

PanelWindow {
    property int cornerRadius: 8
    property bool menuVisible: true

    id: root
    WlrLayershell.namespace: "rounded-panel"

    anchors {
        bottom: true
        right: true
    }

    margins {
        bottom: 6
        right: 6
    }

    implicitHeight: container.height
    implicitWidth: 375
    visible: false
    color: '#00000000'

    Rectangle {
        anchors.fill: parent
        color: '#aa262626'
        radius: cornerRadius

        Column {
            id: container
            width: parent.width
            visible: menuVisible
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            Item { 
                height: 5
                width: 1
            }

            Grid {
                columns: 3
                spacing: 15
                rowSpacing: 20
                anchors.horizontalCenter: parent.horizontalCenter
                Actions.Wifi { }
                Actions.Bluetooth  { }
                Actions.Airplane {}
                Actions.PowerProfiles { }
                CW.Action { 
                    toggled: SystemInfo.doNotDisturb; optionName: "Do not disturb"; optionIcon: "notifications_off" 
                    onToggleRequested: value => { SystemInfo.doNotDisturb = value }
                }
                CW.Action { 
                    toggled: false; optionName: "Accessibility"; optionIcon: "settings_accessibility"; 
                    onToggleRequested: value => { toggled = false } 
                    toggleOff: Process { command: ["alacritty", "-e", "cmatrix"] }
                }
                Actions.NightLight { }
            }

            Rectangle {
                height: 1
                width: parent.width - 10
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
            }

            CW.Brightness {}
            CW.Audio {}
            CW.BottomBar {}
        }
    }
}