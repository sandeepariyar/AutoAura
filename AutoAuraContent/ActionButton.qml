/**
 * AutoAura
 * Action Button Component
 *
 * Author: Sandeep Pariyar
 * Created: 2026
 */

import QtQuick

Item {
    id: root
    width: 48
    height: 48

    property string iconText: ""
    property color iconColor: "#9E9E9E"
    property bool hasNotification: false
    property color notificationColor: "#FF6B6B"

    signal clicked()

    // Shadow
    Rectangle {
        anchors.fill: buttonBg
        anchors.topMargin: 2
        anchors.leftMargin: 2
        radius: width / 2
        color: "#20000000"
    }

    Rectangle {
        id: buttonBg
        anchors.fill: parent
        radius: width / 2
        color: "#F5F7FA"

        // Icon placeholder
        Text {
            anchors.centerIn: parent
            text: root.iconText
            font.pixelSize: 20
            color: root.iconColor
        }

        // Notification dot
        Rectangle {
            visible: root.hasNotification
            width: 10
            height: 10
            radius: 5
            color: root.notificationColor
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 2
            anchors.rightMargin: 2
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
        onPressed: buttonBg.scale = 0.92
        onReleased: buttonBg.scale = 1.0
    }

    Behavior on scale {
        NumberAnimation { duration: 100 }
    }
}
