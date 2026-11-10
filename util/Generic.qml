pragma Singleton
import QtQuick

QtObject {
    function mixColors(hex1, hex2, t) {
        const a = Qt.color(hex1)
        const b = Qt.color(hex2)

        return Qt.rgba(
            a.r * (1 - t) + b.r * t,
            a.g * (1 - t) + b.g * t,
            a.b * (1 - t) + b.b * t,
            a.a * (1 - t) + b.a * t
        ).toString()
    }
}