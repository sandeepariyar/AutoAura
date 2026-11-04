/**
 * AutoAura
 * Stats Panel Component
 *
 * Author: Sandeep Pariyar
 * Created: 2026
 */

import QtQuick

Row {
    id: root
    spacing: 24

    property int rangeValue: 150
    property string rangeUnit: "mi"
    property int tempValue: 23
    property string tempUnit: "°F"

    // Range stat
    Column {
        spacing: 2

        Row {
            spacing: 2
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: root.rangeValue
                font.pixelSize: 28
                font.weight: Font.Bold
                color: "#1A1A1A"
            }

            Text {
                text: root.rangeUnit
                font.pixelSize: 14
                font.weight: Font.Normal
                color: "#1A1A1A"
                anchors.baseline: parent.children[0].baseline
            }
        }

        Text {
            text: "Range"
            font.pixelSize: 12
            color: "#9E9E9E"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // Temperature stat
    Column {
        spacing: 2

        Row {
            spacing: 2
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: root.tempValue
                font.pixelSize: 28
                font.weight: Font.Bold
                color: "#1A1A1A"
            }

            Text {
                text: root.tempUnit
                font.pixelSize: 14
                font.weight: Font.Normal
                color: "#1A1A1A"
                anchors.baseline: parent.children[0].baseline
            }
        }

        Text {
            text: "Temp"
            font.pixelSize: 12
            color: "#9E9E9E"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
