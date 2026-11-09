import Foundation
#if canImport(AppKit)
import AppKit
#elseif os(iOS) || os(visionOS)
import UIKit
#endif
import UniformTypeIdentifiers

#if canImport(AppKit)
/// UIPasteboard's API on NSPasteboard, with items as dictionaries of type identifiers and values
public extension NSPasteboard {
    /// the pasteboard with the
    /// @param name provided, created if it doesn't exist and
    /// @param create is true
    static func named(_ name: NSPasteboard.Name, create: Bool) -> NSPasteboard? {
        NSPasteboard(name: name) // AppKit always creates it
    }

    /// clear and release the pasteboard with the
    /// @param name provided
    static func remove(withName name: NSPasteboard.Name) {
        let pasteboard = NSPasteboard(name: name)
        pasteboard.clearContents()
        pasteboard.releaseGlobally()
    }

    // MARK: Types

    /// the type identifiers of all the items on the pasteboard
    var typeIdentifiers: [String] {
        (types ?? []).map(\.rawValue)
    }

    /// does the pasteboard have an item which conforms to any of the
    /// @param pasteboardTypes provided?
    func contains(pasteboardTypes: [String]) -> Bool {
        let searched = pasteboardTypes.compactMap { UTType($0) }
        return typeIdentifiers.contains { identifier in
            guard let type = UTType(identifier) else { return pasteboardTypes.contains(identifier) }
            return searched.contains { type.conforms(to: $0) }
        }
    }

    // MARK: Items

    var numberOfItems: Int {
        pasteboardItems?.count ?? 0
    }

    /// the items on the pasteboard, each a dictionary of its types and their data, setting them replaces the pasteboard's contents
    var items: [[String: Any]] {
        get {
            (pasteboardItems ?? []).map { item in
                var values: [String: Any] = [:]
                for type in item.types {
                    values[type.rawValue] = item.data(forType: type)
                }
                return values
            }
        }
        set {
            clearContents()
            addItems(newValue)
        }
    }

    /// add the
    /// @param items provided to the pasteboard, each a dictionary of types and their strings, property lists or data
    func addItems(_ items: [[String: Any]]) {
        let pasteboardItems = items.map { values in
            let item = NSPasteboardItem()
            for (identifier, value) in values {
                let type = NSPasteboard.PasteboardType(identifier)
                switch value {
                case let string as String: item.setString(string, forType: type)
                case let data as Data: item.setData(data, forType: type)
                case let url as URL: item.setString(url.absoluteString, forType: type)
                default: item.setPropertyList(value, forType: type)
                }
            }
            return item
        }
        writeObjects(pasteboardItems)
    }

    func setItems(_ items: [[String: Any]]) {
        self.items = items
    }

    func data(forPasteboardType type: String) -> Data? {
        data(forType: NSPasteboard.PasteboardType(type))
    }

    func setData(_ data: Data, forPasteboardType type: String) {
        setData(data, forType: NSPasteboard.PasteboardType(type))
    }

    /// the string, property list or data of the
    /// @param type provided
    func value(forPasteboardType type: String) -> Any? {
        let type = NSPasteboard.PasteboardType(type)
        return string(forType: type) ?? propertyList(forType: type) ?? data(forType: type)
    }

    /// set the
    /// @param value provided, a string, URL, data or property list, for the
    /// @param type provided
    func setValue(_ value: Any, forPasteboardType type: String) {
        let type = NSPasteboard.PasteboardType(type)
        switch value {
        case let string as String: setString(string, forType: type)
        case let data as Data: setData(data, forType: type)
        case let url as URL: writeObjects([url as NSURL])
        default: setPropertyList(value, forType: type)
        }
    }

    // MARK: Standard Types

    var string: String? {
        get { string(forType: .string) ?? strings?.first }
        set {
            clearContents()
            if let newValue { setString(newValue, forType: .string) }
        }
    }

    var strings: [String]? {
        get { readObjects(forClasses: [NSString.self]) as? [String] }
        set {
            clearContents()
            if let newValue { writeObjects(newValue.map { $0 as NSString }) }
        }
    }

    var image: NSImage? {
        get { images?.first }
        set {
            clearContents()
            if let newValue { writeObjects([newValue]) }
        }
    }

    var images: [NSImage]? {
        get { readObjects(forClasses: [NSImage.self]) as? [NSImage] }
        set {
            clearContents()
            if let newValue { writeObjects(newValue) }
        }
    }

    var url: URL? {
        get { urls?.first }
        set {
            clearContents()
            if let newValue { writeObjects([newValue as NSURL]) }
        }
    }

    var urls: [URL]? {
        get { readObjects(forClasses: [NSURL.self]) as? [URL] }
        set {
            clearContents()
            if let newValue { writeObjects(newValue.map { $0 as NSURL }) }
        }
    }

    var color: NSColor? {
        get { colors?.first }
        set {
            clearContents()
            if let newValue { writeObjects([newValue]) }
        }
    }

    var colors: [NSColor]? {
        get { readObjects(forClasses: [NSColor.self]) as? [NSColor] }
        set {
            clearContents()
            if let newValue { writeObjects(newValue) }
        }
    }

    var hasStrings: Bool { canReadObject(forClasses: [NSString.self]) }
    var hasImages: Bool { canReadObject(forClasses: [NSImage.self]) }
    var hasURLs: Bool { canReadObject(forClasses: [NSURL.self]) }
    var hasColors: Bool { canReadObject(forClasses: [NSColor.self]) }
}
#elseif os(iOS) || os(visionOS)
public extension UIPasteboard {
    /// remove all the items, as NSPasteboard does
    func clearContents() {
        items = []
    }

    /// the type identifiers of all the items on the pasteboard, as NSPasteboard has them
    var typeIdentifiers: [String] {
        types
    }
}
#endif

#if canImport(AppKit) || os(iOS) || os(visionOS)
public extension ILPasteboard {
    /// is the pasteboard empty, newly created or cleared?
    var isClear: Bool {
        let items = items
        return items.isEmpty || (items.count == 1 && items[0].isEmpty) // one empty item is clear on iOS
    }

    /// has the pasteboard got any items with types other than the system's dynamic "dyn." types?
    var hasItems: Bool {
        items.contains { item in item.keys.contains { !$0.hasPrefix("dyn.") } }
    }

    /// a new pasteboard with a unique name, and copies of the pasteboard's items, which last after the pasteboard is changed
    func snapshot() -> ILPasteboard {
        let snapshot = ILPasteboard.withUniqueName()
        snapshot.items = items.map { item in
            item.mapValues { value in (value as? NSCopying)?.copy(with: nil) ?? value }
        }
        return snapshot
    }

    /// has the pasteboard got the same items as the
    /// @param other pasteboard, in the same order?
    func hasSameItems(as other: ILPasteboard) -> Bool {
        if self === other {
            return true
        }
        let items = items, otherItems = other.items
        guard items.count == otherItems.count else { return false }
        return zip(items, otherItems).allSatisfy { item, otherItem in
            item.count == otherItem.count && item.allSatisfy { type, value in
                guard let otherValue = otherItem[type] else { return false }
                switch (value, otherValue) {
                case let (data as Data, otherData as Data): return data == otherData
                case let (image as ILImage, otherImage as ILImage): return image.hasSamePixels(as: otherImage)
                default: return (value as AnyObject).isEqual(otherValue)
                }
            }
        }
    }
}
#endif
