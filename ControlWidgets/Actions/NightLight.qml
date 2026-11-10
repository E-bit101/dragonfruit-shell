import QtQuick
import Quickshell.Io
import Quickshell
import "../../ControlWidgets" as CW
import "../../util"

CW.Action { 
    toggled: SystemInfo.nightMode
    optionName: "Night Light"
    optionIcon: "bedtime"
    toggleOn: Process {
        command: ["wlsunset", "-T", "4001"]
    }
    toggleOff: Process {
        command: ["pkill", "wlsunset"]
    }
}