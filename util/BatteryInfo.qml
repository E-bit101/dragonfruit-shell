pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root
    
    readonly property bool available: UPower.displayDevice?.isLaptopBattery ?? false
    readonly property real percentage: UPower.displayDevice.percentage ?? 0
    readonly property var chargeState: UPower.displayDevice?.state ?? null
    readonly property bool isCharging: chargeState === UPowerDeviceState.Charging
    readonly property bool isPluggedIn: isCharging || chargeState === UPowerDeviceState.PendingCharge
    readonly property bool isFull: chargeState === UPowerDeviceState.FullyCharged
    readonly property bool isLow: available && percentage <= 0.20
    readonly property bool isCritical: available && percentage <= 0.10
    readonly property real energyRate: UPower.displayDevice?.changeRate ?? 0
    readonly property real timeToEmpty: UPower.displayDevice?.timeToEmpty ?? 0
    readonly property real timeToFull: UPower.displayDevice?.timeToFull ?? 0
}