import Foundation
#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

/// The keys of the application's font faces in its Info.plist, which replace the system's fonts
public enum ApplicationFontFace: String, CaseIterable, Sendable {
    /// replaces bold system fonts
    case bold = "ILFontBoldFace"
    /// replaces thin and light system fonts, and those with names ending in "-Light"
    case light = "ILFontLightFace"
    /// replaces fixed width system fonts
    case fixed = "ILFontFixedFace"
    /// replaces sans-serif system fonts
    case regular = "ILFontRegularFace"
    /// replaces serif system fonts
    case serif = "ILFontSerifFace"
}

public extension ILFont {
    /// the key of the application's font size in its Info.plist and the user's defaults
    static let applicationFontSizeKey = "ILFontSize"

    /// the application's font for the
    /// @param face provided, at the application's font size, or nil if it hasn't got one
    static func applicationFont(_ face: ApplicationFontFace) -> ILFont? {
        guard let name = Bundle.main.object(forInfoDictionaryKey: face.rawValue) as? String else { return nil }
        return ILFont(name: name, size: applicationFontSize)
    }

    /// the application's font face which replaces the
    /// @param systemFont provided, or the system font if the application hasn't got one
    static func applicationFont(replacing systemFont: ILFont) -> ILFont {
        let descriptor = systemFont.fontDescriptor
#if canImport(AppKit)
        let traits = descriptor.symbolicTraits
        let isBold = traits.contains(.bold)
        let isMonospace = traits.contains(.monoSpace)
        let fontClass = traits.rawValue & NSFontDescriptor.SymbolicTraits.classMask.rawValue
        let isSansSerif = fontClass == NSFontDescriptor.SymbolicTraits.classSansSerif.rawValue
        let isSerif = fontClass == NSFontDescriptor.SymbolicTraits.classModernSerifs.rawValue
        let weight = (descriptor.object(forKey: .traits) as? [NSFontDescriptor.TraitKey: Any])?[.weight] as? CGFloat
#else
        let traits = descriptor.symbolicTraits
        let isBold = traits.contains(.traitBold)
        let isMonospace = traits.contains(.traitMonoSpace)
        let fontClass = traits.rawValue & UIFontDescriptor.SymbolicTraits.classMask.rawValue
        let isSansSerif = fontClass == UIFontDescriptor.SymbolicTraits.classSansSerif.rawValue
        let isSerif = fontClass == UIFontDescriptor.SymbolicTraits.classModernSerifs.rawValue
        let weight = (descriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any])?[.weight] as? CGFloat
#endif
        let isLight = systemFont.fontName.contains("-Light") || weight == ILFont.Weight.thin.rawValue || weight == ILFont.Weight.light.rawValue
        let face: ApplicationFontFace? = isBold ? .bold : isLight ? .light : isMonospace ? .fixed : isSansSerif ? .regular : isSerif ? .serif : nil
        guard let face, let name = Bundle.main.object(forInfoDictionaryKey: face.rawValue) as? String,
              let replacement = ILFont(name: name, size: systemFont.pointSize) else {
            return systemFont
        }
        return replacement
    }

    /// the size of the application's text: the user's default, or the application's Info.plist, or the system's
    /// font size, which is the body text's size on the watch, which hasn't got one, and 36 points on the TV
    static var applicationFontSize: CGFloat {
        if let size = UserDefaults.standard.object(forKey: applicationFontSizeKey) as? NSNumber {
            return CGFloat(size.doubleValue)
        }
        if let size = Bundle.main.object(forInfoDictionaryKey: applicationFontSizeKey) as? NSNumber {
            return CGFloat(size.doubleValue)
        }
#if os(tvOS)
        return 36
#elseif os(watchOS)
        return ILFont.preferredFont(forTextStyle: .body).pointSize
#else
        return ILFont.systemFontSize
#endif
    }

#if !canImport(AppKit)
    /// the user's fixed pitch font, as AppKit has it, the monospaced system font
    static func userFixedPitchFont(ofSize fontSize: CGFloat) -> UIFont? {
        .monospacedSystemFont(ofSize: fontSize, weight: .regular)
    }
#endif
}
