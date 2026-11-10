import QtQuick
import Quickshell.Io
import Quickshell
import "../../ControlWidgets" as CW
import "../../util"
import "../../menus"

CW.Action { 
    toggled: Netinfo.isWifiRadioActive
    optionName: Netinfo.wifiName == "" ? "Not connected" : Netinfo.wifiName
    optionIcon: "wifi"
    optionMenu: Networks {}
    toggleOn: Process {
        command: ["nmcli", "radio", "wifi", "on"]
    }
    toggleOff: Process {
        command: ["nmcli", "radio", "wifi", "off"]
    }
}