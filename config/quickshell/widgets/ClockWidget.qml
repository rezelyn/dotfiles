import QtQuick

import "../theme"

Item {
    id: root
    implicitWidth: clockLabel.implicitWidth
    implicitHeight: 40

    property string timeText: Qt.formatTime(new Date(), "hh:mm")
    property string dateText: Qt.formatDate(new Date(), "dd/MM/yyyy")
    property bool hovered: false

    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.timeText = Qt.formatTime(new Date(), "hh:mm");
            root.dateText = Qt.formatDate(new Date(), "dd/MM/yyyy");
        }
    }

    Text {
        id: clockLabel
        anchors.centerIn: parent
        text: root.timeText
        font.family: Theme.font
        font.pixelSize: 16
        font.bold: true
        rightPadding: 4
        color: Theme.lavender
    }

    Rectangle {
        visible: root.hovered
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: 4
        color: Theme.base
        border.color: Theme.surface0
        border.width: 1
        radius: 6
        width: tipDate.implicitWidth + 12
        height: tipDate.implicitHeight + 8

        Text {
            id: tipDate
            anchors.centerIn: parent
            text: root.dateText
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
    }
}
