
// Created with Qt Design Studio (version 4.8.2), Thu Feb 12 13:43:34 2026
// Do not manually edit this file, it will be overwritten if effect is modified in Qt Design Studio.

import QtQuick

Item {
    id: rootItem

    // Use visible property to show and hide the effect.
    visible: true

    // This is an internal property used by tooling to identify effect items. Do not modify.
    property bool _isEffectItem

    // This is an internal property used to manage the effect. Do not modify.
    property Item _oldParent: null

    // This is the main source for the effect. Set internally to the current parent item. Do not modify.
    property Item source: null
    // Enable this to animate iTime property
    property bool timeRunning: true
    // When timeRunning is false, this can be used to control iTime manually
    property real animatedTime: 0

    function setupParentLayer()
    {
        if (_oldParent && _oldParent !== parent) {
            _oldParent.layer.enabled = false
            _oldParent.layer.effect = null
            
            source = null
            _oldParent.update()
            _oldParent = null
        }
        if (parent) {
            _oldParent = parent
            if (visible) {
                parent.layer.enabled = true
                parent.layer.effect = effectComponent
                
                source = parent
            } else {
                parent.layer.enabled = false
                parent.layer.effect = null
                
                source = null
            }
            parent.update()
        }

    }

    onParentChanged: setupParentLayer()

    onVisibleChanged: setupParentLayer()

    FrameAnimation {
        id: frameAnimation
        running: rootItem.timeRunning
    }

    Component {
        id: effectComponent
        ShaderEffect {
            property Item source: null
            readonly property Item iSource: rootItem.source
            readonly property real iTime: frameAnimation.running ? frameAnimation.elapsedTime : rootItem.animatedTime
            readonly property vector3d iResolution: Qt.vector3d(width, height, 1.0)

            vertexShader: 'holo.vert.qsb'
            fragmentShader: 'holo.frag.qsb'
            anchors.fill: rootItem.source
        }
    }
}
