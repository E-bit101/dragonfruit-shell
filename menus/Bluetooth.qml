import Quickshell
import QtQuick
import QtQuick.Controls
import "../util"
import "../ControlWidgets" as CW

Column {
    id: root

    property bool isVisible: false
    visible: isVisible && !popup.menuVisible
    Connections {
        target: popup
        function onMenuVisibleChanged() {
            if (!popup.menuVisible) {
                isVisible = false
            }
        }
    }

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        height: 50
        width: parent.width
        color: '#08ffffff'
        topLeftRadius: 8
        topRightRadius: 8

        CW.Toggle {
            checked: Netinfo.isBluetoothActive
            onClicked: Netinfo.bluetoothAdapter.enabled = checked
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 15
        }
    }

    ScrollView {
        anchors.centerIn: parent
        width: parent.width - 8
        height: 350

        Column {
            spacing: 5

            Repeater {
                model: Netinfo.bluetoothDevices

                BluetoothCard {
                    required property var modelData

                    collapsed: !modelData.connected
                    deviceName: modelData.name
                    isConnected: modelData.connected
                    isPaired: modelData.paired
                    deviceAddress: modelData.address

                    battery: modelData.batteryAvailable
                        ? Math.round(modelData.battery * 100)
                        : -1
                }
            }
        }
    }

    Row {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.leftMargin: 5
        spacing: 5

        Rectangle {
            color: mouseArea1.containsMouse ? '#10ffffff' : '#00000000'
            width: 40
            height: 40
            radius: 5

            MaterialIcon {
                icon: "arrow_back"
                anchors.centerIn: parent
                iconSize: 20
            }

            MouseArea {
                id: mouseArea1
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    root.isVisible = false
                    popup.menuVisible = true;
                }
            }
        }

        Text {
            text: "Networks"
            font.pixelSize: 16
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    CW.BottomBar {
        anchors.bottom: parent.bottom
        linkText: "More Bluetooth settings"
        linkcmd: SystemInfo.bluetoothsettingscmd
    }
}
