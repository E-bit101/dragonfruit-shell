import QtQuick
import QtQuick.Controls.Basic

Switch {
    id: control

    property bool dark: Qt.styleHints.colorScheme === Qt.Dark

    readonly property color accent:        dark ? "#479EF5" : "#0F6CBD"
    readonly property color accentHover:   dark ? "#62ABF5" : "#115EA3"
    readonly property color accentPressed: dark ? "#2886DE" : "#0C3B5E"
    readonly property color offBorder:     dark ? "#D6D6D6" : "#616161"
    readonly property color offBorderHover:dark ? "#FFFFFF" : "#424242"
    readonly property color offKnob:       dark ? "#D6D6D6" : "#616161"
    readonly property color onKnob:        dark ? "#1A1A1A" : "#FFFFFF"
    readonly property color focusRing:     dark ? "#FFFFFF" : "#000000"
    readonly property color disabledColor: dark ? "#5C5C5C" : "#BDBDBD"

    implicitWidth: 40
    implicitHeight: 20
    padding: 0
    spacing: 0
    hoverEnabled: true

    contentItem: Item {}

    background: Item {
        Rectangle {
            anchors.fill: parent
            anchors.margins: -3
            radius: height / 2
            color: "transparent"
            border.width: 2
            border.color: control.focusRing
            visible: control.visualFocus
        }
    }

    indicator: Rectangle {
        id: track
        width: 40
        height: 20
        x: control.leftPadding
        y: (control.height - height) / 2
        radius: height / 2

        color: {
            if (!control.enabled)
                return control.checked ? control.disabledColor : "transparent"
            if (!control.checked)
                return "transparent"
            if (control.down)
                return control.accentPressed
            if (control.hovered)
                return control.accentHover
            return control.accent
        }

        border.width: control.checked ? 0 : 1
        border.color: !control.enabled ? control.disabledColor
                    : control.hovered  ? control.offBorderHover
                                       : control.offBorder

        Behavior on color { ColorAnimation { duration: 90 } }

        Rectangle {
            id: knob
            width:  !control.enabled ? 12 : control.down ? 17 : control.hovered ? 14 : 12
            height: !control.enabled ? 12 : control.hovered || control.down ? 14 : 12
            radius: height / 2
            y: (track.height - height) / 2
            x: control.checked ? track.width - width - 3 : 3

            color: !control.enabled ? (control.checked ? "#FFFFFF" : control.disabledColor)
                 : control.checked  ? control.onKnob
                                    : control.offKnob

            Behavior on x      { NumberAnimation { duration: 167; easing.type: Easing.OutCubic } }
            Behavior on width  { NumberAnimation { duration: 167; easing.type: Easing.OutCubic } }
            Behavior on height { NumberAnimation { duration: 167; easing.type: Easing.OutCubic } }
            Behavior on color  { ColorAnimation  { duration: 90 } }
        }
    }
}