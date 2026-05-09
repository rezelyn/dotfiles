import "../theme"
import QtQuick
import Quickshell.Io

Item {
    id: root

    property string volumeText: ""
    property bool hovered: false

    implicitWidth: volIcon.implicitWidth
    implicitHeight: 40

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: volProc.running = true
    }

    Process {
        id: volProc

        command: ["sh", Qt.resolvedUrl("../../scripts/volume.sh").toString().replace("file://", "")]

        stdout: SplitParser {
            onRead: (data) => {
                return root.volumeText = data.trim();
            }
        }

    }

    Text {
        id: volIcon

        anchors.centerIn: parent
        text: "󰕾"
        font.family: Theme.font
        font.pixelSize: 22
        rightPadding: 6
        color: root.hovered ? Theme.lavender : Theme.mauve

        Behavior on color {
            ColorAnimation {
                duration: 150
            }

        }

    }

    Rectangle {
        visible: root.hovered && root.volumeText !== ""
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: 4
        color: Theme.base
        border.color: Theme.surface0
        border.width: 1
        radius: 6
        width: volTip.implicitWidth + 12
        height: volTip.implicitHeight + 8

        Text {
            id: volTip

            anchors.centerIn: parent
            text: root.volumeText
            font.family: Theme.font
            font.pixelSize: 13
            color: Theme.text
        }

    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
        cursorShape: Qt.PointingHandCursor
    }

}
