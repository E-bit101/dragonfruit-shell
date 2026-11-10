import QtQuick

Item {
    id: root

    property string icon: "home"
    property int iconSize: 24
    property color iconColor: "white"

    width: iconSize
    height: iconSize

    FontLoader {
        id: materialFont
        source: Qt.resolvedUrl("../fonts/MaterialSymbolsRounded.ttf")
    }

    Text {
        text: root.icon
        font.family: materialFont.name
        font.pixelSize: root.iconSize
        color: root.iconColor

        transform: Translate {
            y: -2
        }
    }
}