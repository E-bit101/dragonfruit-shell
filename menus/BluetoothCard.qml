import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import "../util"

Rectangle {
    property bool collapsed: true
    property string deviceName: "Unknown Device"
    property bool isConnected: false
    property bool isPaired: false
    property real battery: -1.0
    property string deviceAddress: ""

    color: collapsed ? 'transparent' : '#08ffffff'
    radius: 3
    height: collapsed ? 42 : 100
    width: parent.parent.width

    Row {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 10
        spacing: 10
        MaterialIcon {
            icon: "bluetooth"
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: deviceName
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            collapsed = !collapsed
        }
    }

    Rectangle {
        id: connectionButton
        visible: !collapsed
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        color: isConnected 
            ? mouseArea1.containsMouse ? '#22646464' : '#22727272'
            : mouseArea1.containsMouse ? '#22337ad2' : '#223c70b0'
        radius: 3
        width: txt.width + 64
        height: txt.height + 12

        Text {
            id: txt
            text: isConnected ? "Disconnect" : "Connect"
            anchors.centerIn: parent
            color: "white"
        }

        Process {
            id: disconnect

            command: ["bluetoothctl", "disconnect", deviceAddress]
        }

        Process {
            id: connect

            command: ["bluetoothctl", "connect", deviceAddress]
        }

        MouseArea {
            id: mouseArea1
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                if (isConnected) {
                    disconnect.running = true
                    collapsed = true
                } else {
                    connect.running = true
                }
            }
        }
    }
}