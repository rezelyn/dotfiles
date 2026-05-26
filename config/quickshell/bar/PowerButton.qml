import "../theme"
import QtQuick
import QtQuick.Effects

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
        layer.enabled: true

        property real glowOpacity: root.hovered ? 1.0 : 0.0

        Behavior on glowOpacity {
            NumberAnimation { duration: 150 }
        }

        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.blue
            shadowBlur: 1
            shadowScale: 1
            shadowOpacity: pwrLabel.glowOpacity
        }

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
