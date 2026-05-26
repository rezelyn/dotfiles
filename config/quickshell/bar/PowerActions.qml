import "."
import "../theme"
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    implicitWidth: actionsRow.implicitWidth
    implicitHeight: actionsRow.implicitHeight

    RowLayout {
        id: actionsRow

        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        PowerActionsBtn {
            icon: "󰐥"
            label: "Power off"
            accentColor: Theme.red
            command: ["systemctl", "poweroff"]
        }

        PowerActionsBtn {
            icon: "󰜉"
            label: "Reboot"
            accentColor: Theme.peach
            command: ["systemctl", "reboot"]
        }

        PowerActionsBtn {
            icon: "󰒲"
            label: "Idle"
            accentColor: Theme.yellow
            command: ["systemctl", "suspend"]
        }

        PowerActionsBtn {
            icon: "󰌾"
            label: "Lock"
            accentColor: Theme.lavender
            command: ["hyprlock"]
        }

    }

}
