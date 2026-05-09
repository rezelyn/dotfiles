import "../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Item {
    id: root

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    readonly property var wsRange: [1, 2, 3, 4, 5]
    readonly property int activeId: Hyprland.focusedMonitor?.activeWorkspace?.id ?? 1
    
    RowLayout {
        id: row

        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Repeater {
            model: root.wsRange

            delegate: Item {
                id: wsItem

                required property int modelData
                property bool isActive: root.activeId === modelData
                property bool hovered: false

                implicitWidth: Math.max(26, wsLabel.implicitWidth + 8)
                implicitHeight: 40
                Layout.alignment: Qt.AlignVCenter

                Text {
                    id: wsLabel

                    anchors.centerIn: parent
                    text: wsItem.modelData
                    font.family: Theme.font
                    font.pixelSize: 16
                    font.bold: true
                    color: (wsItem.isActive || wsItem.hovered) ? Theme.lavender : Theme.mauve

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }

                    }

                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: wsItem.hovered = true
                    onExited: wsItem.hovered = false
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("workspace " + wsItem.modelData)
                }

            }

        }

    }

}
