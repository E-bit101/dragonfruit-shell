import Quickshell
import QtQuick
import Quickshell.Services.Pipewire
import "../util"

MaterialIcon {
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    icon: {
        if (!Pipewire.defaultAudioSink) { return "volume_off" }
        var icons = ["volume_off", "volume_mute", "volume_down", "volume_up", "brand_awareness"]
        return icons[Math.min(Math.ceil(Pipewire.defaultAudioSink.audio.volume * 3), 4)]
    }
}