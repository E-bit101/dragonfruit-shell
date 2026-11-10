import QtQuick
import QtQuick.Controls
import Quickshell
import QtQuick.Controls.Basic
import "../widgets" as Widgets
import "../util"

Row {
    property int silly: 0

    anchors.horizontalCenter: parent.horizontalCenter
    width: 300
    MaterialIcon {
        icon: "light_mode"
        anchors.verticalCenter: parent.verticalCenter
    }

    Slider {
        id: brightnessControl
        value: SystemInfo.displayBrightness
        from: 0
        to: 100
        width: 250
        anchors.verticalCenter: parent.verticalCenter

        background: Rectangle {
            x: brightnessControl.leftPadding
            y: brightnessControl.topPadding + brightnessControl.availableHeight / 2 - height / 2
            height: 6
            width: brightnessControl.availableWidth
            radius: 4
            border.color: '#363636'
            color: '#1e1e1e'

            Rectangle {
                width: brightnessControl.visualPosition * parent.width
                height: parent.height
                color: shell.accentColor
                radius: parent.radius
                border.color: "#2D80C9"
                border.width: 1

                Behavior on width {
                    NumberAnimation { duration: silly; easing.type: Easing.OutBounce }
                }
            }
        }

        handle: Rectangle {
            x: brightnessControl.leftPadding + brightnessControl.visualPosition * (brightnessControl.availableWidth - width)
            y: brightnessControl.topPadding + brightnessControl.availableHeight / 2 - height / 2
            implicitWidth: 16
            implicitHeight: 16
            radius: 8
            color: shell.accentColor
            border.color: '#3c3c3c'
            border.width: {
                if (brightnessControl.pressed) { return 5 }
                if (brightnessControl.hovered) { return 3 }
                return 4
            }
            Behavior on border.width {
                NumberAnimation { duration: 100; }
            }
            Behavior on x {
                NumberAnimation { duration: silly; easing.type: Easing.OutBounce }
            }
        }

        onMoved: Quickshell.execDetached({
            command: ["brightnessctl", "set", `${Math.round(value)}%`]
        })
    }

    Rectangle {
        color: mouseArea.containsMouse ? '#10ffffff' : "#00000000"
        width: 30
        height: 30
        radius: 3

        MaterialIcon {
            icon: "arrow_forward_ios"
            anchors.centerIn: parent
            iconSize: 16
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                popup.visible = false;
            }
        }
    }
}
