/**
 * AutoAura
 * AC Controller - Minimal Vertical Layout
 * 200x380
 */

import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Rectangle {
    id: root
    width: 450

    height: 380
    color: "#00111118"
    radius: 24
    border.color: "#22ffffff"
    border.width: 1

    property bool acOn: true
    property bool autoMode: false
    property bool recircOn: false
    property bool frontDefrost: false
    property int  fanSpeed: 2
    property real minTemp: 16.0
    property real maxTemp: 30.0
    property real temperature: minTemp + tempSlider.value * (maxTemp - minTemp)

    property color accentColor: acOn
                                ? (temperature >= 26 ? "#ff6b6b"
                                                     : temperature <= 19 ? "#6bb5ff"
                                                                         : "#6bffb8")
                                : "#445566"

    Behavior on accentColor { ColorAnimation { duration: 400 } }

    Column {
        x: 14
        y: 258
        width: 145
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 6

        Text {
            text: "FAN"
            font.pixelSize: 7
            font.bold: true
            font.letterSpacing: 2
            color: "#445566"
        }

        Row {
            spacing: 6

            Repeater {
                model: 5

                Rectangle {
                    width: root.fanSpeed === index + 1 ? 28 : 22
                    height: root.fanSpeed === index + 1 ? 28 : 22
                    radius: width / 2
                    color: root.fanSpeed === index + 1
                           ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.15)
                           : "#1a1a25"
                    border.color: root.fanSpeed === index + 1
                                  ? root.accentColor : "#2a2a35"
                    border.width: root.fanSpeed === index + 1 ? 2 : 1
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on width  { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                    Behavior on height { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                    Behavior on color  { ColorAnimation { duration: 200 } }

                    Row {
                        anchors.centerIn: parent
                        spacing: 1
                        Repeater {
                            model: index + 1
                            Rectangle {
                                width: 2
                                height: 3 + modelIndex * 2
                                radius: 1
                                anchors.bottom: parent.bottom
                                color: root.fanSpeed === index + 1
                                       ? root.accentColor : "#3a3a45"
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: if (root.acOn) root.fanSpeed = index + 1
                    }
                }
            }
        }
    }

    Column {
        y: 328
        width: 172
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 6

        Text {
            text: "MODE"
            font.pixelSize: 7
            font.bold: true
            font.letterSpacing: 2
            color: "#445566"
        }

        Row {
            spacing: 6

            Repeater {
                model: [
                    { label: "↺", sub: "REC",  prop: "recircOn"     },
                    { label: "❄", sub: "DEF",  prop: "frontDefrost" },
                    { label: "AC", sub: "ON",  prop: "acOn"         }
                ]

                Rectangle {
                    required property var modelData
                    required property int index

                    property bool isActive: {
                        if (modelData.prop === "recircOn")     return root.recircOn
                        if (modelData.prop === "frontDefrost") return root.frontDefrost
                        if (modelData.prop === "acOn")         return root.acOn
                        return false
                    }

                    width: 52
                    height: 34
                    radius: 8
                    color: isActive
                           ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.12)
                           : "#1a1a25"
                    border.color: isActive ? root.accentColor : "#2a2a35"
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 200 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 1
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.label
                            font.pixelSize: 11
                            font.bold: true
                            color: isActive ? root.accentColor : "#445566"
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.sub
                            font.pixelSize: 6
                            font.bold: true
                            font.letterSpacing: 0.5
                            color: isActive ? root.accentColor : "#334455"
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (modelData.prop === "recircOn")     root.recircOn     = !root.recircOn
                            if (modelData.prop === "frontDefrost") root.frontDefrost = !root.frontDefrost
                            if (modelData.prop === "acOn")         root.acOn         = !root.acOn
                        }
                    }
                }
            }
        }
    }

    Item {
        id: tempSlider
        width: 44
        height: 356

        property real value: 1 - (knob.y / (height - knob.height))
        property real bend: knobArea.pressed ? 30 : 0
        property real lineX: width / 2
        property real knobCenter: knob.y + knob.height / 2
        property real curveRadius: Math.min(55, knobCenter, height - knobCenter)
        property real curveTop: Math.max(0, knobCenter - curveRadius)
        property real curveBottom: Math.min(height, knobCenter + curveRadius)
        x: 349
        y: 35

        Component.onCompleted: knob.y = (height - knob.height) * 0.5

        Behavior on bend {
            SpringAnimation { spring: 5; damping: 0.35 }
        }

        // Max label
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 0
            text: root.maxTemp + "°"
            font.pixelSize: 7
            color: "#334455"
        }

        // Min label
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height - 10
            text: root.minTemp + "°"
            font.pixelSize: 7
            color: "#334455"
        }

        // Background track
        Rectangle {
            width: 2
            height: parent.height - 24
            x: tempSlider.lineX - 1
            y: 12
            color: "#1a1a25"
            radius: 1
        }

        // Tick marks
        Repeater {
            model: 8
            Rectangle {
                x: tempSlider.lineX + 6
                y: 12 + index * (tempSlider.height - 28) / 7
                width: index % 2 === 0 ? 6 : 3
                height: 1
                color: "#2a2a35"
            }
        }

        // Glow
        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            layer.enabled: root.acOn
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 1.0
                blurMax: 40
            }
            ShapePath {
                strokeWidth: 8
                strokeColor: Qt.rgba(
                                 root.accentColor.r,
                                 root.accentColor.g,
                                 root.accentColor.b,
                                 root.acOn ? 0.15 : 0.03
                                 )
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: tempSlider.lineX; startY: 0
                PathLine { x: tempSlider.lineX; y: tempSlider.curveTop }
                PathCubic {
                    x: tempSlider.lineX; y: tempSlider.curveBottom
                    control1X: tempSlider.lineX - tempSlider.bend * 1.3
                    control1Y: tempSlider.curveTop + tempSlider.curveRadius * 0.5
                    control2X: tempSlider.lineX - tempSlider.bend * 1.3
                    control2Y: tempSlider.curveBottom - tempSlider.curveRadius * 0.5
                }
                PathLine { x: tempSlider.lineX; y: tempSlider.height }
            }
        }

        // Main line
        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 0.2
                blurMax: 12
                brightness: root.acOn ? 0.4 : 0.0
            }
            ShapePath {
                strokeWidth: 2
                strokeColor: root.acOn ? root.accentColor : "#2a2a35"
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: tempSlider.lineX; startY: 0
                PathLine { x: tempSlider.lineX; y: tempSlider.curveTop }
                PathCubic {
                    x: tempSlider.lineX; y: tempSlider.curveBottom
                    control1X: tempSlider.lineX - tempSlider.bend
                    control1Y: tempSlider.curveTop + tempSlider.curveRadius * 0.5
                    control2X: tempSlider.lineX - tempSlider.bend
                    control2Y: tempSlider.curveBottom - tempSlider.curveRadius * 0.5
                }
                PathLine { x: tempSlider.lineX; y: tempSlider.height }
                Behavior on strokeColor { ColorAnimation { duration: 400 } }
            }
        }

        // Knob glow ring
        Rectangle {
            width: knob.width + 16
            height: width
            radius: width / 2
            x: knob.x - 8
            y: knob.y - 8
            color: "transparent"
            border.color: knobArea.pressed
                          ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.3)
                          : "transparent"
            border.width: 2
            layer.enabled: knobArea.pressed
            layer.effect: MultiEffect { blurEnabled: true; blur: 1.0; blurMax: 20 }
            Behavior on border.color { ColorAnimation { duration: 200 } }
        }

        // Knob
        Rectangle {
            id: knob
            width: 30
            height: 30
            radius: 15
            x: tempSlider.lineX - 15
            y: tempSlider.height / 2 - 15
            border.color: knobArea.pressed ? root.accentColor : "#3a3a45"
            border.width: 2

            gradient: Gradient {
                GradientStop { position: 0.0; color: knobArea.pressed ? "#3a3a45" : "#2a2a35" }
                GradientStop { position: 0.5; color: "#1a1a22" }
                GradientStop { position: 1.0; color: "#101015" }
            }

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#80000000"
                shadowBlur: 0.5
                shadowVerticalOffset: 3
            }

            Behavior on border.color { ColorAnimation { duration: 200 } }

            Rectangle {
                anchors.centerIn: parent
                width: 18; height: 18; radius: 9
                color: "transparent"
                border.color: "#2a2a35"
                border.width: 1
            }

            Rectangle {
                anchors.centerIn: parent
                width: 5; height: 5; radius: 2.5
                color: root.acOn ? root.accentColor : "#334455"
                layer.enabled: root.acOn
                layer.effect: MultiEffect {
                    blurEnabled: true
                    blur: 0.8
                    blurMax: 10
                    brightness: 0.5
                }
                Behavior on color { ColorAnimation { duration: 400 } }
            }

            MouseArea {
                id: knobArea
                anchors.fill: parent
                drag.target: knob
                drag.axis: Drag.YAxis
                drag.minimumY: 0
                drag.maximumY: tempSlider.height - knob.height
                enabled: root.acOn
            }
        }
    }

    Column {
        x: 35
        y: 125
        width: parent.width - 56
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -31
        spacing: 4

        Text {
            text: root.acOn ? root.temperature.toFixed(1) + "°C" : "OFF"
            font.pixelSize: root.acOn ? 48 : 32
            font.bold: true
            font.family: "Inter"
            font.letterSpacing: -1
            color: root.acOn ? root.accentColor : "#334455"

            Behavior on color { ColorAnimation { duration: 400 } }
            Behavior on font.pixelSize { NumberAnimation { duration: 200 } }

            layer.enabled: root.acOn
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 0.3
                blurMax: 12
                brightness: 0.15
            }
        }

        Text {
            text: !root.acOn ? "SYSTEM OFF"
                             : root.temperature >= 26 ? "WARM"
                                                      : root.temperature <= 19 ? "COOL"
                                                                               : "COMFORT"
            font.pixelSize: 8
            font.bold: true
            font.letterSpacing: 2
            color: root.acOn ? root.accentColor : "#334455"
            Behavior on color { ColorAnimation { duration: 400 } }
        }
    }

    Row {
        x: 87
        y: 72
        width: 312
        height: 180
        spacing: -182

        // Morphing slider

        // Temperature display
    }

    Row {
        id: row
        x: 14
        y: 14
        width: 419
        height: 24
        spacing: -11

        Text {
            text: "CLIMATE"
            font.pixelSize: 9
            font.bold: true
            font.letterSpacing: 2
            color: "#667788"
            anchors.verticalCenter: parent.verticalCenter
        }

        Item { width: parent.width - 96; height: 1 }

        Rectangle {
            width: 38
            height: 20
            radius: 10
            color: root.autoMode ? root.accentColor : "#1a1a25"
            border.color: root.autoMode ? root.accentColor : "#2a2a35"
            border.width: 1
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation { duration: 200 } }

            Text {
                anchors.centerIn: parent
                text: "AUTO"
                font.pixelSize: 7
                font.bold: true
                font.letterSpacing: 1
                color: root.autoMode ? "#111118" : "#445566"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: root.autoMode = !root.autoMode
            }
        }

        Item { width: 4; height: 1 }

        // Power
        Rectangle {
            width: 20
            height: 20
            radius: 10
            color: root.acOn ? root.accentColor : "#1a1a25"
            border.color: root.acOn ? root.accentColor : "#2a2a35"
            border.width: 1
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 2
            Behavior on color { ColorAnimation { duration: 200 } }

            Item {
                anchors.centerIn: parent
                width: 10
                height: 10
                property color iconColor: root.acOn ? "#111118" : "#445566"

                Rectangle {
                    width: 1.5; height: 4; radius: 1
                    color: parent.iconColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                }
                Shape {
                    anchors.fill: parent
                    antialiasing: true
                    ShapePath {
                        strokeColor: parent.parent.iconColor
                        strokeWidth: 1.5
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        PathAngleArc {
                            centerX: 5; centerY: 6
                            radiusX: 3; radiusY: 3
                            startAngle: 120; sweepAngle: 300
                        }
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: root.acOn = !root.acOn
            }
        }
    }






}
