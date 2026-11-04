/**
 * AutoAura
 * Action Buttons Panel Component
 *
 * Author: Sandeep Pariyar
 * Created: 2026
 */

import QtQuick

Column {
    id: root
    spacing: 16

    signal buttonClicked(int index)

    ActionButton {
        iconText: "⚡"
        iconColor: "#FF6B6B"
        hasNotification: true
        notificationColor: "#FF6B6B"
        onClicked: root.buttonClicked(0)
    }

    ActionButton {
        iconText: "❄"
        iconColor: "#9E9E9E"
        onClicked: root.buttonClicked(1)
    }

    ActionButton {
        iconText: "◎"
        iconColor: "#9E9E9E"
        onClicked: root.buttonClicked(2)
    }

    ActionButton {
        iconText: "⚡"
        iconColor: "#9E9E9E"
        onClicked: root.buttonClicked(3)
    }
}
