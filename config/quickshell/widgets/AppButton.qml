import QtQuick
import Quickshell.Io
import Quickshell.Services.SystemTray

import "../theme"

Item {
    id: root

    property string appName: ""
    property string icon: ""
    property int iconSize: 20
    property int iconPadding: 4
    property color activeColor: Theme.mauve
    property string launchCommand: ""
    property string scratchpadName: ""

    property bool isActive: false
    property bool hovered: false

    readonly property var trayItem: {
        for (let i = 0; i < SystemTray.items.length; i++) {
            if (SystemTray.items[i].id.toLowerCase().includes(appName.toLowerCase()))
                return SystemTray.items[i];
        }
        return null;
    }

    implicitWidth: iconText.implicitWidth + 8
    implicitHeight: 40

    Process {
        id: toggleProc
        command: ["hyprctl", "dispatch", "togglespecialworkspace", root.scratchpadName]
    }

    Process {
        id: launchProc
        command: ["hyprctl", "dispatch", "exec", "[workspace special:" + root.scratchpadName + " silent] " + root.launchCommand]
    }

    Process {
        id: visibilityProc
        command: ["bash", "-c", "hyprctl activeworkspace -j | grep -q '\"name\":\"special:" + root.scratchpadName + "\"' && echo true || echo false"]
        stdout: SplitParser {
            onRead: data => root.isActive = (data.trim() === "true")
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: visibilityProc.running = true
    }

    Text {
        id: iconText
        anchors.centerIn: parent
        text: root.icon
        font.family: Theme.font
        font.pixelSize: root.iconSize
        rightPadding: root.iconPadding
        color: (root.isActive || root.hovered) ? root.activeColor : Theme.mauve
        Behavior on color {
            ColorAnimation {
                duration: 250
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onEntered: root.hovered = true
        onExited: root.hovered = false
        cursorShape: Qt.PointingHandCursor

        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                if (root.trayItem)
                    root.trayItem.showContextMenu(-1, -1);
            } else {
                if (root.trayItem)
                    toggleProc.running = true;
                else
                    launchProc.running = true;
            }
        }
    }
}
