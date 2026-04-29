import QtQuick

import "../theme"

Item {
    id: root
    implicitWidth: netIcon.implicitWidth
    implicitHeight: 40

    property bool hovered: false

    Text {
        id: netIcon
        anchors.centerIn: parent
        text: "󰖩"
        font.family: Theme.font
        font.pixelSize: 20
        rightPadding: 6
        color: root.hovered ? Theme.lavender : Theme.mauve
        Behavior on color {
            ColorAnimation {
                duration: 150
            }
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
