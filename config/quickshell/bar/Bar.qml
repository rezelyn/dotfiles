import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

import "../widgets"
import "../theme"

Rectangle {
    id: root

    radius: 12
    color: Qt.rgba(Theme.crust.r, Theme.crust.g, Theme.crust.b, 0.5)

    property bool powerOpen: false

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 0

        // Left
        Item {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: false
            implicitWidth: leftRow.implicitWidth
            implicitHeight: leftRow.implicitHeight

            RowLayout {
                id: leftRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 0

                PowerButton {
                    onClicked: root.powerOpen = !root.powerOpen
                }

                Item {
                    implicitHeight: powerActions.implicitHeight
                    clip: true
                    // Behavior on a plain real — RowLayout reads implicitWidth
                    // passively each frame with no layout invalidation on change
                    property real animatedWidth: root.powerOpen ? powerActions.implicitWidth : 0
                    width: animatedWidth
                    implicitWidth: animatedWidth
                    Behavior on animatedWidth {
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.OutCubic
                        }
                    }

                    PowerActions {
                        id: powerActions
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Item {
                    implicitHeight: workspaces.implicitHeight
                    clip: true
                    property real animatedWidth: root.powerOpen ? 0 : workspaces.implicitWidth
                    width: animatedWidth
                    implicitWidth: animatedWidth
                    Behavior on animatedWidth {
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.OutCubic
                        }
                    }

                    Workspaces {
                        id: workspaces
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        // Center
        Item {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            implicitWidth: musicLabel.implicitWidth + 24
            implicitHeight: 40

            Process {
                id: musicProc
                command: ["sh", Qt.resolvedUrl("../scripts/music.sh").toString().replace("file://", "")]
                running: true
                stdout: SplitParser {
                    onRead: data => musicLabel.text = data.substring(0, 120)
                }
            }

            Text {
                id: musicLabel
                anchors.centerIn: parent
                text: ""
                font.family: Theme.font
                font.pixelSize: 16
                font.bold: true
                color: Theme.lavender
                elide: Text.ElideRight
                maximumLineCount: 1
            }
        }

        Item {
            Layout.fillWidth: true
        }

        // Right
        Item {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: false
            implicitWidth: rightRow.implicitWidth
            implicitHeight: rightRow.implicitHeight

            RowLayout {
                id: rightRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 0

                SystemTrayWidget {}

                Separator {}
                VolumeIndicator {}
                NetworkIndicator {}
                Separator {}
                ClockWidget {}
            }
        }
    }
}
