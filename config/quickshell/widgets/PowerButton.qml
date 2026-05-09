import "../theme"
import QtQuick

Item {
    id: root

    property bool hovered: false

    signal clicked()

    implicitWidth: pwrLabel.implicitWidth + 16
    implicitHeight: 40

    Text {
        id: pwrLabel

        anchors.centerIn: parent
        text: "󰣇"
        font.family: Theme.font
        font.pixelSize: 28
        color: root.hovered ? Theme.blue : Theme.mauve

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
        onClicked: root.clicked()
        cursorShape: Qt.PointingHandCursor
    }

}
