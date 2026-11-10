pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property string launchercmd: ""
    readonly property string settingscmd: ""
    readonly property string accountscmd: ""
    readonly property string wifisettingscmd: ""
    readonly property string bluetoothsettingscmd: ""

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property bool preciseTime: true
    readonly property string powerProfile: PowerProfile.toString(PowerProfiles.profile).toLowerCase()

    property bool nightMode: false
    property bool doNotDisturb: false
    property real audioVolume: Pipewire.defaultAudioSink?.audio?.volume ?? -1

    property string backlightDevice: ""
    property int maxBrightness: 0
    property real displayBrightness: 100

    Process {
        id: backlightDetectProc

        command: ["sh", "-c",
            "for d in /sys/class/backlight/*; do " +
            "[ -d \"$d\" ] && basename \"$d\" && break; " +
            "done"
        ]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const device = text.trim()

                if (device.length > 0) {
                    root.backlightDevice = device
                    maxBrightnessFile.reload()
                    brightnessFile.reload()
                }
            }
        }
    }

    FileView {
        id: brightnessFile

        path: root.backlightDevice.length > 0
            ? "/sys/class/backlight/" + root.backlightDevice + "/brightness"
            : ""

        watchChanges: true

        onLoaded: {
            const current = parseInt(text().trim())

            if (!isNaN(current) && root.maxBrightness > 0) {
                root.displayBrightness =
                    Math.round(current / root.maxBrightness * 100)
            }
        }

        onFileChanged: reload()
    }

    FileView {
        id: maxBrightnessFile

        path: root.backlightDevice.length > 0
            ? "/sys/class/backlight/" + root.backlightDevice + "/max_brightness"
            : ""

        onLoaded: {
            const value = parseInt(text().trim())

            if (!isNaN(value) && value > 0) {
                root.maxBrightness = value
                brightnessFile.reload()
            }
        }
    }

    Process {
        id: nightModeProc
        command: ["pgrep", "-x", "wlsunset"]
        running: true
        onExited: function(exitCode, exitStatus) {
            nightMode = exitCode === 0
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: if (!nightModeProc.running) {
            nightModeProc.running = true
        }
    }

    readonly property string time: {
        // Qt.formatDateTime(clock.date, "h:mm:ss AP\nddd, MMM d")
        if (preciseTime) { return Qt.formatDateTime(clock.date, "h:mm:ss AP\nM/d/yyyy") }
        Qt.formatDateTime(clock.date, "h:mm AP\nM/d/yyyy")
    }

    SystemClock {
        id: clock
        precision: preciseTime ? SystemClock.Seconds : SystemClock.Minutes
    }
}