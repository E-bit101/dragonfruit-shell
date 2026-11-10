import Quickshell
import QtQuick
import "../util"

MaterialIcon {
    icon: {
        if (BatteryInfo.isCharging) { return "battery_android_bolt" }
        return "battery_android_full"
    }
    iconColor: "grey"

    Item {
        width: parent.width * 0.6
        height: parent.height
        clip: true

        MaterialIcon {
            icon: "battery_android_full"
            iconSize: parent.parent.iconSize
            iconColor: "gray"
        }
    }

    Item {
        width: parent.width * Math.max(BatteryInfo.percentage - 0.05, 0.15)
        height: parent.height
        clip: true

        MaterialIcon {
            property double c_opacity: 0.5
            icon: "battery_android_full"
            iconSize: parent.parent.iconSize
            iconColor: BatteryInfo.percentage < 0.2 ? Generic.mixColors("#ff8888", "#ffffff", Math.abs(c_opacity)) : "white"

            NumberAnimation on c_opacity {
                loops: Animation.Infinite
                easing: Easing.InOutSine
                from: -1.0
                to: 1.0
                duration: 5000
            }
        }
    }

    // MaterialIcon {
    //     icon: "battery_android_0"
    //     // icon: {
    //     //     if (!BatteryInfo.available)
    //     //         return "battery_android_question";
    //     //     if (BatteryInfo.isCharging)
    //     //         return "battery_android_bolt";
    //     //     if (BatteryInfo.isFull)
    //     //         return "battery_android_full";
    //     //     var icons = ["0", "1", "2", "3", "4", "5", "6", "full"];
    //     //     return "battery_android_" + icons[Math.floor(BatteryInfo.percentage * 7)];
    //     // }
    //     iconSize: parent.iconSize
    // }

    Text {
        text: Math.round(BatteryInfo.percentage * 100)
        font.pixelSize: 10
        font.weight: 500
        anchors.centerIn: parent
        transform: Translate {
            x: {
                if (BatteryInfo.isCharging && BatteryInfo.percentage < 0.7) { return -3.5 }
                if (BatteryInfo.isCharging && BatteryInfo.percentage < 0.85) { return -2 }
                return -1
            }
            y: 0.5
        }
    }

    transform: Translate {
        x: 2
    }
}
