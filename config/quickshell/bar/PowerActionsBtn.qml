import "../theme"
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root

    property string icon: ""
    property string label: ""
    property color accentColor: Theme.text
    property bool hovered: false
    property color currentColor: root.hovered ? root.accentColor : Theme.subtext1

    property list<string> command: []
    
    implicitWidth: btnInner.implicitWidth + 20
    implicitHeight: btnInner.implicitHeight + 4

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: root.hovered ? Qt.rgba(Theme.crust.r, Theme.crust.g, Theme.crust.b, 0.5) : Qt.rgba(Theme.crust.r, Theme.crust.g, Theme.crust.b, 0.25)

        Behavior on color {
            ColorAnimation {
                duration: 150
            }

        }

    }

    RowLayout {
        id: btnInner

        anchors.centerIn: parent
        spacing: 6

        Text {
            text: root.icon
            font.family: Theme.font
            font.pixelSize: 16
            color: root.currentColor
            layer.enabled: root.hovered

            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: root.currentColor
                shadowBlur: 1
                shadowScale: 1
                shadowOpacity: 0.5
            
            }
        }

        Text {
            text: root.label
            font.family: Theme.font
            font.pixelSize: 13
            font.bold: true
            color: root.currentColor
            layer.enabled: root.hovered

            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: root.currentColor
                shadowBlur: 1
                shadowScale: 1
                shadowOpacity: 0.5
            }
        }

    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
        cursorShape: Qt.PointingHandCursor
        onClicked: btnProc.running = true
    }

    Process {
        id: btnProc

        command: root.command
    }

    Behavior on currentColor {
        ColorAnimation {
            duration: 200
        }

    }

}
