import "../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray

Item {
    id: root

    readonly property var iconMap: ({
        "obs": "",
        "spotify": "",
        "steam": "",
        "discord": "",
        "nm-applet": "󰖩",
        "network": "󰖩",
        "blueman": "󰂯",
        "bluetooth": "󰂯",
        "pipewire": "󰕾",
        "pulseaudio": "󰕾",
        "pavucontrol": "󰕾",
        "copyq": "󰅇",
        "clipboard": "󰅇",
        "kdeconnect": "󰄡",
        "nextcloud": "󰅧",
        "dropbox": "󰇣",
        "megasync": "󰁇",
        "syncthing": "󱔲",
        "flameshot": "󰄄",
        "screenshot": "󰄄",
        "redshift": "󰛨",
        "gammastep": "󰛨",
        "dunst": "󰂞",
        "mako": "󰂞",
        "udiskie": "󱊟",
        "keepass": "󰌾",
        "bitwarden": "󰌾",
        "caffeine": "󰅶",
        "telegram": "󰔁",
        "signal": "󱅣",
        "whatsapp": "󰖣",
        "thunderbird": "󰊫",
        "mail": "󰊫",
        "element": "󰭩",
        "slack": "󰒱",
        "zoom": "󰏿",
        "teams": "󰊻",
        "protonvpn": "󰒄",
        "openvpn": "󰒄",
        "vpn": "󰒄",
        "qbittorrent": "󰆉",
        "transmission": "󰆉"
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
        }
    })

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
                property bool hovered: false
                property bool isActive: false
                readonly property var scratchpad: root.scratchpadFor(modelData.id)
                readonly property color activeColor: scratchpad ? scratchpad.color : Theme.lavender
                readonly property string glyphIcon: root.resolveIcon(modelData.id) ?? ""
                readonly property bool useGlyph: glyphIcon !== ""

                visible: modelData.status !== SystemTrayStatus.Passive
                implicitWidth: visible ? 28 : 0
                implicitHeight: 40
                Component.onCompleted: {
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
                    id: iconLabel

                    anchors.centerIn: parent
                    text: root.resolveIcon(trayIcon.modelData.id)
                    font.family: Theme.font
                    font.pixelSize: 20
                    color: (trayIcon.isActive || trayIcon.hovered) ? trayIcon.activeColor : Theme.mauve

                    Behavior on color {
                        ColorAnimation {
                            duration: 250
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

                    Text {
                        id: tipText

                        anchors.centerIn: parent
                        text: trayIcon.modelData.tooltip
                        font.family: Theme.font
                        font.pixelSize: 13
                        color: Theme.text
                    }

                }

                QsMenuAnchor {
                    id: menuAnchor

                    function updateRect() {
                        anchor.rect = trayIcon.QsWindow.window.contentItem.mapFromItem(trayIcon, 0, 0, trayIcon.width, trayIcon.height);
                    }

                    anchor.window: trayIcon.QsWindow.window
                    anchor.edges: Edges.Bottom
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
                                if (!trayIcon.modelData)
                                    launchProc.exec(launchProc.command);

                                toggleProc.exec(toggleProc.command);
                            } else if (trayIcon.modelData.menuOnly) {
                                if (trayIcon.modelData.hasMenu) {
                                    menuAnchor.updateRect();
                                    menuAnchor.open(trayIcon.modelData.menu);
                                }
                            } else {
                                trayIcon.modelData.activate();
                            }
                        } else {
                            if (trayIcon.modelData.hasMenu) {
                                menuAnchor.updateRect();
                                menuAnchor.open(trayIcon.modelData.menu);
                            } else {
                                trayIcon.modelData.display(trayIcon.QsWindow.window, mouse.x, mouse.y);
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
