import "../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray

Item {
    id: root

    required property var menuHandle
    required property Item anchorItem
    property bool _open: false

    function open() {
        if (!menuHandle)
            return ;

        _reposition();
        root._open = true;
        popup.visible = true;
    }

    function close() {
        focusGrab.active = false;
        root._open = false;
    }

    function toggle() {
        root._open ? close() : open();
    }

    function _reposition() {
        const win = anchorItem.QsWindow.window;
        if (!win)
            return ;

        const ci = win.contentItem;
        const mapped = ci.mapFromItem(anchorItem, 0, anchorItem.height);
        const cx = mapped.x + anchorItem.width / 2 - popup.width / 2;
        const clampedX = Math.max(4, Math.min(cx, ci.width - popup.width - 4));
        popup.anchor.rect.x = clampedX;
        popup.anchor.rect.y = mapped.y;
        popup.anchor.rect.width = popup.width;
        popup.anchor.rect.height = 0;
    }

    QsMenuOpener {
        id: opener

        menu: root.menuHandle
    }

    PopupWindow {
        id: popup

        visible: false
        color: "transparent"
        anchor.window: anchorItem.QsWindow.window
        implicitWidth: card.implicitWidth
        implicitHeight: card.implicitHeight
        onVisibleChanged: {
            if (visible)
                focusGrab.active = true;

        }

        HyprlandFocusGrab {
            id: focusGrab

            windows: [popup]
            active: false
            onCleared: {
                focusGrab.active = false;
                root.close();
            }
        }

        MouseArea {
            anchors.fill: parent
            z: 0
            onClicked: {
                root.close();
            }
        }

        Rectangle {
            id: card

            implicitWidth: Math.max(menuColumn.implicitWidth + 10, 200)
            implicitHeight: menuColumn.implicitHeight + 14
            anchors.fill: parent
            anchors.topMargin: 4
            z: 1
            opacity: root._open ? 0.90 : 0
            color: Theme.base
            border.color: Theme.surface0
            border.width: 1
            radius: 12

            Column {
                id: menuColumn

                // spacing: 0

                anchors {
                    top: parent.top
                    topMargin: 5
                    left: parent.left
                    leftMargin: 5
                    right: parent.right
                    rightMargin: 5
                    bottom: parent.bottom
                    bottomMargin: 5
                }

                Repeater {
                    model: opener.children

                    delegate: Loader {
                        required property QsMenuEntry modelData

                        width: menuColumn.width
                        sourceComponent: modelData.isSeparator ? separatorComp : itemComp
                        onLoaded: {
                            if (item && "menuItem" in item)
                                item.menuItem = modelData;

                        }

                        // onStatusChanged: {
                        //     if (status === Loader.Error)
                        //         console.log("ERROR:", modelData.text);
                        // }

                    }

                }

            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutCubic
                    onRunningChanged: {
                        if (!running && !root._open)
                            popup.visible = false;

                    }
                }

            }

        }

    }

    Component {
        id: separatorComp

        Item {
            property var menuItem: null

            height: 12

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 6
                anchors.right: parent.right
                anchors.rightMargin: 6
                height: 1
                color: Theme.surface1
            }

        }

    }

    Component {
        id: itemComp

        Rectangle {
            id: itemBg

            property var menuItem: null
            readonly property bool itemEnabled: menuItem ? menuItem.enabled : false
            readonly property bool hasSubmenu: menuItem ? menuItem.children.count > 0 : false
            property bool hovered: false

            height: 30
            radius: 6
            color: (hovered && itemEnabled) ? Theme.mauve : "transparent"

            RowLayout {
                spacing: 4

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 8
                    right: parent.right
                    rightMargin: 8
                }

                Text {
                    Layout.preferredWidth: 14
                    horizontalAlignment: Text.AlignHCenter
                    text: {
                        if (!itemBg.menuItem)
                            return "";

                        const cs = itemBg.menuItem.checkState;
                        if (cs === Qt.Checked)
                            return "✓";

                        if (cs === Qt.PartiallyChecked)
                            return "–";

                        return "";
                    }
                    font.family: Theme.fonts.bar
                    font.pixelSize: 12
                    color: Theme.lavender
                }

                Image {
                    visible: itemBg.menuItem && itemBg.menuItem.icon !== ""
                    source: itemBg.menuItem ? itemBg.menuItem.icon : ""
                    width: 15
                    height: 15
                    smooth: true
                    mipmap: true
                    opacity: itemBg.itemEnabled ? 1 : 0.35
                    Layout.alignment: Qt.AlignVCenter
                }

                Text {
                    Layout.fillWidth: true
                    text: itemBg.menuItem ? itemBg.menuItem.text : ""
                    font.family: Theme.fonts.menu
                    font.pixelSize: 13
                    color: itemBg.itemEnabled ? Theme.text : Theme.surface2
                    elide: Text.ElideRight

                    Behavior on color {
                        ColorAnimation {
                            duration: 0
                            easing.type: Easing.OutCubic
                        }

                    }

                }

                Text {
                    visible: itemBg.hasSubmenu
                    text: ""
                    font.family: Theme.fonts.bar
                    font.pixelSize: 11
                    color: Theme.subtext0
                }

            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: itemBg.itemEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onEntered: itemBg.hovered = true
                onExited: itemBg.hovered = false
                onClicked: {
                    if (!itemBg.itemEnabled || !itemBg.menuItem)
                        return ;

                    itemBg.menuItem.triggered();
                    root.close();
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: 250
                    easing.type: Easing.OutCubic
                }

            }

        }

    }

}
