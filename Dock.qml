import Quickshell 
import Quickshell.Io
import QtQuick
import "widgets"
import "menus"

Scope {
    id: root
    property string time

    Variants {
        model: Quickshell.screens;
        
        delegate: Component {

            PanelWindow {
                required property var modelData
                screen: modelData
                implicitHeight: 42
                anchors {
                    bottom: true
                    left: true
                    right: true
                }
                color: '#00000000'

                Rectangle {
                    width: parent.width
                    height: parent.height

                    color: '#aa262626'
                    
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: '#12ffffff'
                    }

                    ControlPanel { id: popup }
                    Calendar { id: calendar }

                    Clock { 
                        id: clock
                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                            rightMargin: 5
                        } 
                    }
                    LauncherButton { anchors.centerIn: parent }
                    ControlPanelButton {
                        id: settingsButton
                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: clock.left
                            rightMargin: 5
                        } 
                    }
                }
            }
        }
    }
}