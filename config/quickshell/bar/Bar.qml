import "."
import "../theme"
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Rectangle {
    id: root

    property bool powerOpen: false

    radius: 12
    color: Qt.rgba(Theme.base.r, Theme.base.g, Theme.base.b, 0.5)

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
                    property real animatedWidth: root.powerOpen ? powerActions.implicitWidth : 0

                    implicitHeight: powerActions.implicitHeight
                    clip: true
                    width: animatedWidth
                    implicitWidth: animatedWidth

                    PowerActions {
                        id: powerActions

                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Behavior on animatedWidth {
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.OutCubic
                        }

                    }

                }

                Item {
                    property real animatedWidth: root.powerOpen ? 0 : workspaces.implicitWidth

                    implicitHeight: workspaces.implicitHeight
                    clip: true
                    width: animatedWidth
                    implicitWidth: animatedWidth

                    Workspaces {
                        id: workspaces

                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Behavior on animatedWidth {
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.OutCubic
                        }

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
                    onRead: (data) => {
                        return musicLabel.text = data.substring(0, 120);
                    }
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
                layer.enabled: true

                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: Theme.text
                    shadowBlur: 1
                    shadowScale: 1
                    shadowOpacity: 0.5
                }

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

                SystemTray {
                }

                Separator {
                }

                VolumeButton {
                }

                NetworkButton {
                }

                Separator {
                }

                Clock {
                }

            }

        }

    }

}
