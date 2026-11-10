import Quickshell
import QtQuick
import Quickshell.Io
import "../util"

MaterialIcon {
    MaterialIcon {
        anchors.centerIn: parent
        icon: {
            var icons = ["wifi_off", "wifi_1_bar", "wifi_2_bar", "wifi"]
            return icons[Math.min(Math.ceil(Netinfo.wifiSignal * 0.05), 3)]
        }
    }
    icon: "wifi"
    iconColor: "gray"
}
