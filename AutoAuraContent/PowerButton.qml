/**
 * AutoAura
 * Power Button Component
 *
 * Author: Sandeep Pariyar
 * Created: 2026
 */

import QtQuick

Item {
    id: root
    width: 56
    height: 56

    property bool isOn: false

    signal toggled(bool state)

    // Shadow
    Rectangle {
        anchors.fill: buttonBg
        anchors.topMargin: 4
        radius: width / 2
        color: root.isOn ? "#40FF6B6B" : "#20000000"
    }

    Rectangle {
        id: buttonBg
        anchors.fill: parent
        radius: width / 2
        color: root.isOn ? "#FF6B6B" : "#FFF0F0"

        // Power icon
        Text {
            anchors.centerIn: parent
            text: "⏻"
            font.pixelSize: 24
            color: root.isOn ? "#FFFFFF" : "#FF6B6B"
        }

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.isOn = !root.isOn
            root.toggled(root.isOn)
        }
        onPressed: buttonBg.scale = 0.9
        onReleased: buttonBg.scale = 1.0
    }

    Behavior on scale {
        NumberAnimation { duration: 100 }
    }
}
