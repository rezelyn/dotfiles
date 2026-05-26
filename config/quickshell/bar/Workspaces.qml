import "../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Item {
    id: root

    implicitWidth: pill.implicitWidth
    implicitHeight: pill.implicitHeight

    readonly property int activeId: Hyprland.focusedMonitor?.activeWorkspace?.id ?? 1
    readonly property int dotCount: 5
    readonly property int windowStart: Math.max(1, activeId - 4)

    readonly property var wsRange: {
        const ids = [];
        for (let i = 0; i < dotCount; i++)
            ids.push(windowStart + i);
        return ids;
    }
    
    Rectangle {
        id: pill

        implicitWidth: dotsRow.implicitWidth + 20
        implicitHeight: 26
        anchors.centerIn: parent
        radius: height / 2
        color: Qt.rgba(Theme.crust.r, Theme.crust.g, Theme.crust.b, 0.25)

        RowLayout {
            id: dotsRow

            anchors.centerIn: parent
            spacing: 8

            Repeater {
                model: root.wsRange

                delegate: Item {
                    id: wsItem

                    required property int modelData
                    property bool isActive: root.activeId === modelData
                    property bool isEmpty: Hyprland.workspaces.values.find((w) => {
                        return w.id === modelData;
                    }) === undefined
                    property bool hovered: false

                    implicitWidth: 11
                    implicitHeight: 11
                    Layout.alignment: Qt.AlignVCenter

                    Rectangle {
                        id: dot

                        readonly property real baseSize: wsItem.isActive ? 11 : 7
                        readonly property real hoveredSize: 11

                        width: wsItem.hovered ? hoveredSize : baseSize
                        height: width
                        anchors.centerIn: parent
                        radius: width / 2
                        color: wsItem.isActive ? Theme.lavender : wsItem.isEmpty ? Theme.subtext0 : Theme.mauve

                        Behavior on width {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.OutCubic
                            }

                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }

                        }

                    }

                    MouseArea {
                        anchors.centerIn: parent
                        width: 22
                        height: 22
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

}
