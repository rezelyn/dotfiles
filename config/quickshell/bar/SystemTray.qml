import "../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray

Item {
    id: root

    property var activeMenu: null

    readonly property var iconMap: ({
        "obs": "",
        "spotify": "",
        "steam": "",
        "discord": "",
        "chrome_status_icon": "" // Equicord
    })
    
    readonly property var scratchpadMap: ({
        "obs": {
            "name": "obs",
            "command": "obs",
            "color": Theme.red
        },
        "spotify": {
            "name": "spotify",
            "command": "spotify",
            "color": "#2ad566"
        },
        "steam": {
            "name": "steam",
            "command": "steam",
            "color": "#65b9ec"
        },
        "discord": {
            "name": "discord",
            "command": "discord",
            "color": "#606ceb"
        },
        "vesktop": {
            "name": "discord",
            "command": "vesktop",
            "color": "#606ceb"
        },
        "equicord": {
            "name": "discord",
            "command": "equicord",
            "color": "#606ceb"
        },
        "chrome_status_icon": {
            "name": "discord",
            "command": "equicord",
            "color": "#606ceb"
        }
    })
    readonly property var blacklist: ["nm-applet", "network", "pipewire", "pulseaudio", "pavucontrol", "volume", "blueman", "bluetooth"]

    function resolveIcon(itemId) {
        const id = itemId.toLowerCase();
        for (const key of Object.keys(iconMap)) if (id.includes(key)) {
            return iconMap[key];
        }
        return null;
    }

    function scratchpadFor(itemId) {
        const id = itemId.toLowerCase();
        for (const key of Object.keys(scratchpadMap)) if (id.includes(key)) {
            return scratchpadMap[key];
        }
        return null;
    }

    function isBlacklisted(itemId) {
        const id = itemId.toLowerCase();
        return blacklist.some((b) => {
            return id.includes(b);
        });
    }

    implicitWidth: trayRow.implicitWidth
    implicitHeight: 40

    RowLayout {
        id: trayRow

        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: trayIcon

                required property SystemTrayItem modelData
                readonly property string itemId: modelData.id
                readonly property bool itemPassive: modelData.status === SystemTrayStatus.Passive
                property bool hovered: false
                property bool isActive: false
                readonly property var scratchpad: root.scratchpadFor(itemId)
                readonly property color activeColor: scratchpad ? scratchpad.color : Theme.lavender
                readonly property string glyphIcon: root.resolveIcon(itemId) ?? ""
                readonly property bool useGlyph: glyphIcon !== ""

                visible: !itemPassive && !root.isBlacklisted(itemId)
                implicitWidth: visible ? 28 : 0
                implicitHeight: 40
                Component.onCompleted: {
                    // console.log("[SystemTray] item id:", trayIcon.modelData.id)
                    if (trayIcon.scratchpad)
                        visibilityProc.running = true;

                }

                Process {
                    id: visibilityProc

                    running: trayIcon.scratchpad !== null
                    command: trayIcon.scratchpad ? ["bash", "-c", "hyprctl monitors -j | python3 -c \"import sys,json; ms=json.load(sys.stdin); print('true' if any(m['specialWorkspace']['name']=='special:" + trayIcon.scratchpad.name + "' for m in ms) else 'false')\""] : []
                    onRunningChanged: {
                        if (!running && trayIcon.scratchpad) {
                            running = true;
                        }
                    }

                    stdout: SplitParser {
                        onRead: (data) => {
                            return trayIcon.isActive = (data.trim() === "true");
                        }
                    }

                }

                Process {
                    id: toggleProc

                    command: trayIcon.scratchpad ? ["hyprctl", "dispatch", "togglespecialworkspace", trayIcon.scratchpad.name] : []
                }

                Process {
                    id: launchProc

                    command: trayIcon.scratchpad ? ["hyprctl", "dispatch", "exec", "[workspace special:" + trayIcon.scratchpad.name + " silent] " + trayIcon.scratchpad.command] : []
                }

                Text {
                    anchors.centerIn: parent
                    visible: trayIcon.useGlyph
                    text: trayIcon.glyphIcon
                    font.family: Theme.font
                    font.pixelSize: 20
                    color: (trayIcon.isActive || trayIcon.hovered) ? trayIcon.activeColor : Theme.mauve

                    Behavior on color {
                        ColorAnimation {
                            duration: 250
                        }

                    }

                }

                Image {
                    anchors.centerIn: parent
                    visible: !trayIcon.useGlyph
                    width: 20
                    height: 20
                    source: trayIcon.modelData.icon
                    smooth: true
                    mipmap: true
                    opacity: trayIcon.hovered ? 1 : 0.75

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 150
                        }

                    }

                }

                Rectangle {
                    visible: trayIcon.hovered && trayIcon.modelData.tooltip !== ""
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.top
                    anchors.bottomMargin: 4
                    color: Theme.base
                    border.color: Theme.surface0
                    border.width: 1
                    radius: 6
                    width: tipText.implicitWidth + 12
                    height: tipText.implicitHeight + 8
                    z: 10
                }

                TrayMenu {
                    id: trayMenu
                    menuHandle: trayIcon.modelData.hasMenu ? trayIcon.modelData.menu : null
                    anchorItem: trayIcon
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor
                    onEntered: trayIcon.hovered = true
                    onExited: trayIcon.hovered = false
                    
                    onClicked: (mouse) => {
                        if (mouse.button === Qt.LeftButton) {
                            if (trayIcon.scratchpad) {
                                if (root.activeMenu && root.activeMenu !== trayMenu)
                                    root.activeMenu.close();
                                root.activeMenu = null;
                                toggleProc.exec(toggleProc.command);
                            } else if (trayIcon.modelData.menuOnly) {
                                if (trayIcon.modelData.hasMenu) {
                                    if (root.activeMenu && root.activeMenu !== trayMenu)
                                        root.activeMenu.close();
                                    root.activeMenu = trayMenu;
                                    trayMenu.open();
                                }
                            } else {
                                if (root.activeMenu && root.activeMenu !== trayMenu)
                                    root.activeMenu.close();
                                root.activeMenu = null;
                                trayIcon.modelData.activate();
                            }
                        } else if (mouse.button === Qt.RightButton) {
                            if (trayIcon.modelData.hasMenu) {
                                if (root.activeMenu && root.activeMenu !== trayMenu) {
                                    root.activeMenu.close();
                                    root.activeMenu = trayMenu;
                                    trayMenu.open();
                                } else {
                                    if (trayMenu._open) {
                                        root.activeMenu = null;
                                    } else {
                                        root.activeMenu = trayMenu;
                                    }
                                    trayMenu.toggle();
                                }
                            } else {
                                if (root.activeMenu) {
                                    root.activeMenu.close();
                                    root.activeMenu = null;
                                }
                                trayIcon.modelData.secondaryActivate();
                            }
                        }
                    }
                    onWheel: (wheel) => {
                        trayIcon.modelData.scroll(wheel.angleDelta.y > 0 ? 1 : -1, Qt.Vertical);
                    }
                }

            }

        }

    }

}
