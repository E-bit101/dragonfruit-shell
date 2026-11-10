import QtQuick
import Quickshell.Io
import "../util"

Rectangle {
    width: parent.width
    height: 42
    color: '#88191a1b'
    bottomLeftRadius: root.cornerRadius
    bottomRightRadius: root.cornerRadius

    property string linkText: ""
    property string linkcmd: ""

    Process {
        id: settings
        command: ["sh", "-c", SystemInfo.settingscmd]
    }

    Process {
        id: account
        command: ["sh", "-c", SystemInfo.accountscmd]
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        color: mouseArea1.containsMouse ? '#10ffffff' : "#00000000"
        width: 30
        height: 30
        radius: 3
        visible: linkText == ""

        MaterialIcon {
            icon: "account_circle"
            anchors.centerIn: parent
        }

        MouseArea {
            id: mouseArea1
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                account.running = true
                popup.visible = false
            }
        }
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        color: mouseArea2.containsMouse ? '#10ffffff' : "#00000000"
        width: 30
        height: 30
        radius: 3
        visible: linkText == ""

        MaterialIcon {
            icon: "settings"
            anchors.centerIn: parent
        }

        MouseArea {
            id: mouseArea2
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                settings.running = true
                popup.visible = false
            }
        }
    }

    Text {
        text: linkText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 15
        color: mouseArea3.containsMouse ? '#adcdde' : '#8e8e8e'

        Process {
            id: linkCmd
            command: ["sh", "-c", linkcmd]
        }

        MouseArea {
            id: mouseArea3
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                linkCmd.running = true
                popup.visible = false
            }
        }
    }
}
