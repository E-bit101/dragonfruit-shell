import QtQuick
import Quickshell.Io
import Quickshell
import "../../ControlWidgets" as CW
import "../../util"
import "../../menus"

CW.Action { 
    toggled: Netinfo.isBluetoothActive
    optionName: "Bluetooth"
    optionIcon: "bluetooth"
    optionMenu: Bluetooth {}
    toggleOn: Process {
        command: ["bluetoothctl", "power", "on"]
    }
    toggleOff: Process {
        command: ["bluetoothctl", "power", "off"]
    }
}