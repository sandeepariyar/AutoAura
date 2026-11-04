import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Rectangle {
    id: root
    width: 500
    height: 500
    color: "#00f0f4f2"

    // ========== WHITE THEME WITH GREEN ACCENTS ==========
    QtObject {
        id: theme



        // Bar colors
        property color barFill: "#ffffff"
        property color barStroke: "#e0e8e4"
        property color barGlow: "#22c55e"

        // Knob colors
        property color knobFill: "#ffffff"
        property color knobBorder: "#d4e4da"
        property color knobActive: "#22c55e"
        property color knobInner: "#e8f0ec"

        // Accent colors (green)
        property color accent1: "#22c55e"
        property color accent2: "#16a34a"
        property color accent3: "#15803d"

        // Text colors
        property color textPrimary: "#22c55e"
        property color textSecondary: "#4ade80"
        property color textMuted: "#86efac"

        // Shadow
        property color shadowColor: "#20000000"
    }
    // ====================================================

    // Background gradient

    // Subtle floating particles
    Repeater {
        model: 12
        Rectangle {
            property real startX: Math.random() * root.width
            property real duration: 4000 + Math.random() * 3000

            width: 2 + Math.random() * 3
            height: width
            radius: width / 2
            x: startX
            color: theme.accent1
            opacity: 0

            SequentialAnimation on y {
                loops: Animation.Infinite
                PropertyAction { value: root.height + 20 }
                NumberAnimation { to: -20; duration: duration }
            }

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { to: 0.2 + Math.random() * 0.15; duration: duration * 0.3 }
                NumberAnimation { to: 0; duration: duration * 0.7 }
            }
        }
    }

    // Header

    Item {
        id: navBar
        width: 380
        height: 140
        anchors.centerIn: parent

        property real barY: 55
        property real barHeight: 55
        property real barLeft: 30
        property real barRight: width - 30
        property real barRadius: 27.5

        property real bend: knobArea.pressed ? 30 : 0
        property real knobCenter: knob.x + knob.width / 2

        property var snapPoints: [75, 190, 305]
        property int currentIndex: 0

        property var colors: [theme.accent1, theme.accent2, theme.accent3]

        property real maxCurveRadius: 50
        property real distFromLeft: knobCenter - barLeft - barRadius
        property real distFromRight: barRight - barRadius - knobCenter
        property real curveRadius: Math.max(0, Math.min(maxCurveRadius, distFromLeft, distFromRight))
        property real actualBend: curveRadius > 2 ? bend : bend * (curveRadius / 2)

        property real curveLeft: knobCenter - curveRadius
        property real curveRight: knobCenter + curveRadius

        Behavior on bend {
            SpringAnimation { spring: 5; damping: 0.35 }
        }

        // Bar glow effect (green glow)
        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 1.0
                blurMax: 64
            }

            ShapePath {
                strokeWidth: 0
                fillColor: Qt.rgba(0.13, 0.77, 0.37, 0.12)

                startX: navBar.barLeft + navBar.barRadius
                startY: navBar.barY

                PathLine { x: navBar.curveLeft; y: navBar.barY }

                PathCubic {
                    x: navBar.curveRight
                    y: navBar.barY
                    control1X: navBar.curveLeft + navBar.curveRadius * 0.5
                    control1Y: navBar.barY + navBar.actualBend
                    control2X: navBar.curveRight - navBar.curveRadius * 0.5
                    control2Y: navBar.barY + navBar.actualBend
                }

                PathLine { x: navBar.barRight - navBar.barRadius; y: navBar.barY }

                PathArc {
                    x: navBar.barRight
                    y: navBar.barY + navBar.barRadius
                    radiusX: navBar.barRadius
                    radiusY: navBar.barRadius
                    direction: PathArc.Clockwise
                }

                PathLine { x: navBar.barRight; y: navBar.barY + navBar.barHeight - navBar.barRadius }

                PathArc {
                    x: navBar.barRight - navBar.barRadius
                    y: navBar.barY + navBar.barHeight
                    radiusX: navBar.barRadius
                    radiusY: navBar.barRadius
                    direction: PathArc.Clockwise
                }

                PathLine { x: navBar.barLeft + navBar.barRadius; y: navBar.barY + navBar.barHeight }

                PathArc {
                    x: navBar.barLeft
                    y: navBar.barY + navBar.barHeight - navBar.barRadius
                    radiusX: navBar.barRadius
                    radiusY: navBar.barRadius
                    direction: PathArc.Clockwise
                }

                PathLine { x: navBar.barLeft; y: navBar.barY + navBar.barRadius }

                PathArc {
                    x: navBar.barLeft + navBar.barRadius
                    y: navBar.barY
                    radiusX: navBar.barRadius
                    radiusY: navBar.barRadius
                    direction: PathArc.Clockwise
                }
            }
        }

        // Main filled bar shape (WHITE)
        Shape {
            id: barShape
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: theme.shadowColor
                shadowBlur: 0.6
                blurMax: 40
                shadowVerticalOffset: 10
            }

            ShapePath {
                strokeWidth: 1
                strokeColor: theme.barStroke
                fillColor: theme.barFill

                startX: navBar.barLeft + navBar.barRadius
                startY: navBar.barY

                PathLine { x: navBar.curveLeft; y: navBar.barY }

                PathCubic {
                    x: navBar.curveRight
                    y: navBar.barY
                    control1X: navBar.curveLeft + navBar.curveRadius * 0.5
                    control1Y: navBar.barY + navBar.actualBend
                    control2X: navBar.curveRight - navBar.curveRadius * 0.5
                    control2Y: navBar.barY + navBar.actualBend
                }

                PathLine { x: navBar.barRight - navBar.barRadius; y: navBar.barY }

                PathArc {
                    x: navBar.barRight
                    y: navBar.barY + navBar.barRadius
                    radiusX: navBar.barRadius
                    radiusY: navBar.barRadius
                    direction: PathArc.Clockwise
                }

                PathLine { x: navBar.barRight; y: navBar.barY + navBar.barHeight - navBar.barRadius }

                PathArc {
                    x: navBar.barRight - navBar.barRadius
                    y: navBar.barY + navBar.barHeight
                    radiusX: navBar.barRadius
                    radiusY: navBar.barRadius
                    direction: PathArc.Clockwise
                }

                PathLine { x: navBar.barLeft + navBar.barRadius; y: navBar.barY + navBar.barHeight }

                PathArc {
                    x: navBar.barLeft
                    y: navBar.barY + navBar.barHeight - navBar.barRadius
                    radiusX: navBar.barRadius
                    radiusY: navBar.barRadius
                    direction: PathArc.Clockwise
                }

                PathLine { x: navBar.barLeft; y: navBar.barY + navBar.barRadius }

                PathArc {
                    x: navBar.barLeft + navBar.barRadius
                    y: navBar.barY
                    radiusX: navBar.barRadius
                    radiusY: navBar.barRadius
                    direction: PathArc.Clockwise
                }
            }
        }

        // Icons on the bar (GREEN)
        Repeater {
            model: 3

            Item {
                x: navBar.snapPoints[index] - 20
                y: navBar.barY
                width: 40
                height: navBar.barHeight

                // Home icon
                Shape {
                    anchors.centerIn: parent
                    width: 26
                    height: 26
                    visible: index === 0
                    opacity: navBar.currentIndex === 0 ? 0 : 0.7
                    scale: navBar.currentIndex === 0 ? 0.5 : 1

                    Behavior on opacity { NumberAnimation { duration: 200 } }
                    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

                    ShapePath {
                        strokeWidth: 2
                        strokeColor: theme.accent1
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        joinStyle: ShapePath.RoundJoin

                        PathSvg {
                            path: "M 3 13 L 13 3 L 23 13 M 5.5 11 L 5.5 23 L 20.5 23 L 20.5 11 M 10 23 L 10 16 L 16 16 L 16 23"
                        }
                    }
                }

                // Plus icon
                Shape {
                    anchors.centerIn: parent
                    width: 26
                    height: 26
                    visible: index === 1
                    opacity: navBar.currentIndex === 1 ? 0 : 0.7
                    scale: navBar.currentIndex === 1 ? 0.5 : 1

                    Behavior on opacity { NumberAnimation { duration: 200 } }
                    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

                    ShapePath {
                        strokeWidth: 2.5
                        strokeColor: theme.accent2
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap

                        PathSvg {
                            path: "M 13 4 L 13 22 M 4 13 L 22 13"
                        }
                    }
                }

                // Profile icon
                Shape {
                    anchors.centerIn: parent
                    width: 26
                    height: 26
                    visible: index === 2
                    opacity: navBar.currentIndex === 2 ? 0 : 0.7
                    scale: navBar.currentIndex === 2 ? 0.5 : 1

                    Behavior on opacity { NumberAnimation { duration: 200 } }
                    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

                    ShapePath {
                        strokeWidth: 2
                        strokeColor: theme.accent3
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap

                        PathSvg {
                            path: "M 13 10 C 16 10 18 7.5 18 5 C 18 2.5 16 0 13 0 C 10 0 8 2.5 8 5 C 8 7.5 10 10 13 10 Z"
                        }
                    }

                    ShapePath {
                        strokeWidth: 2
                        strokeColor: theme.accent3
                        fillColor: Qt.rgba(0.13, 0.77, 0.37, 0.15)
                        capStyle: ShapePath.RoundCap

                        PathSvg {
                            path: "M 13 12 C 7 12 2 15.5 2 20 L 2 25 L 24 25 L 24 20 C 24 15.5 19 12 13 12 Z"
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -10
                    onClicked: {
                        navBar.currentIndex = index
                        knob.x = navBar.snapPoints[index] - knob.width / 2
                    }
                }
            }
        }

        // Knob glow ring (green)
        Rectangle {
            width: knob.width + 24
            height: width
            radius: width / 2
            x: knob.x - 12
            y: knob.y - 12
            color: "transparent"
            border.color: knobArea.pressed ? Qt.rgba(0.13, 0.77, 0.37, 0.5) : "transparent"
            border.width: 3

            layer.enabled: knobArea.pressed
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 1.0
                blurMax: 32
            }

            Behavior on border.color { ColorAnimation { duration: 200 } }
        }

        // Pulse ring (green)
        Rectangle {
            width: knob.width + 30
            height: width
            radius: width / 2
            x: knob.x - 15
            y: knob.y - 15
            color: "transparent"
            border.color: navBar.colors[navBar.currentIndex]
            border.width: 2
            opacity: 0
            scale: 0.9

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { to: 0.5; duration: 1000 }
                NumberAnimation { to: 0; duration: 800 }
            }

            SequentialAnimation on scale {
                loops: Animation.Infinite
                NumberAnimation { to: 1.25; duration: 1800 }
                NumberAnimation { to: 0.9; duration: 0 }
            }
        }

        // Draggable knob (WHITE with green border when active)
        Rectangle {
            id: knob
            width: 68
            height: 68
            radius: 34
            x: navBar.snapPoints[0] - width / 2
            y: navBar.barY - height / 2 + 8
            color: theme.knobFill
            border.color: knobArea.pressed ? theme.knobActive : theme.knobBorder
            border.width: knobArea.pressed ? 3 : 2

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#30000000"
                shadowBlur: 0.5
                blurMax: 32
                shadowVerticalOffset: 6
            }

            Behavior on border.color { ColorAnimation { duration: 200 } }
            Behavior on border.width { NumberAnimation { duration: 200 } }
            Behavior on x {
                enabled: !knobArea.pressed
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.3
                }
            }

            // Inner circle
            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 16
                height: width
                radius: width / 2
                color: "transparent"
                border.color: theme.knobInner
                border.width: 1
            }

            // Dynamic icon inside knob (GREEN)
            Item {
                anchors.centerIn: parent
                width: 28
                height: 28

                // Home icon in knob
                Shape {
                    anchors.fill: parent
                    visible: navBar.currentIndex === 0
                    scale: navBar.currentIndex === 0 ? 1 : 0.5
                    opacity: navBar.currentIndex === 0 ? 1 : 0

                    Behavior on opacity { NumberAnimation { duration: 200 } }
                    Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        blurEnabled: true
                        blur: 0.2
                        blurMax: 8
                        brightness: 0.1
                    }

                    ShapePath {
                        strokeWidth: 2.5
                        strokeColor: theme.accent1
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        joinStyle: ShapePath.RoundJoin

                        PathSvg {
                            path: "M 3 14 L 14 3 L 25 14 M 6 12 L 6 25 L 22 25 L 22 12 M 11 25 L 11 17 L 17 17 L 17 25"
                        }
                    }
                }

                // Plus icon in knob
                Shape {
                    anchors.fill: parent
                    visible: navBar.currentIndex === 1
                    scale: navBar.currentIndex === 1 ? 1 : 0.5
                    opacity: navBar.currentIndex === 1 ? 1 : 0

                    Behavior on opacity { NumberAnimation { duration: 200 } }
                    Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        blurEnabled: true
                        blur: 0.2
                        blurMax: 8
                        brightness: 0.1
                    }

                    ShapePath {
                        strokeWidth: 3
                        strokeColor: theme.accent2
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap

                        PathSvg {
                            path: "M 14 4 L 14 24 M 4 14 L 24 14"
                        }
                    }
                }

                // Profile icon in knob
                Shape {
                    anchors.fill: parent
                    visible: navBar.currentIndex === 2
                    scale: navBar.currentIndex === 2 ? 1 : 0.5
                    opacity: navBar.currentIndex === 2 ? 1 : 0

                    Behavior on opacity { NumberAnimation { duration: 200 } }
                    Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        blurEnabled: true
                        blur: 0.2
                        blurMax: 8
                        brightness: 0.1
                    }

                    ShapePath {
                        strokeWidth: 2.5
                        strokeColor: theme.accent3
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap

                        PathSvg {
                            path: "M 14 11 C 17 11 19 8.5 19 6 C 19 3.5 17 1 14 1 C 11 1 9 3.5 9 6 C 9 8.5 11 11 14 11 Z"
                        }
                    }

                    ShapePath {
                        strokeWidth: 0
                        fillColor: Qt.rgba(0.13, 0.77, 0.37, 0.3)

                        PathSvg {
                            path: "M 14 13 C 8 13 3 16.5 3 21 L 3 27 L 25 27 L 25 21 C 25 16.5 20 13 14 13 Z"
                        }
                    }
                }
            }

            MouseArea {
                id: knobArea
                anchors.fill: parent
                drag.target: knob
                drag.axis: Drag.XAxis
                drag.minimumX: navBar.snapPoints[0] - knob.width / 2
                drag.maximumX: navBar.snapPoints[2] - knob.width / 2

                onReleased: {
                    var knobCenterX = knob.x + knob.width / 2
                    var minDist = Number.MAX_VALUE
                    var snapIndex = 0

                    for (var i = 0; i < navBar.snapPoints.length; i++) {
                        var dist = Math.abs(knobCenterX - navBar.snapPoints[i])
                        if (dist < minDist) {
                            minDist = dist
                            snapIndex = i
                        }
                    }

                    navBar.currentIndex = snapIndex
                    knob.x = navBar.snapPoints[snapIndex] - knob.width / 2
                }
            }
        }
    }

    // Current selection label (GREEN text)

    // Footer (GREEN text)
}
