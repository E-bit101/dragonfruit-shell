pragma Singleton

import Quickshell
import Quickshell.Networking
import Quickshell.Bluetooth

Singleton {
    id: root

    readonly property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property var connectedNetwork: wifiDevice?.networks.values.find(n => n.connected) ?? null
    readonly property int wifiSignal: connectedNetwork ? Math.round(connectedNetwork.signalStrength * 100) : -1
    readonly property string wifiName: connectedNetwork?.name ?? ""
    readonly property bool isWifiRadioActive: Networking.wifiEnabled

    readonly property var bluetoothAdapter: Bluetooth.defaultAdapter
    readonly property bool isBluetoothActive: bluetoothAdapter?.enabled ?? false
    readonly property var bluetoothDevices: Bluetooth.devices
}