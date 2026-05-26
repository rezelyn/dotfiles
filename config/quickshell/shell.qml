//@ pragma UseQApplication
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
                // switch boolean values from "top" to "bottom" to anchor the bar at the bottom (or top)
                // do not let both of the key values be "true" at the same time
                // otherwise you will have the bar covering the entire screen :D
                top: true
                bottom: false
                left: true
                right: true
            }

            margins {
                top: 10
                bottom: 10
                left: 10
                right: 10
            }

            Bar {
                anchors.fill: parent
            }

        }

    }

}
