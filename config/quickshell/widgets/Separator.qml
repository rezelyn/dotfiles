import "../theme"
import QtQuick

Item {
    implicitWidth: sepLabel.implicitWidth
    implicitHeight: 40

    Text {
        id: sepLabel

        anchors.centerIn: parent
        text: "|"
        font.family: Theme.font
        font.pixelSize: 16
        rightPadding: 6
        color: Theme.surface1
    }

}
