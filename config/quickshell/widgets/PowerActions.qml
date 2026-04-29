import QtQuick
import QtQuick.Layouts

import "../theme"
import "."

Item {
    id: root
    implicitWidth: actionsRow.implicitWidth
    implicitHeight: actionsRow.implicitHeight

    RowLayout {
        id: actionsRow
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        PowerActionBtn {
            icon: "󰐥"
            label: "Power off"
            accentColor: Theme.red
            command: ["systemctl", "poweroff"]
        }
        PowerActionBtn {
            icon: "󰜉"
            label: "Reboot"
            accentColor: Theme.peach
            command: ["systemctl", "reboot"]
        }
        PowerActionBtn {
            icon: "󰒲"
            label: "Idle"
            accentColor: Theme.yellow
            command: ["systemctl", "suspend"]
        }
        PowerActionBtn {
            icon: "󰌾"
            label: "Lock"
            accentColor: Theme.lavender
            command: ["hyprlock"]
        }
    }
}
