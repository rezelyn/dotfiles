import "./bar"
import QtQuick
import Quickshell
import Quickshell.Hyprland

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData

            screen: modelData
            implicitHeight: 40
            color: "transparent"
            exclusiveZone: 40

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                top: 20
                left: 20
                right: 20
            }

            Bar {
                anchors.fill: parent
            }

        }

    }

}
