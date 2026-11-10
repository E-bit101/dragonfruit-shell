import QtQuick
import Quickshell.Io
import Quickshell
import "../../ControlWidgets" as CW
import "../../util"

CW.Action { 
    toggled: SystemInfo.powerProfile == "power-saver"
    optionName: "Power Saver"
    optionIcon: "energy_savings_leaf"
    toggleOn: Process {
        command: ["powerprofilesctl", "set", "power-saver"]
    }
    toggleOff: Process {
        command: ["powerprofilesctl", "set", "performance"]
    }
}