import Quickshell
import QtQuick

Image {
    id: appIcon
    required property string iconName

    source: {
        const entry = DesktopEntries.heuristicLookup(iconName)
        return entry ? Quickshell.iconPath(entry.icon, "") : ""
    }

    Component.onCompleted: {
        Qt.callLater(() => {
            appIcon.source = Qt.binding(() => {
                const entry = DesktopEntries.heuristicLookup(iconName)
                return entry ? Quickshell.iconPath(entry.icon, "") : ""
            })
        })
    }
}