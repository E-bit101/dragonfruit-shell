import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import "../util"

Rectangle {
    property bool collapsed: true
    property string ssid: "Hidden Network"
    property int signalStrength: -1

    readonly property bool isCurrent: Netinfo.wifiName == ssid

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
            icon: {
                var icons = ["wifi_off", "wifi_1_bar", "wifi_2_bar", "wifi"]
                return icons[Math.min(Math.ceil(signalStrength * 0.05), 3)]
            }
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: ssid
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
        color: isCurrent 
            ? mouseArea1.containsMouse ? '#22646464' : '#22727272'
            : mouseArea1.containsMouse ? '#22337ad2' : '#223c70b0'
        radius: 3
        width: txt.width + 64
        height: txt.height + 12

        Text {
            id: txt
            text: isCurrent ? "Disconnect" : "Connect"
            anchors.centerIn: parent
            color: "white"
        }

        Process {
            id: disconnect
            command: ["sh", "-c", "nmcli device disconnect \"$(nmcli -t -f DEVICE,TYPE,STATE device status | awk -F: '$2==\"wifi\" && $3==\"connected\" {print $1; exit}')\""]
        }

        Process {
            id: connect
            command: ["nmcli", "c", "up", ssid]
        }

        MouseArea {
            id: mouseArea1
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                if (isCurrent) {
                    disconnect.running = true
                    collapsed = true
                } else {
                    connect.running = true
                }
            }
        }
    }
}