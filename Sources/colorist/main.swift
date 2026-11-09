import Foundation
import KitBridge

// colorist: prints KitBridge's colors in CSS formats, and parses some CSS colors, run with `swift run colorist`

let colors: [(String, ILColor)] = [
    // Adaptable colors
    ("systemBlue", .systemBlue), ("systemBrown", .systemBrown), ("systemCyan", .systemCyan),
    ("systemGreen", .systemGreen), ("systemIndigo", .systemIndigo), ("systemMint", .systemMint),
    ("systemOrange", .systemOrange), ("systemPink", .systemPink), ("systemPurple", .systemPurple),
    ("systemRed", .systemRed), ("systemTeal", .systemTeal), ("systemYellow", .systemYellow),
    // Adaptable gray colors
    ("systemGray", .systemGray), ("systemGray2", .systemGray2), ("systemGray3", .systemGray3),
    ("systemGray4", .systemGray4), ("systemGray5", .systemGray5), ("systemGray6", .systemGray6),
    // Fixed colors
    ("clear", .clear), ("black", .black), ("blue", .blue), ("brown", .brown), ("cyan", .cyan),
    ("darkGray", .darkGray), ("gray", .gray), ("green", .green), ("lightGray", .lightGray),
    ("magenta", .magenta), ("orange", .orange), ("purple", .purple), ("red", .red),
    ("white", .white), ("yellow", .yellow),
    // Label colors
    ("label", .label), ("secondaryLabel", .secondaryLabel), ("tertiaryLabel", .tertiaryLabel),
    ("quaternaryLabel", .quaternaryLabel),
    // Text colors
    ("text", .text), ("placeholderText", .placeholderText), ("selectedText", .selectedText),
    ("textBackground", .textBackground), ("selectedTextBackground", .selectedTextBackground),
    ("keyboardFocusIndicator", .keyboardFocusIndicator), ("unemphasizedSelectedText", .unemphasizedSelectedText),
    ("unemphasizedSelectedTextBackground", .unemphasizedSelectedTextBackground),
    // Content colors
    ("link", .link), ("separator", .separator), ("selectedContentBackground", .selectedContentBackground),
    ("unemphasizedSelectedContentBackground", .unemphasizedSelectedContentBackground),
    ("selectedMenuItemText", .selectedMenuItemText),
    // Table colors
    ("grid", .grid), ("headerText", .headerText),
    ("alternatingContentBackgrounds[0]", ILColor.alternatingContentBackgrounds[0]),
    ("alternatingContentBackgrounds[1]", ILColor.alternatingContentBackgrounds[1]),
    // Control colors
    ("controlAccent", .controlAccent), ("control", .control), ("controlText", .controlText),
    ("controlBackground", .controlBackground), ("disabledControlText", .disabledControlText),
    ("selectedControl", .selectedControl), ("selectedControlText", .selectedControlText),
    ("alternateSelectedControlText", .alternateSelectedControlText),
    // Window colors
    ("windowBackground", .windowBackground), ("windowFrameText", .windowFrameText),
    ("underPageBackground", .underPageBackground),
    // Highlights and shadows
    ("findHighlight", .findHighlight), ("highlight", .highlight), ("shadow", .shadow)
]

func padded(_ string: String?, _ width: Int) -> String {
    (string ?? "-").padding(toLength: width, withPad: " ", startingAt: 0)
}

for (name, color) in colors {
    print("\(padded(color.cssHex, 8)) \(padded(color.cssRGBA, 24)) \(padded(color.cssHSLA, 24)) \(name)")
}

print("---------- CSS Color Tests ----------")
for css in ["#F14", "#FB194C", "#FB194C80", "rgb(128, 60, 14)", "rgb(128,60,14)", "rgba(128, 60, 14, 0.666)",
            "hsl(358, 44%, 98%)", "hsla(123, 80%, 90%, 0.666)", "not a color"] {
    let color = ILColor(css: css)
    print("\(padded(css, 28)) \(padded(color?.cssRGBA, 24)) \(color?.cssHSLA ?? "-")")
}
