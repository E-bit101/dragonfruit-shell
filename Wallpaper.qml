import Quickshell 
import Quickshell.Io
import QtQuick
import "widgets"

Scope {
    id: root
    property string time

    Variants {
        model: Quickshell.screens;
        
        delegate: Component {

            PanelWindow {
                required property var modelData
                screen: modelData
                
                aboveWindows: false
                exclusiveZone: -320

                anchors {
                    bottom: true
                    left: true
                    right: true
                    top: true
                }

                Image {
                    width: parent.width
                    height: parent.height
                    source: "~/Downloads/Img19_(Windows_11).jpg"
                    fillMode: Image.PreserveAspectCrop
                }
            }

        }
    }
}