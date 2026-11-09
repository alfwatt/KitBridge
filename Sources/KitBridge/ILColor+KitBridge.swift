import Foundation
#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif
#if canImport(CoreImage)
import CoreImage
#endif

// MARK: - CSS Colors

public extension ILColor {
    /// the color for a
    /// @param css color string, e.g. `#FFF`, `#FFFFFF`, `#FFFFFF80`, `rgb(255, 255, 255)`, `rgba(255, 255, 255, 0.5)`,
    /// `hsl(360, 100%, 50%)` or `hsla(360, 100%, 50%, 0.5)`, see [CSS Color](https://www.w3.org/TR/css-color-4/),
    /// or nil if it can't be parsed
    convenience init?(css: String) {
        let css = css.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if css.hasPrefix("#") {
            let digits = Array(css.dropFirst())
            func channel(_ range: Range<Int>) -> CGFloat? {
                let hex = String(digits[range])
                guard let value = UInt8(hex, radix: 16) else { return nil }
                return CGFloat(range.count == 1 ? value * 17 : value) / 255 // #F is #FF
            }
            let width = (digits.count == 3 || digits.count == 4) ? 1 : 2
            guard [3, 4, 6, 8].contains(digits.count),
                  let red = channel(0..<width), let green = channel(width..<width * 2), let blue = channel(width * 2..<width * 3) else {
                return nil
            }
            let alpha = digits.count == 4 || digits.count == 8 ? channel(width * 3..<width * 4) : 1
            guard let alpha else { return nil }
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
        else if let (function, arguments) = Self.cssFunction(css) {
            let values = arguments.map { Double($0.trimmingCharacters(in: CharacterSet(charactersIn: "% "))) }
            guard values.allSatisfy({ $0 != nil }) else { return nil }
            let numbers = values.map { CGFloat($0!) }
            switch (function, numbers.count) {
            case ("rgb", 3), ("rgba", 4), ("rgb", 4):
                self.init(red: numbers[0] / 255, green: numbers[1] / 255, blue: numbers[2] / 255, alpha: numbers.count == 4 ? numbers[3] : 1)
            case ("hsl", 3), ("hsla", 4), ("hsl", 4):
                let (red, green, blue) = Self.rgb(hue: numbers[0] / 360, saturation: numbers[1] / 100, lightness: numbers[2] / 100)
                self.init(red: red, green: green, blue: blue, alpha: numbers.count == 4 ? numbers[3] : 1)
            default:
                return nil
            }
        }
        else {
            return nil
        }
    }

    /// splits a CSS function, e.g. `rgb(1, 2, 3)` into its name and arguments
    private static func cssFunction(_ css: String) -> (String, [String])? {
        guard let open = css.firstIndex(of: "("), css.hasSuffix(")") else { return nil }
        let name = css[..<open].trimmingCharacters(in: .whitespaces)
        let arguments = css[css.index(after: open)..<css.index(before: css.endIndex)]
        return (name, arguments.split(separator: ",").map(String.init))
    }

    /// https://www.w3.org/TR/css-color-4/#hsl-to-rgb
    private static func rgb(hue: CGFloat, saturation: CGFloat, lightness: CGFloat) -> (CGFloat, CGFloat, CGFloat) {
        func channel(_ n: CGFloat) -> CGFloat {
            let k = (n + hue * 12).truncatingRemainder(dividingBy: 12)
            let a = saturation * Swift.min(lightness, 1 - lightness)
            return lightness - a * Swift.max(-1, Swift.min(k - 3, 9 - k, 1))
        }
        return (channel(0), channel(8), channel(4))
    }

    /// the color's red, green, blue and alpha components in sRGB, nil if it can't be converted
    var srgbComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
#if canImport(AppKit)
        guard let srgb = usingColorSpace(.sRGB) else { return nil }
#else
        let srgb = self
#endif
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
#if canImport(AppKit)
        srgb.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
#else
        guard srgb.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }
#endif
        return (red, green, blue, alpha)
    }

    /// the color's hue in degrees, saturation and lightness in percent, and alpha, as CSS's `hsl()` has them
    private var cssHSLComponents: (hue: Int, saturation: Int, lightness: Int, alpha: CGFloat)? {
        guard let (red, green, blue, alpha) = srgbComponents else { return nil }
        let maximum = Swift.max(red, green, blue), minimum = Swift.min(red, green, blue)
        let lightness = (maximum + minimum) / 2
        let delta = maximum - minimum
        var hue: CGFloat = 0, saturation: CGFloat = 0
        if delta > 0 {
            saturation = delta / (1 - abs(2 * lightness - 1))
            switch maximum {
            case red: hue = ((green - blue) / delta).truncatingRemainder(dividingBy: 6)
            case green: hue = (blue - red) / delta + 2
            default: hue = (red - green) / delta + 4
            }
            hue = (hue * 60 + 360).truncatingRemainder(dividingBy: 360)
        }
        return (Int(hue.rounded()), Int((saturation * 100).rounded()), Int((lightness * 100).rounded()), alpha)
    }

    /// e.g. `#FF8000`
    var cssHex: String? {
        guard let (red, green, blue, _) = srgbComponents else { return nil }
        return String(format: "#%02X%02X%02X", Int((red * 255).rounded()), Int((green * 255).rounded()), Int((blue * 255).rounded()))
    }

    /// e.g. `rgb(255,128,0)`
    var cssRGB: String? {
        guard let (red, green, blue, _) = srgbComponents else { return nil }
        return "rgb(\(Int((red * 255).rounded())),\(Int((green * 255).rounded())),\(Int((blue * 255).rounded())))"
    }

    /// e.g. `rgba(255,128,0,0.500)`
    var cssRGBA: String? {
        guard let (red, green, blue, alpha) = srgbComponents else { return nil }
        return "rgba(\(Int((red * 255).rounded())),\(Int((green * 255).rounded())),\(Int((blue * 255).rounded())),\(String(format: "%.3f", alpha)))"
    }

    /// e.g. `hsl(30,100%,50%)`
    var cssHSL: String? {
        guard let (hue, saturation, lightness, _) = cssHSLComponents else { return nil }
        return "hsl(\(hue),\(saturation)%,\(lightness)%)"
    }

    /// e.g. `hsla(30,100%,50%,0.500)`
    var cssHSLA: String? {
        guard let (hue, saturation, lightness, alpha) = cssHSLComponents else { return nil }
        return "hsla(\(hue),\(saturation)%,\(lightness)%,\(String(format: "%.3f", alpha)))"
    }

    /// the name of a catalog color, otherwise its CSS hex
    var colorName: String? {
#if canImport(AppKit)
        if type == .catalog {
            return localizedColorNameComponent
        }
#endif
        return cssHex
    }

    // MARK: - Related Colors

    /// the desaturated complement of the color, on the other side of the color wheel, black or white for grays
    var complementary: ILColor {
        if isEqual(ILColor.white) || isEqual(ILColor.lightGray) {
            return .black
        }
        if isEqual(ILColor.black) || isEqual(ILColor.gray) {
            return .white
        }
        let (hue, saturation, brightness, alpha) = hsbComponents
        return ILColor(hue: hue > 0.5 ? hue - 0.5 : hue + 0.5, saturation: saturation * 0.7,
                       brightness: brightness >= 0.6 ? 0.2 : 1.0, alpha: alpha)
    }

    /// a desaturated color with the same hue, which contrasts with the color, black or white for grays
    var contrasting: ILColor {
        if isEqual(ILColor.white) || isEqual(ILColor.lightGray) {
            return .black
        }
        if isEqual(ILColor.black) || isEqual(ILColor.gray) {
            return .white
        }
        let (hue, saturation, brightness, alpha) = hsbComponents
        return ILColor(hue: hue, saturation: saturation * 0.5, brightness: brightness >= 0.6 ? 0.2 : 0.8, alpha: alpha)
    }

    private var hsbComponents: (CGFloat, CGFloat, CGFloat, CGFloat) {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
#if canImport(AppKit)
        (usingColorSpace(.sRGB) ?? self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
#else
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
#endif
        return (hue, saturation, brightness, alpha)
    }
}

#if canImport(AppKit)
public extension NSColor {
    /// the Core Image color, as UIColor has it
    var ciColor: CIColor? {
        CIColor(color: self)
    }
}
#endif

// MARK: - Semantic Colors

// The semantic colors of both AppKit and UIKit, on both, named as UIKit names its colors in Swift, without "Color",
// e.g. `ILColor.controlText` and `ILColor.systemBackground` work on the Mac, iPhone, TV and Vision Pro

#if canImport(AppKit)
public extension NSColor {
    // MARK: Label Colors
    static var label: NSColor { .labelColor }
    static var secondaryLabel: NSColor { .secondaryLabelColor }
    static var tertiaryLabel: NSColor { .tertiaryLabelColor }
    static var quaternaryLabel: NSColor { .quaternaryLabelColor }
    static var placeholderText: NSColor { .placeholderTextColor }

    // MARK: Text Colors
    static var text: NSColor { .textColor }
    static var textBackground: NSColor { .textBackgroundColor }
    static var textInsertionPoint: NSColor { .textInsertionPointColor }
    static var selectedText: NSColor { .selectedTextColor }
    static var selectedTextBackground: NSColor { .selectedTextBackgroundColor }
    static var keyboardFocusIndicator: NSColor { .keyboardFocusIndicatorColor }
    static var unemphasizedSelectedText: NSColor { .unemphasizedSelectedTextColor }
    static var unemphasizedSelectedTextBackground: NSColor { .unemphasizedSelectedTextBackgroundColor }

    // MARK: Content Colors
    static var link: NSColor { .linkColor }
    static var separator: NSColor { .separatorColor }
    static var opaqueSeparator: NSColor { NSColor.separatorColor.withAlphaComponent(1) }
    static var selectedContentBackground: NSColor { .selectedContentBackgroundColor }
    static var unemphasizedSelectedContentBackground: NSColor { .unemphasizedSelectedContentBackgroundColor }
    static var selectedMenuItemText: NSColor { .selectedMenuItemTextColor }
    static var grid: NSColor { .gridColor }
    static var headerText: NSColor { .headerTextColor }
    static var alternatingContentBackgrounds: [NSColor] { alternatingContentBackgroundColors }

    // MARK: Control Colors
    static var tintColor: NSColor { .controlAccentColor }
    static var controlAccent: NSColor { .controlAccentColor }
    static var control: NSColor { .controlColor }
    static var controlBackground: NSColor { .controlBackgroundColor }
    static var controlText: NSColor { .controlTextColor }
    static var disabledControlText: NSColor { .disabledControlTextColor }
    static var selectedControl: NSColor { .selectedControlColor }
    static var selectedControlText: NSColor { .selectedControlTextColor }
    static var alternateSelectedControlText: NSColor { .alternateSelectedControlTextColor }

    // MARK: Window Colors
    static var windowBackground: NSColor { .windowBackgroundColor }
    static var windowFrameText: NSColor { .windowFrameTextColor }
    static var underPageBackground: NSColor { .underPageBackgroundColor }

    // MARK: Highlights and Shadows
    static var findHighlight: NSColor { .findHighlightColor }
    static var highlight: NSColor { .highlightColor }
    static var shadow: NSColor { .shadowColor }

    // MARK: Background Colors
    static var systemBackground: NSColor { .systemFill }
    static var secondarySystemBackground: NSColor { .secondarySystemFill }
    static var tertiarySystemBackground: NSColor { .tertiarySystemFill }
    static var systemGroupedBackground: NSColor { .systemFill }
    static var secondarySystemGroupedBackground: NSColor { .secondarySystemFill }
    static var tertiarySystemGroupedBackground: NSColor { .tertiarySystemFill }

    // MARK: Fixed Colors
    static var darkText: NSColor { .black }
    static var lightText: NSColor { .lightGray }
    static var systemGray2: NSColor { NSColor(white: 0.45, alpha: 1) }
    static var systemGray3: NSColor { NSColor(white: 0.40, alpha: 1) }
    static var systemGray4: NSColor { NSColor(white: 0.35, alpha: 1) }
    static var systemGray5: NSColor { NSColor(white: 0.30, alpha: 1) }
    static var systemGray6: NSColor { NSColor(white: 0.25, alpha: 1) }
}
#else
public extension UIColor {
    // MARK: Text Colors
    static var text: UIColor { .label } // follows the appearance, like AppKit's, white in dark mode and on the TV
#if os(tvOS)
    static var textBackground: UIColor { .clear } // tvOS draws its own backgrounds
#elseif os(watchOS)
    static var textBackground: UIColor { .black } // the watch is always dark
#else
    static var textBackground: UIColor { .systemBackground }
#endif
    static var textInsertionPoint: UIColor { .text }
    static var selectedText: UIColor { UIColor(css: "rgba(0, 0, 0, 1.000)")! }
    static var selectedTextBackground: UIColor { UIColor(css: "rgba(250, 201, 159, 1.000)")! }
    static var keyboardFocusIndicator: UIColor { UIColor(css: "rgba(228, 90, 8, 0.498)")! }
    static var unemphasizedSelectedText: UIColor { UIColor(css: "rgba(0, 0, 0, 1.000)")! }
    static var unemphasizedSelectedTextBackground: UIColor { UIColor(css: "rgba(211, 211, 211, 1.000)")! }

    // MARK: Content Colors
    static var selectedContentBackground: UIColor { UIColor(css: "rgba(193, 58, 4, 1.000)")! }
    static var unemphasizedSelectedContentBackground: UIColor { UIColor(css: "rgba(211, 211, 211, 1.000)")! }
    static var selectedMenuItemText: UIColor { UIColor(css: "rgba(255, 254, 254, 1.000)")! }
    static var grid: UIColor { UIColor(css: "rgba(0, 0, 0, 0.098)")! }
    static var headerText: UIColor { UIColor(css: "rgba(0, 0, 0, 0.847)")! }
    static var alternatingContentBackgrounds: [UIColor] { [.controlBackground, UIColor(css: "rgba(241, 242, 242, 1.000)")!] }

    // MARK: Control Colors
    static var controlAccent: UIColor { UIColor(css: "rgba(242, 108, 22, 1.000)")! }
    static var control: UIColor { UIColor(css: "rgba(255, 254, 254, 1.000)")! }
    static var controlBackground: UIColor { UIColor(css: "rgba(255, 254, 254, 1.000)")! }
    static var controlText: UIColor { UIColor(css: "rgba(0, 0, 0, 0.847)")! }
    static var disabledControlText: UIColor { UIColor(css: "rgba(0, 0, 0, 0.247)")! }
    static var selectedControl: UIColor { UIColor(css: "rgba(250, 201, 159, 1.000)")! }
    static var selectedControlText: UIColor { UIColor(css: "rgba(0, 0, 0, 0.847)")! }
    static var alternateSelectedControlText: UIColor { UIColor(css: "#666")! }
    static var scrubberTexturedBackground: UIColor { UIColor(css: "#666")! }

    // MARK: Window Colors
    static var windowBackground: UIColor { UIColor(css: "rgba(231, 231, 231, 1.000)")! }
    static var windowFrameText: UIColor { UIColor(css: "rgba(0, 0, 0, 0.847)")! }
    static var underPageBackground: UIColor { UIColor(css: "rgba(131, 131, 131, 0.898)")! }

    // MARK: Highlights and Shadows
    static var findHighlight: UIColor { UIColor(css: "rgba(255, 255, 10, 1.000)")! }
    static var highlight: UIColor { UIColor(css: "rgba(255, 254, 254, 1.000)")! }
    static var shadow: UIColor { UIColor(css: "rgba(0, 0, 0, 1.000)")! }
}
#endif

#if os(watchOS)
/// The semantic and system colors of iOS's UIColor which the watch's lacks, with their dark appearance values: the watch is always dark
public extension UIColor {
    // MARK: Label Colors
    static var label: UIColor { UIColor(red: 1, green: 1, blue: 1, alpha: 1) }
    static var secondaryLabel: UIColor { UIColor(red: 235 / 255, green: 235 / 255, blue: 245 / 255, alpha: 0.6) }
    static var tertiaryLabel: UIColor { UIColor(red: 235 / 255, green: 235 / 255, blue: 245 / 255, alpha: 0.3) }
    static var quaternaryLabel: UIColor { UIColor(red: 235 / 255, green: 235 / 255, blue: 245 / 255, alpha: 0.18) }
    static var placeholderText: UIColor { UIColor(red: 235 / 255, green: 235 / 255, blue: 245 / 255, alpha: 0.3) }

    // MARK: Link, Separator and Tint Colors
    static var link: UIColor { UIColor(red: 9 / 255, green: 132 / 255, blue: 1, alpha: 1) }
    static var separator: UIColor { UIColor(red: 84 / 255, green: 84 / 255, blue: 88 / 255, alpha: 0.6) }
    static var opaqueSeparator: UIColor { UIColor(red: 56 / 255, green: 56 / 255, blue: 58 / 255, alpha: 1) }
    static var tintColor: UIColor { .systemBlue }

    // MARK: System Colors
    static var systemRed: UIColor { UIColor(red: 1, green: 69 / 255, blue: 58 / 255, alpha: 1) }
    static var systemOrange: UIColor { UIColor(red: 1, green: 159 / 255, blue: 10 / 255, alpha: 1) }
    static var systemYellow: UIColor { UIColor(red: 1, green: 214 / 255, blue: 10 / 255, alpha: 1) }
    static var systemGreen: UIColor { UIColor(red: 48 / 255, green: 209 / 255, blue: 88 / 255, alpha: 1) }
    static var systemMint: UIColor { UIColor(red: 99 / 255, green: 230 / 255, blue: 226 / 255, alpha: 1) }
    static var systemTeal: UIColor { UIColor(red: 64 / 255, green: 200 / 255, blue: 224 / 255, alpha: 1) }
    static var systemCyan: UIColor { UIColor(red: 100 / 255, green: 210 / 255, blue: 1, alpha: 1) }
    static var systemBlue: UIColor { UIColor(red: 10 / 255, green: 132 / 255, blue: 1, alpha: 1) }
    static var systemIndigo: UIColor { UIColor(red: 94 / 255, green: 92 / 255, blue: 230 / 255, alpha: 1) }
    static var systemPurple: UIColor { UIColor(red: 191 / 255, green: 90 / 255, blue: 242 / 255, alpha: 1) }
    static var systemPink: UIColor { UIColor(red: 1, green: 55 / 255, blue: 95 / 255, alpha: 1) }
    static var systemBrown: UIColor { UIColor(red: 172 / 255, green: 142 / 255, blue: 104 / 255, alpha: 1) }
    static var systemGray: UIColor { UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 1) }
}
#endif
