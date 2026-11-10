import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Quickshell.Io
import "../widgets" as Widgets
import "../util"

Column {
    property string optionName: "undefined"
    property string optionIcon: ""
    property Item optionMenu: null
    property Process toggleOn: null
    property Process toggleOff: null
    property bool toggled: false
    signal toggleRequested(bool value)
    readonly property string buttonColor: toggled ? shell.accentColor : '#2f515151'

    spacing: 5

    Rectangle {
        color: mouseArea1.containsMouse ? Generic.mixColors(buttonColor, "#000000", 0.1) : buttonColor
        width: 100
        height: 50
        radius: 4
        border.width: 1
        border.color: toggled ? "#2D80C9" : '#2f888888' 

        MaterialIcon {
            icon: optionIcon
            anchors.verticalCenter: parent.verticalCenter
            iconSize: optionMenu == null ? 20 : 16
            anchors.left: parent.left
            anchors.leftMargin: parent.width / (optionMenu == null ? 2 : 4) - width / 2
        }

        MouseArea {
            id: mouseArea1
            anchors.fill: parent
            hoverEnabled: true

            onClicked: { 
                toggled = !toggled 
                toggleRequested(toggled)
                if (toggled && toggleOn) {toggleOn .running = true}
                else if (toggleOff)      {toggleOff.running = true}
            }
        }

        Rectangle {
            visible: optionMenu != null
            color: mouseArea2.containsMouse ? Generic.mixColors(buttonColor, "#000000", 0.1) : buttonColor
            width: parent.width / 2
            height: parent.height
            bottomRightRadius: parent.radius
            topRightRadius: parent.radius
            anchors.right: parent.right
            border.color: parent.border.color
            border.width: parent.border.width

            MaterialIcon {
                icon: "arrow_forward_ios"
                anchors.centerIn: parent
                iconSize: 16
            }

            MouseArea {
                id: mouseArea2
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    popup.menuVisible = false
                    optionMenu.parent = popup.contentItem
                    optionMenu.isVisible = true
                }
            }
        }
    }

    Text {
        text: optionName
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
    }
}
