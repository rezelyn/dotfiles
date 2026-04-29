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
                    implicitWidth: root.powerOpen ? powerActions.implicitWidth : 0
                    Behavior on implicitWidth {
                        NumberAnimation {
                            duration: 800
                            easing.type: Easing.InOutCubic
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
                    implicitWidth: root.powerOpen ? 0 : workspaces.implicitWidth
                    Behavior on implicitWidth {
                        NumberAnimation {
                            duration: 800
                            easing.type: Easing.InOutCubic
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

                AppButton {
                    appName: "obs"
                    icon: ""
                    iconSize: 20
                    iconPadding: 2
                    activeColor: Theme.red
                    launchCommand: "obs"
                    scratchpadName: "obs"
                }
                AppButton {
                    appName: "spotify"
                    icon: ""
                    iconSize: 20
                    iconPadding: 2
                    activeColor: "#2ad566"
                    launchCommand: "spotify"
                    scratchpadName: "spotify"
                }
                AppButton {
                    appName: "steam"
                    icon: ""
                    iconSize: 20
                    iconPadding: 2
                    activeColor: "#65b9ec"
                    launchCommand: "steam"
                    scratchpadName: "steam"
                }
                AppButton {
                    appName: "discord"
                    icon: ""
                    iconSize: 19
                    iconPadding: 2
                    activeColor: "#606ceb"
                    launchCommand: "discord"
                    scratchpadName: "discord"
                }

                Separator {}
                VolumeIndicator {}
                NetworkIndicator {}
                Separator {}
                ClockWidget {}
            }
        }
    }
}
