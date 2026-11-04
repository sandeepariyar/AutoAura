/**
 * AutoAura
 * Status Bar Component
 *
 * Author: Sandeep Pariyar
 * Created: 2026
 */

import QtQuick

Item {
    id: root
    height: 20

    Text {
        id: timeText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        text: "9:41"
        font.pixelSize: 15
        font.weight: Font.DemiBold
        color: "#1A1A1A"
    }

    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        // Signal icon
        Item {
            width: 18
            height: 14
            Row {
                anchors.bottom: parent.bottom
                spacing: 2
                Repeater {
                    model: 4
                    Rectangle {
                        width: 3
                        height: 4 + index * 3
                        radius: 1
                        color: "#1A1A1A"
                        anchors.bottom: parent.bottom
                    }
                }
            }
        }

        // WiFi icon placeholder
        Rectangle {
            width: 16
            height: 12
            color: "transparent"
            Text {
                anchors.centerIn: parent
                text: "◐"
                font.pixelSize: 14
                color: "#1A1A1A"
            }
        }

        // Battery icon
        Rectangle {
            width: 25
            height: 12
            radius: 3
            color: "transparent"
            border.color: "#1A1A1A"
            border.width: 1.5

            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: 2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.7
                height: parent.height - 4
                radius: 1.5
                color: "#1A1A1A"
            }

            Rectangle {
                anchors.left: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 2
                height: 5
                radius: 1
                color: "#1A1A1A"
            }
        }
    }
}
