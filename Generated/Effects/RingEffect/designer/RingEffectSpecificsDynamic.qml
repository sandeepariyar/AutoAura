
// Created with Qt Design Studio (version 4.8.2), Thu Feb 12 14:13:42 2026
// Do not manually edit this file, it will be overwritten if effect is modified in Qt Design Studio.

import QtQuick
import QtQuick.Layouts
import HelperWidgets
import StudioTheme as StudioTheme

Column {

    Section {
        caption: "Animation"
        width: parent.width

        SectionLayout {
            PropertyLabel {
                text: "Running"
                tooltip: "Set this property to animate the effect."
            }

            SecondColumnLayout {
                CheckBox {
                    id: timeRunningCheckBox
                    text: backendValues.timeRunning.valueToString
                    backendValue: backendValues.timeRunning
                    implicitWidth: StudioTheme.Values.twoControlColumnWidth
                                + StudioTheme.Values.actionIndicatorWidth
                }
                ExpandingSpacer {}
            }

            PropertyLabel {
                text: "Time"
                tooltip: "This property allows explicit control of current animation time when Running property is false."
            }

            SecondColumnLayout {
                SpinBox {
                    enabled: !timeRunningCheckBox.checked
                    minimumValue: 0
                    maximumValue: 9999999
                    decimals: 2
                    stepSize: .01
                    backendValue: backendValues.animatedTime
                    implicitWidth: StudioTheme.Values.singleControlColumnWidth
                                   + StudioTheme.Values.actionIndicatorWidth
                }
                ExpandingSpacer {}
            }
        }
    }
}
