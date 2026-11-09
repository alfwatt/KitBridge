import Foundation
#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

public extension NSAttributedString {
    /// the
    /// @param string provided in the
    /// @param font provided, in the text color
    convenience init(string: String, font: ILFont) {
        self.init(string: string, attributes: [.font: font, .foregroundColor: ILColor.text])
    }

    /// the
    /// @param string provided as an underlined link to the
    /// @param url provided, with the
    /// @param attributes provided, or the application's font in the text color
    convenience init(string: String, link url: URL, attributes: [NSAttributedString.Key: Any]? = nil) {
        var linked = attributes ?? [.font: ILFont.systemFont(ofSize: ILFont.applicationFontSize), .foregroundColor: ILColor.text]
        linked[.link] = url
        linked[.underlineStyle] = NSUnderlineStyle.single.rawValue
        self.init(string: string, attributes: linked)
    }

    /// @returns the ranges of the string with the
    /// @param attribute provided, with the
    /// @param value provided, or any value if it is nil
    func ranges(of attribute: NSAttributedString.Key, value: Any? = nil) -> [NSRange] {
        var ranges: [NSRange] = []
        enumerateAttribute(attribute, in: NSRange(location: 0, length: length)) { found, range, _ in
            guard let found else { return }
            if value == nil || (found as AnyObject).isEqual(value) {
                ranges.append(range)
            }
        }
        return ranges
    }
}

public extension NSMutableAttributedString {
    /// replace the
    /// @param attribute provided, where it has the
    /// @param value provided, or any value if it is nil, with the
    /// @param newValue provided, or remove it if that's nil
    func replaceAttribute(_ attribute: NSAttributedString.Key, value: Any? = nil, with newValue: Any?) {
        for range in ranges(of: attribute, value: value) {
            removeAttribute(attribute, range: range)
            if let newValue {
                addAttribute(attribute, value: newValue, range: range)
            }
        }
    }
}
