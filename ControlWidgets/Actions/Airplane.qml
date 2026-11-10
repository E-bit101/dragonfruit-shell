import QtQuick
import Quickshell.Io
import Quickshell
import "../../ControlWidgets" as CW
import "../../util"

CW.Action { 
    toggled: !(Netinfo.isBluetoothActive || Netinfo.isWifiRadioActive)
    optionName: "Airplane Mode"
    optionIcon: "travel"
    toggleOff: Process {
        command: ["sh", "-c", "bluetoothctl power on; nmcli radio wifi on"]
    }
    toggleOn: Process {
        command: ["sh", "-c", "bluetoothctl power off; nmcli radio wifi off"]
    }
}