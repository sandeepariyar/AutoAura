/**
 * AutoAura
 * Main Application Screen
 *
 * Author: Sandeep Pariyar
 * Created: 2026
 */

import QtQuick
import QtQuick.Studio.DesignEffects
import Generated.Effects.RingEffect

Rectangle {
    id: root
    width: 450
    height: 844
    color: "#EAECEF"

    property bool engineOn: false

    function resetAllButtons() {
        chargingBtn.isActive = false
        seatHeatBtn.isActive = false
        doorsBtn.isActive = false
        climateBtn.isActive = false
    }

    Rectangle {
        id: card
        width: 450
        height: 844
        anchors.centerIn: parent
        color: "#e6e7eb"
        radius: 35

        // Charging state
        property int chargePercent: 0
        property bool isCharging: false

        function startCharging() {
            chargePercent = 0
            isCharging = true
            chargeTimer.start()
        }

        function stopCharging() {
            isCharging = false
            chargeTimer.stop()
        }

        Timer {
            id: chargeTimer
            interval: 100
            repeat: true
            running: card.isCharging
            onTriggered: {
                if (card.chargePercent < 100) {
                    card.chargePercent = card.chargePercent + 1
                    var level = card.chargePercent / 100
                    carView.updateChargingLevel(level)
                } else {
                    card.chargePercent = 0
                }
            }
        }

        // Seat Heat state
        property int seatHeatLevel: 0  // 0 = Off, 1 = Low, 2 = Medium, 3 = High

        function setSeatHeatLevel(level) {
            if (seatHeatLevel === level) {
                // Same button clicked - turn off
                seatHeatLevel = 0
                seatHeatBtn.isActive = false
                carView.stopSeatHeatLoop()
                carView.toggleSeatHeat()
            } else {
                seatHeatLevel = level
                carView.setSeatHeatLevel(level)
            }
        }

        function resetSeatHeat() {
            seatHeatLevel = 0
        }

        // ============ CAR VIEW ============

        CarView {
            id: carView
            width: 450
            height: 668
            clip: true
            anchors.horizontalCenter: parent.horizontalCenter
            y: 0
            isAnimating: false

            spritePath: "images/sprite/car_set_sprite"
            frameRate: 12
            fastFrameRate: 32
            showShadow: true
        }

        // ============ BIG CHARGING PERCENTAGE ============
        Rectangle {
            id: rectangle
            x: 0
            y: 647
            width: 450
            height: 197
            gradient: Gradient {
                GradientStop {
                    position: 1
                    color: "#cfd9df"
                }

                GradientStop {
                    position: 0
                    color: "#e2ebf0"
                }
                orientation: Gradient.Vertical
            }

            DesignEffect {
                backgroundBlurVisible: false
                layerBlurRadius: 20
                backgroundBlurRadius: 45
            }
        }

        Text {
            id: chargingPercentDisplay
            anchors.horizontalCenter: parent.horizontalCenter
            y: 520
            text: card.chargePercent + "%"
            font.pixelSize: 72
            font.bold: true
            font.family: "Inter"
            color: "#22C55E"
            opacity: chargingBtn.isActive ? 1 : 0
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }
        }

        // Charging status text
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 595
            spacing: 8
            opacity: chargingBtn.isActive ? 1 : 0
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }

            Text {
                id: chargingIcon
                text: "⚡"
                font.pixelSize: 14
                color: "#22C55E"

                SequentialAnimation on opacity {
                    running: card.isCharging
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 400 }
                    NumberAnimation { to: 1.0; duration: 400 }
                }
            }

            Text {
                text: "Charging..."
                font.pixelSize: 14
                font.bold: true
                color: "#9CA3AF"
            }
        }

        // ============ SEAT HEAT DISPLAY ============

        Column {
            id: seatHeatDisplay
            anchors.horizontalCenter: parent.horizontalCenter
            y: seatHeatBtn.isActive ? 542 : 650  // Animate from bottom
            spacing: 16
            opacity: seatHeatBtn.isActive ? 1 : 0
            visible: opacity > 0

            Behavior on y {
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.2
                }
            }
            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }

            // 3 Heat Level Buttons
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20

                // Level 1 - Low (Blue)
                Rectangle {
                    id: heatLevel1Btn
                    width: 56
                    height: 56
                    radius: 28
                    color: card.seatHeatLevel === 1 ? "#3B82F6" : "#FFFFFF"

                    Column {
                        anchors.centerIn: parent
                        spacing: 2

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "1"
                            font.pixelSize: 20
                            font.bold: true
                            color: card.seatHeatLevel === 1 ? "#FFFFFF" : "#3B82F6"
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Low"
                            font.pixelSize: 8
                            font.bold: true
                            color: card.seatHeatLevel === 1 ? "#FFFFFF" : "#3B82F6"
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: card.setSeatHeatLevel(1)
                    }
                }

                // Level 2 - Medium (Yellow/Orange)
                Rectangle {
                    id: heatLevel2Btn
                    width: 56
                    height: 56
                    radius: 28
                    color: card.seatHeatLevel === 2 ? "#F59E0B" : "#FFFFFF"

                    Column {
                        anchors.centerIn: parent
                        spacing: 2

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "2"
                            font.pixelSize: 20
                            font.bold: true
                            color: card.seatHeatLevel === 2 ? "#FFFFFF" : "#F59E0B"
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Mid"
                            font.pixelSize: 8
                            font.bold: true
                            color: card.seatHeatLevel === 2 ? "#FFFFFF" : "#F59E0B"
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: card.setSeatHeatLevel(2)
                    }
                }

                // Level 3 - High (Red)
                Rectangle {
                    id: heatLevel3Btn
                    width: 56
                    height: 56
                    radius: 28
                    color: card.seatHeatLevel === 3 ? "#EF4444" : "#FFFFFF"

                    Column {
                        anchors.centerIn: parent
                        spacing: 2

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "3"
                            font.pixelSize: 20
                            font.bold: true
                            color: card.seatHeatLevel === 3 ? "#FFFFFF" : "#EF4444"
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "High"
                            font.pixelSize: 8
                            font.bold: true
                            color: card.seatHeatLevel === 3 ? "#FFFFFF" : "#EF4444"
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: card.setSeatHeatLevel(3)
                    }
                }
            }
        }



        // ============ HEADER SECTION ============
        Item {
            id: headerSection
            x: 32
            y: 48
            width: parent.width - 64
            height: 130

            Rectangle {
                id: brandTag
                width: 148
                height: 28
                radius: 14
                x: root.engineOn ? -120 : 0
                opacity: root.engineOn ? 0 : 1
                color: "#1A1A1A"

                Behavior on x {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }

                Text {
                    anchors.centerIn: parent
                    text: "SANDEEP PARIYAR"
                    font.pixelSize: 10
                    font.styleName: "ExtraLight"
                    font.family: "Inter"
                    font.bold: true
                    font.letterSpacing: 2
                    color: "#FFFFFF"
                }
            }

            Row {
                id: titleRow
                y: root.engineOn ? -20 : 30

                Behavior on y {
                    NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                }

                Text {
                    id: titleTextModel
                    text: "Model "
                    font.pixelSize: root.engineOn ? 90 : 64
                    font.bold: true
                    font.family: "Inter"
                    font.styleName: "ExtraBold"
                    font.letterSpacing: -2
                    color: "#d5ffffff"

                    Behavior on font.pixelSize {
                        NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                    }


                }

                Text {
                    id: titleTextQ
                    text: "Q"
                    font.pixelSize: root.engineOn ? 90 : 64
                    font.bold: true
                    font.family: "Inter"
                    font.styleName: "ExtraBold"
                    font.letterSpacing: -2
                    color: "#77df90"

                    // Magnetic offset
                    property real magneticX: 0
                    x: magneticX

                    Behavior on font.pixelSize {
                        NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                    }
                }
            }

            // Q magnetic animation
            SequentialAnimation {
                id: qMagneticAnimation

                NumberAnimation {
                    target: titleTextQ
                    property: "magneticX"
                    to: 25
                    duration: 150
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: titleTextQ
                    property: "magneticX"
                    to: 0
                    duration: 400
                    easing.type: Easing.OutElastic
                    easing.amplitude: 1.2
                    easing.period: 0.4
                }
            }

            Text {
                id: subtitleText
                y: root.engineOn ? 96 : 102
                text: "Concept Car"
                font.pixelSize: 14
                font.family: "Inter"
                font.letterSpacing: 1
                color: "#9CA3AF"

                Behavior on y {
                    NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                }
            }

            Rectangle {
                id: lockStatus
                x: root.engineOn ? 0 : 150
                y: root.engineOn ? 92 : 98
                width: root.engineOn ? 100 : 90
                height: 28
                radius: 14
                color: root.engineOn ? "#1A1A1A" : "#FFFFFF"
                border.width: root.engineOn ? 0 : 2
                border.color: "#22C55E"

                Behavior on x {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutBack
                        easing.overshoot: 1.0
                    }
                }
                Behavior on y {
                    NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                }
                Behavior on width {
                    NumberAnimation { duration: 300 }
                }
                Behavior on color {
                    ColorAnimation { duration: 300 }
                }

                Row {
                    anchors.centerIn: parent
                    spacing: 6

                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: root.engineOn ? "#EF4444" : "#22C55E"
                        anchors.verticalCenter: parent.verticalCenter

                        SequentialAnimation on opacity {
                            running: root.engineOn
                            loops: Animation.Infinite
                            NumberAnimation { to: 0.4; duration: 500 }
                            NumberAnimation { to: 1.0; duration: 500 }
                        }
                    }

                    Text {
                        text: root.engineOn ? "UNLOCKED" : "LOCKED"
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 1
                        color: root.engineOn ? "#FFFFFF" : "#22C55E"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
            // ============ INFO BUTTON (Top Right) ============
            Rectangle {
                id: infoBtn
                x: 357
                width: 36
                height: 36
                radius: 18
                y: -20
                color: infoOverlay.visible ? "#1A1A1A" : "#FFFFFF"
                border.width: infoOverlay.visible ? 0 : 2
                border.color: "#E5E7EB"

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }

                Text {
                    anchors.centerIn: parent
                    text: "i"
                    font.pixelSize: 18
                    font.bold: true
                    font.italic: true
                    font.family: "Georgia"
                    color: infoOverlay.visible ? "#FFFFFF" : "#9CA3AF"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        infoOverlay.visible = !infoOverlay.visible
                    }
                }
            }

            // ============ INFO OVERLAY ============
            Rectangle {
                id: infoOverlay
                anchors.fill: parent
                color: "#0077df90"
                visible: false
                opacity: visible ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Close when clicking outside the card
                        infoOverlay.visible = false
                    }
                }

                Rectangle {
                    id: infoCard
                    width: parent.width - 60
                    height: 350
                    anchors.centerIn: parent
                    radius: 28
                    anchors.verticalCenterOffset: 244
                    color: "#9effffff"
                    y: infoOverlay.visible ? parent.height / 2 - height / 2 : parent.height + 50

                    Behavior on y {
                        NumberAnimation {
                            duration: 400
                            easing.type: Easing.OutBack
                            easing.overshoot: 1.0
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            // Prevent closing when clicking on the card
                        }
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 6

                        // App Icon
                        Rectangle {
                            width: 80
                            height: 80
                            radius: 20
                            anchors.horizontalCenter: parent.horizontalCenter
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#77df90" }
                                GradientStop { position: 1.0; color: "#22C55E" }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "Q"
                                font.pixelSize: 42
                                font.bold: true
                                font.family: "Inter"
                                color: "#FFFFFF"
                            }
                        }

                        // App Name
                        Column {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 4

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "AutoAura"
                                font.pixelSize: 28
                                font.bold: true
                                font.family: "Inter"
                                color: "#1A1A1A"
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Model Q Concept"
                                font.pixelSize: 14
                                color: "#9CA3AF"
                            }
                        }

                        // Divider
                        Rectangle {
                            width: 200
                            height: 1
                            color: "#E5E7EB"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        // Author Section
                        Column {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 8

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "DESIGNED & DEVELOPED BY"
                                font.pixelSize: 10
                                font.bold: true
                                font.letterSpacing: 2
                                color: "#9CA3AF"
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Sandeep Pariyar"
                                font.pixelSize: 22
                                font.bold: true
                                font.family: "Inter"
                                color: "#1A1A1A"
                            }
                        }

                        // Version & Year
                        Column {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 4

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Version 1.0"
                                font.pixelSize: 12
                                color: "#9CA3AF"
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "© 2026"
                                font.pixelSize: 12
                                color: "#9CA3AF"
                            }
                        }

                        // Divider
                        Rectangle {
                            width: 200
                            height: 1
                            color: "#E5E7EB"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        // Tech Stack
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Built with Qt Design Studio"
                            font.pixelSize: 11
                            color: "#9CA3AF"
                        }

                        // Close Button
                        Rectangle {
                            width: 120
                            height: 40
                            radius: 20
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "#1A1A1A"

                            Text {
                                anchors.centerIn: parent
                                text: "CLOSE"
                                font.pixelSize: 12
                                font.bold: true
                                font.letterSpacing: 1
                                color: "#FFFFFF"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    infoOverlay.visible = false
                                }
                            }
                        }
                    }

                    DesignEffect {
                        backgroundBlurRadius: 16
                        backgroundLayer: carView
                        layerBlurRadius: 0
                    }
                }
            }

        }

        Text {
            id: hintText
            anchors.horizontalCenter: parent.horizontalCenter
            y: 590
            text: {
                if (!root.engineOn) {
                    return ""
                } else if (doorsBtn.isActive) {
                    return "Doors Open"
                } else if (!chargingBtn.isActive && !seatHeatBtn.isActive) {
                    return "Drag to rotate"  // CHANGED: removed "Double-tap to spin"
                }
                return ""
            }
            font.pixelSize: 11
            font.letterSpacing: 0.5
            color: "#C4C4C4"
            opacity: (root.engineOn && !chargingBtn.isActive && !seatHeatBtn.isActive) ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
            }
        }

        // ============ ACTION BUTTONS (Right Side) ============

        // Charging Button (1st)
        // Charging Button (1st)
        Rectangle {
            id: chargingBtn
            property bool isActive: false
            property bool showButton: false

            width: 48
            height: 48
            radius: 24
            x: {
                if (!showButton) return parent.width + 20
                if (isActive) return parent.width - 68
                if (seatHeatBtn.isActive || doorsBtn.isActive || climateBtn.isActive) return parent.width + 20
                return parent.width - 68
            }
            y: 200
            opacity: {
                if (!showButton) return 0
                if (isActive) return 1
                if (seatHeatBtn.isActive || doorsBtn.isActive || climateBtn.isActive) return 0
                return 1
            }

            color: isActive ? "#EF4444" : "#FFFFFF"
            border.width: isActive ? 0 : 2
            border.color: "#E5E7EB"

            Behavior on x {
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.5
                }
            }
            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }

            Text {
                anchors.centerIn: parent
                text: "⚡"
                font.pixelSize: 22
                color: chargingBtn.isActive ? "#FFFFFF" : "#9CA3AF"
            }

            Rectangle {
                width: 12
                height: 12
                radius: 6
                color: "#FFFFFF"
                border.width: 2
                border.color: "#EF4444"
                x: parent.width - 14
                y: -2
                visible: !chargingBtn.isActive
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (chargingBtn.isActive) {
                        chargingBtn.isActive = false
                        card.stopCharging()
                        carView.toggleCharging()
                    } else {
                        seatHeatBtn.isActive = false
                        card.resetSeatHeat()
                        doorsBtn.isActive = false
                        climateBtn.isActive = false
                        chargingBtn.isActive = true
                        carView.toggleCharging()
                        card.startCharging()
                    }
                }
            }
        }

        // Seat Heat Button (2nd)
        Rectangle {
            id: seatHeatBtn
            property bool isActive: false
            property bool showButton: false

            width: 48
            height: 48
            radius: 24
            x: {
                if (!showButton) return parent.width + 20
                if (isActive) return parent.width - 68
                if (chargingBtn.isActive || doorsBtn.isActive || climateBtn.isActive) return parent.width + 20
                return parent.width - 68
            }
            y: 260
            opacity: {
                if (!showButton) return 0
                if (isActive) return 1
                if (chargingBtn.isActive || doorsBtn.isActive || climateBtn.isActive) return 0
                return 1
            }

            color: isActive ? "#F59E0B" : "#FFFFFF"
            border.width: isActive ? 0 : 2
            border.color: "#E5E7EB"

            Behavior on x {
                NumberAnimation {
                    duration: 450
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.6
                }
            }
            Behavior on opacity {
                NumberAnimation { duration: 350 }
            }

            Text {
                anchors.centerIn: parent
                text: "♨"
                font.pixelSize: 24
                color: seatHeatBtn.isActive ? "#FFFFFF" : "#9CA3AF"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (seatHeatBtn.isActive) {
                        seatHeatBtn.isActive = false
                        card.resetSeatHeat()
                        carView.toggleSeatHeat()
                    } else {
                        chargingBtn.isActive = false
                        card.stopCharging()
                        doorsBtn.isActive = false
                        climateBtn.isActive = false
                        seatHeatBtn.isActive = true
                        carView.toggleSeatHeat()
                    }
                }
            }
        }

        // Doors Button (3rd)
        Rectangle {
            id: doorsBtn
            property bool isActive: false
            property bool showButton: false

            width: 48
            height: 48
            radius: 24
            x: {
                if (!showButton) return parent.width + 20
                if (isActive) return parent.width - 68
                if (chargingBtn.isActive || seatHeatBtn.isActive || climateBtn.isActive) return parent.width + 20
                return parent.width - 68
            }
            y: 320
            opacity: {
                if (!showButton) return 0
                if (isActive) return 1
                if (chargingBtn.isActive || seatHeatBtn.isActive || climateBtn.isActive) return 0
                return 1
            }

            color: isActive ? "#3B82F6" : "#FFFFFF"
            border.width: isActive ? 0 : 2
            border.color: "#E5E7EB"

            Behavior on x {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.7
                }
            }
            Behavior on opacity {
                NumberAnimation { duration: 400 }
            }

            Text {
                anchors.centerIn: parent
                text: "🚪"
                font.pixelSize: 20
                color: doorsBtn.isActive ? "#FFFFFF" : "#9CA3AF"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (doorsBtn.isActive) {
                        doorsBtn.isActive = false
                        carView.toggleDoors()
                    } else {
                        chargingBtn.isActive = false
                        card.stopCharging()
                        seatHeatBtn.isActive = false
                        card.resetSeatHeat()
                        climateBtn.isActive = false
                        doorsBtn.isActive = true
                        carView.toggleDoors()
                    }
                }
            }
        }

        // Climate Button (4th)
        Rectangle {
            id: climateBtn
            property bool isActive: false
            property bool showButton: false

            width: 48
            height: 48
            radius: 24
            x: {
                if (!showButton) return parent.width + 20
                if (isActive) return parent.width - 68
                if (chargingBtn.isActive || seatHeatBtn.isActive || doorsBtn.isActive) return parent.width + 20
                return parent.width - 68
            }
            y: 380
            opacity: {
                if (!showButton) return 0
                if (isActive) return 1
                if (chargingBtn.isActive || seatHeatBtn.isActive || doorsBtn.isActive) return 0
                return 1
            }

            color: isActive ? "#0EA5E9" : "#FFFFFF"
            border.width: isActive ? 0 : 2
            border.color: "#E5E7EB"

            Behavior on x {
                NumberAnimation {
                    duration: 550
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.8
                }
            }
            Behavior on opacity {
                NumberAnimation { duration: 450 }
            }

            Text {
                anchors.centerIn: parent
                text: "❄"
                font.pixelSize: 22
                color: climateBtn.isActive ? "#FFFFFF" : "#9CA3AF"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (climateBtn.isActive) {
                        climateBtn.isActive = false
                    } else {
                        chargingBtn.isActive = false
                        card.stopCharging()
                        seatHeatBtn.isActive = false
                        card.resetSeatHeat()
                        doorsBtn.isActive = false
                        climateBtn.isActive = true
                    }
                    console.log("Climate button clicked")
                }
            }
        }


        // ============ BUTTON SHOW TIMERS ============
        Timer {
            id: showChargingBtn
            interval: 200
            onTriggered: chargingBtn.showButton = true
        }
        Timer {
            id: showSeatHeatBtn
            interval: 300
            onTriggered: seatHeatBtn.showButton = true
        }
        Timer {
            id: showDoorsBtn
            interval: 400
            onTriggered: doorsBtn.showButton = true
        }
        Timer {
            id: showClimateBtn
            interval: 500
            onTriggered: climateBtn.showButton = true
        }

        // ============ BOTTOM SECTION ============

        // ============ BOTTOM SECTION WITH PARALLAX ============

        // Parallax state properties (add inside card Rectangle)
        property bool showRange: false
        property bool showTemp: false
        property bool showDivider: false
        property bool showBattery: false
        property bool showBatteryFill: false

        // Parallax timers
        Timer {
            id: showRangeTimer
            interval: 150
            onTriggered: card.showRange = true
        }
        Timer {
            id: showTempTimer
            interval: 200
            onTriggered: card.showTemp = true
        }
        Timer {
            id: showDividerTimer
            interval: 250
            onTriggered: card.showDivider = true
        }
        Timer {
            id: showBatteryTimer
            interval: 350
            onTriggered: card.showBattery = true
        }
        Timer {
            id: showBatteryFillTimer
            interval: 500
            onTriggered: card.showBatteryFill = true
        }

        Rectangle {
            id: bottomCard
            x: 20
            y: root.engineOn ? parent.height - 250 : parent.height + 850
            width: parent.width - 40
            height: 150
            radius: 28
            color: "#97ffffff"

            Behavior on y {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.OutCubic
                }
            }

            // Range stat
            Column {
                id: rangeStat
                x: 120
                y: card.showRange ? 24 : 100
                spacing: 4
                opacity: card.showRange ? 1 : 0

                Behavior on y {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.OutBack
                        easing.overshoot: 1.1
                    }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 400 }
                }

                Text {
                    text: "RANGE"
                    font.pixelSize: 15
                    font.bold: true
                    font.letterSpacing: 1.5
                    color: "#9CA3AF"
                }

                Row {
                    spacing: 4

                    Text {
                        text: "150"
                        font.pixelSize: 60
                        font.bold: true
                        font.family: "Inter"
                        font.letterSpacing: -1
                        color: "#1A1A1A"
                    }

                    Text {
                        text: "mi"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#9CA3AF"
                    }
                }
            }

            // Divider
            Rectangle {
                id: statsDivider
                x: 269
                y: card.showDivider ? 30 : 80
                width: 1
                height: card.showDivider ? 50 : 0
                color: "#E5E7EB"
                opacity: card.showDivider ? 1 : 0

                Behavior on y {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on height {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }
            }

            // Temp stat
            Column {
                id: tempStat
                x: 295
                y: card.showTemp ? 24 : 100
                spacing: 4
                opacity: card.showTemp ? 1 : 0

                Behavior on y {
                    NumberAnimation {
                        duration: 650
                        easing.type: Easing.OutBack
                        easing.overshoot: 1.2
                    }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 400 }
                }

                Text {
                    text: "TEMP"
                    font.pixelSize: 15
                    font.bold: true
                    font.letterSpacing: 1.5
                    color: "#9CA3AF"
                }

                Row {
                    spacing: 4

                    Text {
                        text: "72"
                        font.pixelSize: 60
                        font.bold: true
                        font.family: "Inter"
                        font.letterSpacing: -1
                        color: "#1A1A1A"
                    }

                    Text {
                        text: "°F"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#9CA3AF"
                    }
                }
            }

            // Battery section
            Column {
                id: batterySection
                x: 24
                y: card.showBattery ? 110 : 160
                width: parent.width - 48
                spacing: 8
                opacity: card.showBattery ? 1 : 0

                Behavior on y {
                    NumberAnimation {
                        duration: 700
                        easing.type: Easing.OutBack
                        easing.overshoot: 1.0
                    }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 500 }
                }

                Row {
                    width: parent.width

                    Text {
                        text: "Battery"
                        font.pixelSize: 12
                        font.bold: true
                        color: "#6B7280"
                    }

                    Item {
                        width: parent.width - 100
                        height: 1
                    }

                    Text {
                        id: batteryPercentText
                        text: "75%"
                        font.pixelSize: 12
                        font.bold: true
                        color: "#22C55E"
                    }
                }

                Rectangle {
                    id: batteryBar
                    width: parent.width
                    height: 8
                    radius: 4
                    color: "#F3F4F6"

                    Rectangle {
                        id: batteryFill
                        width: card.showBatteryFill ? parent.width * 0.75 : 0
                        height: parent.height
                        radius: 4
                        color: "#22C55E"

                        Behavior on width {
                            NumberAnimation {
                                duration: 800
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }

            // DesignEffect {
            //     layerBlurRadius: root.engineOn ? 0 : 22
            //     layerBlurVisible: true

            //     backgroundBlurRadius: 5
            //     backgroundLayer: rectangle
            //     effects: [
            //         DesignDropShadow {
            //         }
            //     ]
            // }
        }

        // ============ POWER BUTTON ============


        Rectangle {
            id: powerGlow
            width: root.engineOn ? 84 : 170
            height: root.engineOn ? 84 : 170
            x: root.engineOn ? bottomCard.x + 16 : (parent.width - width) / 2
            y: root.engineOn ? bottomCard.y + 16 : 590
            radius: width / 2

            Behavior on width {
                NumberAnimation { duration: 400; easing.type: Easing.OutBack }
            }
            Behavior on height {
                NumberAnimation { duration: 400; easing.type: Easing.OutBack }
            }
            color: "#00ef4444"
            Behavior on x {
                NumberAnimation { duration: 450; easing.type: Easing.OutCubic }
            }
            Behavior on y {
                NumberAnimation { duration: 450; easing.type: Easing.OutCubic }
            }

            RingEffect {
                id: ringEffect
                timeRunning: true
            }
        }



        Rectangle {
            id: powerButton
            property bool isOn: false

            width: root.engineOn ? 64 : 120
            height: root.engineOn ? 64 : 120
            x: root.engineOn ? bottomCard.x + 26 : (parent.width - width) / 2
            y: root.engineOn ? bottomCard.y + 26 : 610
            radius: width / 2

            color: isOn ? "#EF4444" : "#00ef4444"

            Behavior on width {
                NumberAnimation { duration: 450; easing.type: Easing.OutBack }
            }
            Behavior on height {
                NumberAnimation { duration: 450; easing.type: Easing.OutBack }
            }
            Behavior on x {
                NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
            }
            Behavior on y {
                NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
            }

            Text {
                anchors.centerIn: parent
                text: "⏻"
                font.pixelSize: root.engineOn ? 26 : 42
                color: powerButton.isOn ? "#FFFFFF" : "#EF4444"
            }


            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.bottom
                anchors.topMargin: 16
                text: "START ENGINE"
                font.pixelSize: 12
                font.bold: true
                font.letterSpacing: 2
                color: "#9CA3AF"
                opacity: root.engineOn ? 0 : 1

                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }
            }


            MouseArea {
                anchors.fill: parent
                onClicked: {
                    powerButton.isOn = !powerButton.isOn
                    root.engineOn = powerButton.isOn

                    if (powerButton.isOn) {
                        // Start parallax timers
                        showRangeTimer.start()
                        showTempTimer.start()
                        showDividerTimer.start()
                        showBatteryTimer.start()
                        showBatteryFillTimer.start()

                        // Existing button timers
                        showChargingBtn.start()
                        showSeatHeatBtn.start()
                        showDoorsBtn.start()
                        showClimateBtn.start()
                        carView.unlock()
                    } else {
                        // Reset parallax states
                        card.showRange = false
                        card.showTemp = false
                        card.showDivider = false
                        card.showBattery = false
                        card.showBatteryFill = false

                        // Existing reset
                        chargingBtn.showButton = false
                        seatHeatBtn.showButton = false
                        doorsBtn.showButton = false
                        climateBtn.showButton = false
                        card.stopCharging()
                        card.resetSeatHeat()
                        root.resetAllButtons()
                        carView.lock()
                    }
                }
            }

        }


        SequentialAnimation {
            running: !root.engineOn
            loops: Animation.Infinite

            NumberAnimation {
                target: powerGlow
                property: "opacity"
                from: 0.3
                to: 0.8
                duration: 1000
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                target: powerGlow
                property: "opacity"
                from: 0.8
                to: 0.3
                duration: 1000
                easing.type: Easing.InOutSine
            }
        }




    }

    AcController {
        id: acController
        x: -4
        y: 198
        width: 454
        height: 425
        visible: false
    }

    NavBar {
        id: navBar
        x: 0
        y: 599
        width: 450
        height: 396
        visible: false
        rotation: 0
    }


}


