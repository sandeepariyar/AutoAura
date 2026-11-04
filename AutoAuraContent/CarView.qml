/**
 * AutoAura
 * Car View Component
 *
 * Author: Sandeep Pariyar
 * Created: 2026
 */

import QtQuick

Item {
    id: root
    width: 260
    height: 260

    // ============ FRAME RANGES ============
    property int defaultStart: 0
    property int defaultEnd: 59

    property int doorsStart: 60
    property int doorsEnd: 74

    property int chargingStart: 75
    property int chargingTransitionEnd: 85
    property int chargingSliderStart: 85
    property int chargingSliderEnd: 114

    property int seatHeatStart: 115
    property int seatHeatTransitionEnd: 129
    property int seatHeatSliderStart: 130
    property int seatHeatSliderEnd: 163

    // Seat heat level frame ranges
    property int seatHeatLevel1End: 140
    property int seatHeatLevel2End: 151
    property int seatHeatLevel3End: 163

    // ============ STATE ============
    property int currentFrame: 0
    property bool isAnimating: false
    property bool isDragging: false  // NEW: track if user is dragging
    property int frameRate: 14
    property int fastFrameRate: 28
    property real dragSensitivity: 0.5
    property string spritePath: "images/sprite/car_set_sprite"
    property string spriteExtension: ".png"
    property bool showShadow: true

    // Current mode: "default", "doors", "charging", "seatHeat"
    property string mode: "default"

    // Feature states
    property bool doorsOpen: false
    property real chargingLevel: 0.0
    property real seatHeatLevel: 0.0

    // Seat heat loop state
    property int seatHeatCurrentLevel: 0
    property int seatHeatLoopEnd: 140

    // Transition state
    property bool isTransitioning: false
    property int transitionTarget: 0
    property bool transitionForward: true
    property string transitionAction: ""
    property bool useFastTransition: false

    // Lock state
    property bool isLocked: true
    property bool isLocking: false

    // Signals
    signal carRotationStarted()
    signal carRotationStopped()
    signal carFrameUpdated()
    signal carDoorsOpened()
    signal carDoorsClosed()
    signal carModeUpdated()
    signal carLocked()

    // ============ CAR SPRITE ============
    Image {
        id: carImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: root.spritePath + root.currentFrame.toString().padStart(3, '0') + root.spriteExtension
        smooth: true
        antialiasing: true
        cache: true
    }

    // Car shadow
    Rectangle {
        id: carShadow
        width: parent.width * 0.7
        height: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -10
        radius: 10
        color: "#15000000"
        visible: root.showShadow
    }

    // ============ DEFAULT ROTATION TIMER ============
    Timer {
        id: rotationTimer
        interval: 1000 / root.frameRate
        repeat: true
        // Runs when: animating, default mode, not transitioning, not locked, NOT dragging
        running: root.isAnimating && root.mode === "default" && !root.isTransitioning && !root.isLocked && !root.isLocking && !root.isDragging
        onTriggered: {
            if (root.currentFrame >= root.defaultEnd) {
                root.currentFrame = root.defaultStart
            } else {
                root.currentFrame = root.currentFrame + 1
            }
            root.carFrameUpdated()
        }
    }

    // ============ SEAT HEAT LOOP TIMER ============
    Timer {
        id: seatHeatLoopTimer
        interval: 1000 / root.frameRate
        repeat: true
        running: root.mode === "seatHeat" && root.seatHeatCurrentLevel > 0 && !root.isTransitioning && !root.isLocked && !root.isLocking
        onTriggered: {
            if (root.currentFrame >= root.seatHeatLoopEnd) {
                root.currentFrame = root.seatHeatSliderStart
            } else {
                root.currentFrame = root.currentFrame + 1
            }
            root.carFrameUpdated()
        }
    }

    // ============ TRANSITION TIMER ============
    Timer {
        id: transitionTimer
        interval: root.useFastTransition ? (1000 / root.fastFrameRate) : (1000 / root.frameRate)
        repeat: true
        running: root.isTransitioning
        onTriggered: {
            var step = root.useFastTransition ? 2 : 1

            if (root.transitionForward) {
                if (root.currentFrame < root.transitionTarget) {
                    root.currentFrame = Math.min(root.currentFrame + step, root.transitionTarget)
                    root.carFrameUpdated()
                } else {
                    root.currentFrame = root.transitionTarget
                    root.carFrameUpdated()
                    transitionTimer.stop()
                    root.isTransitioning = false
                    root.useFastTransition = false
                    root.handleTransitionComplete()
                }
            } else {
                if (root.currentFrame > root.transitionTarget) {
                    root.currentFrame = Math.max(root.currentFrame - step, root.transitionTarget)
                    root.carFrameUpdated()
                } else {
                    root.currentFrame = root.transitionTarget
                    root.carFrameUpdated()
                    transitionTimer.stop()
                    root.isTransitioning = false
                    root.useFastTransition = false
                    root.handleTransitionComplete()
                }
            }
        }
    }

    // ============ TRANSITION COMPLETE HANDLER ============
    function handleTransitionComplete() {
        console.log("Transition complete:", transitionAction, "Frame:", currentFrame)

        var action = transitionAction
        transitionAction = ""

        if (action === "goToZeroForDoors") {
            currentFrame = doorsStart
            startTransition(doorsEnd, true, "doorsOpened", false)

        } else if (action === "goToZeroForCharging") {
            currentFrame = chargingStart
            startTransition(chargingTransitionEnd, true, "chargingReady", false)

        } else if (action === "goToZeroForSeatHeat") {
            currentFrame = seatHeatStart
            startTransition(seatHeatTransitionEnd, true, "seatHeatReady", false)

        } else if (action === "doorsOpened") {
            carDoorsOpened()

        } else if (action === "doorsClosed") {
            currentFrame = defaultStart
            doorsOpen = false
            mode = "default"
            carDoorsClosed()
            carModeUpdated()

            if (isLocking) {
                finalizeLock()
            } else if (!isLocked) {
                isAnimating = true
                carRotationStarted()
            }

        } else if (action === "chargingReady") {
            updateChargingLevel(chargingLevel)

        } else if (action === "chargingHidden") {
            currentFrame = defaultStart
            mode = "default"
            carModeUpdated()

            if (isLocking) {
                finalizeLock()
            } else if (!isLocked) {
                isAnimating = true
                carRotationStarted()
            }

        } else if (action === "seatHeatReady") {
            if (seatHeatCurrentLevel > 0) {
                currentFrame = seatHeatSliderStart
            }

        } else if (action === "seatHeatHidden") {
            currentFrame = defaultStart
            mode = "default"
            seatHeatCurrentLevel = 0
            carModeUpdated()

            if (isLocking) {
                finalizeLock()
            } else if (!isLocked) {
                isAnimating = true
                carRotationStarted()
            }

        } else if (action === "resetComplete") {
            currentFrame = defaultStart
            mode = "default"
            carModeUpdated()

            if (isLocking) {
                finalizeLock()
            }

        } else if (action === "lockingDoorsToBase") {
            currentFrame = defaultStart
            doorsOpen = false
            mode = "default"
            carDoorsClosed()
            carModeUpdated()
            finalizeLock()

        } else if (action === "lockingChargingToBase") {
            currentFrame = defaultStart
            mode = "default"
            carModeUpdated()
            finalizeLock()

        } else if (action === "lockingSeatHeatToBase") {
            currentFrame = defaultStart
            mode = "default"
            seatHeatCurrentLevel = 0
            carModeUpdated()
            finalizeLock()

        } else if (action === "lockingDefaultToZero") {
            currentFrame = defaultStart
            mode = "default"
            carModeUpdated()
            finalizeLock()
        }
    }

    // ============ FINALIZE LOCK ============
    function finalizeLock() {
        console.log("Finalizing lock - frame:", currentFrame)
        isLocking = false
        isLocked = true
        isAnimating = false
        isDragging = false
        chargingLevel = 0.0
        seatHeatLevel = 0.0
        seatHeatCurrentLevel = 0
        carRotationStopped()
        carLocked()
    }

    // ============ HELPER FUNCTION ============
    function startTransition(target, forward, action, fast) {
        console.log("Starting transition:", action, "from", currentFrame, "to", target, "forward:", forward)
        transitionAction = action
        transitionTarget = target
        transitionForward = forward
        useFastTransition = fast
        isTransitioning = true
        transitionTimer.start()
    }

    // ============ DRAG INTERACTION ============
    MouseArea {
        id: dragArea
        anchors.fill: parent
        property int lastX: 0
        enabled: root.mode === "default" && !root.isTransitioning && !root.isLocked && !root.isLocking

        onPressed: function(mouse) {
            lastX = mouse.x
            root.isDragging = true  // Pause auto animation while dragging
        }

        onReleased: {
            root.isDragging = false  // Resume auto animation when released
        }

        onCanceled: {
            root.isDragging = false  // Resume if drag is canceled
        }

        onPositionChanged: function(mouse) {
            var delta = mouse.x - lastX
            if (Math.abs(delta) > 3) {
                var frameShift = Math.round(delta * root.dragSensitivity)
                var newFrame = root.currentFrame + frameShift
                var range = root.defaultEnd - root.defaultStart + 1

                while (newFrame < root.defaultStart) {
                    newFrame = newFrame + range
                }
                while (newFrame > root.defaultEnd) {
                    newFrame = newFrame - range
                }

                root.currentFrame = newFrame
                root.carFrameUpdated()
                lastX = mouse.x
            }
        }

        // REMOVED: onDoubleClicked - no more double tap to spin
    }

    // ============ PUBLIC FUNCTIONS ============

    function lock() {
        console.log("LOCKING CAR - current mode:", mode, "frame:", currentFrame)

        isAnimating = false
        isDragging = false
        rotationTimer.stop()
        seatHeatLoopTimer.stop()
        isLocking = true

        if (isTransitioning) {
            transitionTimer.stop()
            isTransitioning = false
            useFastTransition = false
            transitionAction = ""
        }

        if (mode === "doors") {
            if (currentFrame > doorsStart) {
                startTransition(doorsStart, false, "lockingDoorsToBase", false)
            } else {
                currentFrame = defaultStart
                doorsOpen = false
                mode = "default"
                carDoorsClosed()
                carModeUpdated()
                finalizeLock()
            }
        } else if (mode === "charging") {
            if (currentFrame > chargingStart) {
                startTransition(chargingStart, false, "lockingChargingToBase", false)
            } else {
                currentFrame = defaultStart
                mode = "default"
                carModeUpdated()
                finalizeLock()
            }
        } else if (mode === "seatHeat") {
            if (currentFrame > seatHeatStart) {
                startTransition(seatHeatStart, false, "lockingSeatHeatToBase", false)
            } else {
                currentFrame = defaultStart
                mode = "default"
                seatHeatCurrentLevel = 0
                carModeUpdated()
                finalizeLock()
            }
        } else {
            if (currentFrame > defaultStart) {
                console.log("Default mode: animating from", currentFrame, "to 0")
                startTransition(defaultStart, false, "lockingDefaultToZero", false)
            } else {
                console.log("Already at frame 0, finalizing lock")
                finalizeLock()
            }
        }
    }

    function unlock() {
        console.log("UNLOCKING CAR - enabling animations")
        isLocked = false
        isLocking = false
        isDragging = false
        startRotation()
    }

    function startRotation() {
        if (isLocked || isLocking) return
        if (mode === "default" && !isTransitioning) {
            isAnimating = true
            carRotationStarted()
        }
    }

    function stopRotation() {
        isAnimating = false
        carRotationStopped()
    }

    function toggleRotation() {
        if (isLocked || isLocking) return
        if (isAnimating) {
            stopRotation()
        } else {
            startRotation()
        }
    }

    function resetToDefault() {
        if (isLocking) return

        isAnimating = false
        isDragging = false
        seatHeatCurrentLevel = 0

        if (isTransitioning) {
            transitionTimer.stop()
            isTransitioning = false
            useFastTransition = false
            transitionAction = ""
        }

        if (mode === "doors") {
            if (currentFrame > doorsStart) {
                startTransition(doorsStart, false, "doorsClosed", false)
            } else {
                currentFrame = defaultStart
                doorsOpen = false
                mode = "default"
                carDoorsClosed()
                carModeUpdated()
            }
        } else if (mode === "charging") {
            if (currentFrame > chargingStart) {
                startTransition(chargingStart, false, "chargingHidden", false)
            } else {
                currentFrame = defaultStart
                mode = "default"
                carModeUpdated()
            }
        } else if (mode === "seatHeat") {
            if (currentFrame > seatHeatStart) {
                startTransition(seatHeatStart, false, "seatHeatHidden", false)
            } else {
                currentFrame = defaultStart
                mode = "default"
                carModeUpdated()
            }
        } else {
            if (currentFrame !== defaultStart) {
                startTransition(defaultStart, false, "resetComplete", false)
            } else {
                mode = "default"
                carModeUpdated()
            }
        }
    }

    // ============ DOORS ============
    function toggleDoors() {
        console.log("=== toggleDoors ===")

        if (isLocked || isLocking) return
        if (isTransitioning) return

        if (doorsOpen) {
            doorsOpen = false
            console.log("ACTION: Closing doors - state updated INSTANTLY")
            startTransition(doorsStart, false, "doorsClosed", false)
        } else {
            if (mode !== "default") return

            doorsOpen = true
            mode = "doors"
            carModeUpdated()
            console.log("ACTION: Opening doors - state updated INSTANTLY")

            isAnimating = false

            if (currentFrame !== defaultStart) {
                startTransition(defaultStart, false, "goToZeroForDoors", false)
            } else {
                currentFrame = doorsStart
                startTransition(doorsEnd, true, "doorsOpened", false)
            }
        }
    }

    // ============ CHARGING ============
    function toggleCharging() {
        if (isLocked || isLocking) return
        if (isTransitioning) return

        if (mode === "charging") {
            mode = "default"
            carModeUpdated()
            console.log("ACTION: Hiding charging - state updated INSTANTLY")
            startTransition(chargingStart, false, "chargingHidden", false)
        } else {
            if (mode !== "default") return

            mode = "charging"
            carModeUpdated()
            console.log("ACTION: Showing charging - state updated INSTANTLY")

            isAnimating = false

            if (currentFrame !== defaultStart) {
                startTransition(defaultStart, false, "goToZeroForCharging", false)
            } else {
                currentFrame = chargingStart
                startTransition(chargingTransitionEnd, true, "chargingReady", false)
            }
        }
    }

    function updateChargingLevel(level) {
        if (isLocked || isLocking) return
        if (mode !== "charging" || isTransitioning) return

        chargingLevel = Math.max(0, Math.min(1, level))
        var frameRange = chargingSliderEnd - chargingSliderStart
        currentFrame = chargingSliderStart + Math.round(frameRange * chargingLevel)
        carFrameUpdated()
    }

    // ============ SEAT HEAT ============
    function toggleSeatHeat() {
        if (isLocked || isLocking) return
        if (isTransitioning) return

        if (mode === "seatHeat") {
            mode = "default"
            seatHeatCurrentLevel = 0
            carModeUpdated()
            console.log("ACTION: Hiding seat heat - state updated INSTANTLY")
            startTransition(seatHeatStart, false, "seatHeatHidden", false)
        } else {
            if (mode !== "default") return

            mode = "seatHeat"
            carModeUpdated()
            console.log("ACTION: Showing seat heat - state updated INSTANTLY")

            isAnimating = false

            if (currentFrame !== defaultStart) {
                startTransition(defaultStart, false, "goToZeroForSeatHeat", false)
            } else {
                currentFrame = seatHeatStart
                startTransition(seatHeatTransitionEnd, true, "seatHeatReady", false)
            }
        }
    }

    function setSeatHeatLevel(level) {
        if (isLocked || isLocking) return
        if (mode !== "seatHeat" || isTransitioning) return

        seatHeatCurrentLevel = level
        currentFrame = seatHeatSliderStart

        if (level === 1) {
            seatHeatLoopEnd = seatHeatLevel1End
        } else if (level === 2) {
            seatHeatLoopEnd = seatHeatLevel2End
        } else if (level === 3) {
            seatHeatLoopEnd = seatHeatLevel3End
        }

        console.log("Seat heat level:", level, "Loop end:", seatHeatLoopEnd)
    }

    function stopSeatHeatLoop() {
        seatHeatCurrentLevel = 0
    }

    function updateSeatHeatLevel(level) {
        if (isLocked || isLocking) return
        if (mode !== "seatHeat" || isTransitioning) return

        seatHeatLevel = Math.max(0, Math.min(1, level))

        if (level <= 0.33) {
            setSeatHeatLevel(1)
        } else if (level <= 0.66) {
            setSeatHeatLevel(2)
        } else {
            setSeatHeatLevel(3)
        }
    }
}
