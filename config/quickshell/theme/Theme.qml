pragma Singleton
import QtQuick

QtObject {
    property string active: "mocha"

    readonly property string font: "JetBrainsMono Nerd Font"

    readonly property var profiles: ({
            "mocha": {
                crust: "#11111b",
                mantle: "#181825",
                base: "#1e1e2e",
                surface0: "#313244",
                surface1: "#45475a",
                surface2: "#585b70",
                text: "#cdd6f4",
                subtext0: "#a6adc8",
                subtext1: "#bac2de",
                lavender: "#b4befe",
                mauve: "#cba6f7",
                blue: "#89b4fa",
                green: "#a6e3a1",
                yellow: "#f9e2af",
                peach: "#fab387",
                red: "#f38ba8"
            },
            "latte": {
                crust: "#dce0e8",
                mantle: "#e6e9ef",
                base: "#eff1f5",
                surface0: "#ccd0da",
                surface1: "#bcc0cc",
                surface2: "#acb0be",
                text: "#4c4f69",
                subtext0: "#6c6f85",
                subtext1: "#5c5f77",
                lavender: "#7287fd",
                mauve: "#8839ef",
                blue: "#1e66f5",
                green: "#40a02b",
                yellow: "#df8e1d",
                peach: "#fe640b",
                red: "#d20f39"
            }
        })

    readonly property var p: profiles[active]

    readonly property color crust: p.crust
    readonly property color mantle: p.mantle
    readonly property color base: p.base
    readonly property color surface0: p.surface0
    readonly property color surface1: p.surface1
    readonly property color surface2: p.surface2
    readonly property color text: p.text
    readonly property color subtext0: p.subtext0
    readonly property color subtext1: p.subtext1
    readonly property color lavender: p.lavender
    readonly property color mauve: p.mauve
    readonly property color blue: p.blue
    readonly property color green: p.green
    readonly property color yellow: p.yellow
    readonly property color peach: p.peach
    readonly property color red: p.red
}
