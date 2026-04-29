import Quickshell
import Quickshell.Hyprland
import QtQuick

import "./bar"

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData

            screen: modelData
            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 40
            margins {
                top: 20
                left: 20
                right: 20
            }

            color: "transparent"
            exclusiveZone: 60

            Bar {
                anchors.fill: parent
            }
        }
    }
}
