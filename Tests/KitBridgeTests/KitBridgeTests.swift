import XCTest
import KitBridge
#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

final class KitBridgeTests: XCTestCase {

    // MARK: - CSS Colors

    func testCSSHexColors() throws {
        XCTAssertEqual(try XCTUnwrap(ILColor(css: "#F14")).cssHex, "#FF1144")
        XCTAssertEqual(try XCTUnwrap(ILColor(css: "#fb194c")).cssHex, "#FB194C")
        XCTAssertEqual(try XCTUnwrap(ILColor(css: "#FB194C80")).cssRGBA, "rgba(251,25,76,0.502)")
        XCTAssertNil(ILColor(css: "#12"))
        XCTAssertNil(ILColor(css: "#GGGGGG"))
    }

    func testCSSRGBColors() throws {
        XCTAssertEqual(try XCTUnwrap(ILColor(css: "rgb(128, 60, 14)")).cssRGB, "rgb(128,60,14)")
        XCTAssertEqual(try XCTUnwrap(ILColor(css: "rgba(128,60,14,0.5)")).cssRGBA, "rgba(128,60,14,0.500)")
        XCTAssertNil(ILColor(css: "rgb(1, 2)"))
        XCTAssertNil(ILColor(css: "rgb(a, b, c)"))
        XCTAssertNil(ILColor(css: "not a color"))
    }

    func testCSSHSLRoundTrip() throws {
        for css in ["hsl(0,100%,50%)", "hsl(120,100%,25%)", "hsl(240,50%,75%)", "hsl(358,44%,98%)"] {
            XCTAssertEqual(try XCTUnwrap(ILColor(css: css)).cssHSL, css)
        }
        XCTAssertEqual(try XCTUnwrap(ILColor(css: "hsl(0, 100%, 50%)")).cssHex, "#FF0000")
        XCTAssertEqual(try XCTUnwrap(ILColor(css: "hsla(123, 80%, 90%, 0.666)")).cssHSLA, "hsla(123,80%,90%,0.666)")
    }

    func testRelatedColors() {
        XCTAssertEqual(ILColor.white.complementary, .black)
        XCTAssertEqual(ILColor.black.contrasting, .white)
        XCTAssertNotNil(ILColor(css: "#3366CC")!.complementary.cssHex)
    }

    func testSemanticColorsOnEveryPlatform() {
        // the cross-platform names compile and resolve on every platform
        let colors: [ILColor] = [.label, .secondaryLabel, .text, .textBackground, .controlText, .disabledControlText,
                                 .controlAccent, .controlBackground, .windowBackground, .systemBackground, .separator,
                                 .link, .grid, .highlight, .shadow, .systemGray2, .systemGray6]
        XCTAssertEqual(colors.count, 17)
        XCTAssertEqual(ILColor.alternatingContentBackgrounds.count, 2)
    }

    // MARK: - Geometry

    func testAngles() {
        XCTAssertEqual(CGFloat.radians(fromDegrees: 180), .pi, accuracy: 1e-9)
        XCTAssertEqual(CGFloat.degrees(fromRadians: .pi / 2), 90, accuracy: 1e-9)
        XCTAssertEqual(CGFloat.radians(fromPercent: 0.25), .pi / 2, accuracy: 1e-9)
        XCTAssertEqual(CGFloat.twelveOClock, -.pi / 2, accuracy: 1e-9)
    }

    func testVectors() {
        let vector = CGVector(from: CGPoint(x: 1, y: 1), to: CGPoint(x: 4, y: 5))
        XCTAssertEqual(vector, CGVector(dx: 3, dy: 4))
        XCTAssertEqual(vector.length, 5)
        XCTAssertEqual(CGVector(dx: 0, dy: 1).radians, .pi / 2, accuracy: 1e-9)
    }

    func testPointMovedTowardPoint() {
        let moved = CGPoint(x: 0, y: 0).moved(toward: CGPoint(x: 3, y: 4), distance: 2.5)
        XCTAssertEqual(moved.x, 1.5, accuracy: 1e-9)
        XCTAssertEqual(moved.y, 2, accuracy: 1e-9)
        XCTAssertEqual(CGPoint(x: 1, y: 1).moved(toward: CGPoint(x: 1, y: 1), distance: 5), CGPoint(x: 1, y: 1))
    }

    func testRects() {
        XCTAssertEqual(CGRect(x: 10, y: 20, width: 100, height: 40).largestCenteredSquare, CGRect(x: 40, y: 20, width: 40, height: 40))
        XCTAssertEqual(CGRect(x: 0, y: 0, width: 30, height: 90).largestCenteredSquare, CGRect(x: 0, y: 30, width: 30, height: 30))
        XCTAssertEqual(CGRect(x: 0, y: 0, width: 10, height: 20).center, CGPoint(x: 5, y: 10))
        XCTAssertTrue(CGRect(x: 0, y: 0, width: 10, height: 20).isNormal)
        XCTAssertFalse(CGRect(x: CGFloat.nan, y: 0, width: 10, height: 20).isNormal)
        XCTAssertFalse(CGSize(width: 1, height: CGFloat.infinity).isNormal)
    }

    func testPaths() {
        let path = CGMutablePath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: 10, y: 10))
        path.closeSubpath()
        XCTAssertEqual(path.elementCount, 4)
        XCTAssertTrue(path.pathDescription.contains("10.0 0.0 lineto"))
        XCTAssertTrue(path.pathDescription.contains("closepath"))
    }

    // MARK: - Bezier Paths

    func testBezierPathConstruction() {
        let path = ILBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 10, y: 0))
        path.addQuadCurve(to: CGPoint(x: 10, y: 10), controlPoint: CGPoint(x: 20, y: 5))
        path.addCurve(to: CGPoint(x: 0, y: 10), controlPoint1: CGPoint(x: 5, y: 15), controlPoint2: CGPoint(x: 2, y: 12))
        path.close()
        var types: [CGPathElementType] = []
        path.forEachElement { types.append($0.type) }
        XCTAssertEqual(Array(types.prefix(5)), [.moveToPoint, .addLineToPoint, .addQuadCurveToPoint, .addCurveToPoint, .closeSubpath])
        let arc = ILBezierPath(arcCenter: .zero, radius: 10, startAngle: 0, endAngle: .pi, clockwise: true)
        XCTAssertFalse(arc.isEmpty)
    }

    // MARK: - Images

    private func image(size: CGSize, color: ILColor) -> ILImage {
#if canImport(AppKit)
        NSImage(size: size, flipped: false) { bounds in
            color.setFill()
            bounds.fill()
            return true
        }
#else
        UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
#endif
    }

    func testImageResizing() throws {
        let original = image(size: CGSize(width: 40, height: 20), color: .red)
        let resized = try XCTUnwrap(original.resized(toWidth: 10))
        XCTAssertEqual(resized.size, CGSize(width: 10, height: 5))
        XCTAssertEqual(try XCTUnwrap(original.resized(scale: 2)).size, CGSize(width: 80, height: 40))
        XCTAssertNotNil(resized.cgImage)
    }

    func testImageCropping() throws {
        let original = image(size: CGSize(width: 40, height: 20), color: .blue)
        XCTAssertEqual(try XCTUnwrap(original.cropped(to: CGRect(x: 0, y: 0, width: 10, height: 10))).size, CGSize(width: 10, height: 10))
    }

    func testImagePixelEquality() throws {
        let red = try XCTUnwrap(image(size: CGSize(width: 8, height: 8), color: .red).resized(scale: 1))
        let otherRed = try XCTUnwrap(image(size: CGSize(width: 8, height: 8), color: .red).resized(scale: 1))
        let green = try XCTUnwrap(image(size: CGSize(width: 8, height: 8), color: .green).resized(scale: 1))
        XCTAssertTrue(red.hasSamePixels(as: otherRed))
        XCTAssertFalse(red.hasSamePixels(as: green))
    }

    func testImageWritePNG() throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".png")
        defer { try? FileManager.default.removeItem(at: url) }
        try image(size: CGSize(width: 4, height: 4), color: .green).writePNG(to: url)
        XCTAssertTrue(try Data(contentsOf: url).starts(with: [0x89, 0x50, 0x4E, 0x47]))
    }

    // MARK: - Attributed Strings

    func testAttributeRanges() {
        let string = NSMutableAttributedString(string: "one two three")
        string.addAttribute(.foregroundColor, value: ILColor.red, range: NSRange(location: 0, length: 3))
        string.addAttribute(.foregroundColor, value: ILColor.blue, range: NSRange(location: 8, length: 5))
        XCTAssertEqual(string.ranges(of: .foregroundColor).count, 2)
        XCTAssertEqual(string.ranges(of: .foregroundColor, value: ILColor.red), [NSRange(location: 0, length: 3)])
        string.replaceAttribute(.foregroundColor, value: ILColor.red, with: ILColor.green)
        XCTAssertEqual(string.ranges(of: .foregroundColor, value: ILColor.green), [NSRange(location: 0, length: 3)])
        let link = NSAttributedString(string: "KitBridge", link: URL(string: "https://istumbler.net")!)
        XCTAssertNotNil(link.attribute(.link, at: 0, effectiveRange: nil))
    }

    // MARK: - Pasteboards

#if canImport(AppKit) || os(iOS)
    func testPasteboardItems() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        defer { pasteboard.clearContents() }
        XCTAssertTrue(pasteboard.isClear)
        pasteboard.items = [["public.utf8-plain-text": "first"], ["public.utf8-plain-text": "second"]]
        XCTAssertEqual(pasteboard.numberOfItems, 2)
        XCTAssertFalse(pasteboard.isClear)
        XCTAssertTrue(pasteboard.hasItems)
        XCTAssertTrue(pasteboard.hasStrings)
        XCTAssertEqual(pasteboard.strings, ["first", "second"])

        let snapshot = pasteboard.snapshot()
        XCTAssertTrue(snapshot.hasSameItems(as: pasteboard))
        pasteboard.string = "changed"
        XCTAssertFalse(snapshot.hasSameItems(as: pasteboard))
        XCTAssertEqual(snapshot.numberOfItems, 2)
    }
#endif
}
