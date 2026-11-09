import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif
#if canImport(CoreImage)
import CoreImage
#endif

/// Images which render themselves at new sizes, e.g. from a PDF, rather than scaling their pixels
public protocol ImageResizing {
    /// @returns the image rendered at the
    /// @param size and
    /// @param scale provided
    func resized(to size: CGSize, scale: CGFloat) -> ILImage?
}

// MARK: -

#if canImport(AppKit)
public extension NSImage {
    /// the image of a CGImage, at its pixel size
    convenience init(cgImage: CGImage) {
        self.init(cgImage: cgImage, size: CGSize(width: cgImage.width, height: cgImage.height))
    }

    /// the system symbol image named, as UIImage has it
    convenience init?(systemName name: String) {
        self.init(systemSymbolName: name, accessibilityDescription: name)
    }

    /// the image as a CGImage, as UIImage has it
    var cgImage: CGImage? {
        var rect = CGRect(origin: .zero, size: size)
        return cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }

    /// the image tinted with the
    /// @param color provided, as UIImage has it
    func withTintColor(_ color: NSColor) -> NSImage {
        let source = self.copy() as! NSImage
        source.isTemplate = false
        return NSImage(size: size, flipped: false) { bounds in
            source.draw(in: bounds)
            color.setFill()
            bounds.fill(using: .sourceAtop)
            return true
        }
    }
}
#endif

public extension ILImage {
    /// the image named in the
    /// @param bundle provided
    static func named(_ name: String, in bundle: Bundle) -> ILImage? {
#if canImport(AppKit)
        bundle.image(forResource: name)
#elseif os(watchOS)
        UIImage(named: name, in: bundle, with: nil)
#else
        UIImage(named: name, in: bundle, compatibleWith: nil)
#endif
    }

    /// the image with its colors inverted, or nil if it can't be
    func inverted() -> ILImage? {
#if canImport(CoreImage) && !os(watchOS)
        guard let cgImage, let filter = CIFilter(name: "CIColorInvert") else { return nil }
        filter.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
        guard let output = filter.outputImage, let rendered = CIContext().createCGImage(output, from: output.extent) else { return nil }
        return Self.image(rendered, like: self)
#else
        return nil
#endif
    }

    /// the image cropped to the
    /// @param bounds provided, in points
    func cropped(to bounds: CGRect) -> ILImage? {
        let scale = pixelScale
        let pixels = CGRect(x: bounds.minX * scale, y: bounds.minY * scale, width: bounds.width * scale, height: bounds.height * scale)
        guard let cropped = cgImage?.cropping(to: pixels) else { return nil }
        return Self.image(cropped, like: self)
    }

    /// the image scaled to the
    /// @param size provided, in points, with the
    /// @param quality of interpolation provided, PDF images are rendered at the size
    func resized(to size: CGSize, quality: CGInterpolationQuality = .high) -> ILImage? {
        if let resizing = self as? ImageResizing {
            return resizing.resized(to: size, scale: ILScreen.mainScale)
        }
        guard let cgImage else { return nil }
        let scale = Swift.max(1, pixelScale)
        let pixels = CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale).integral
        guard pixels.width > 0, pixels.height > 0,
              let context = CGContext(data: nil, width: Int(pixels.width), height: Int(pixels.height), bitsPerComponent: 8, bytesPerRow: 0,
                                      space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil
        }
        var drawn = pixels
#if !canImport(AppKit)
        context.concatenate(orientationTransform(for: pixels.size))
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            drawn = CGRect(x: 0, y: 0, width: pixels.height, height: pixels.width) // drawn transposed
        default:
            break
        }
#endif
        context.interpolationQuality = quality
        context.draw(cgImage, in: drawn)
        guard let resized = context.makeImage() else { return nil }
#if canImport(AppKit)
        return NSImage(cgImage: resized, size: size)
#else
        return UIImage(cgImage: resized, scale: scale, orientation: .up)
#endif
    }

    /// the image scaled by the
    /// @param scale provided
    func resized(scale: CGFloat) -> ILImage? {
        resized(to: CGSize(width: size.width * scale, height: size.height * scale))
    }

    /// the image scaled to the
    /// @param width provided, keeping its aspect ratio
    func resized(toWidth width: CGFloat) -> ILImage? {
        guard size.width > 0 else { return nil }
        return resized(scale: width / size.width)
    }

    /// does the image have the same size and pixels as the
    /// @param other image provided?
    func hasSamePixels(as other: ILImage) -> Bool {
        guard size == other.size,
              let data = cgImage?.dataProvider?.data, let otherData = other.cgImage?.dataProvider?.data else { return false }
        return (data as Data) == (otherData as Data)
    }

    /// write the image to the file
    /// @param url provided as a PNG, with or without an
    /// @param alpha channel
    /// @throws if the image can't be written
    func writePNG(to url: URL, alpha: Bool = true) throws {
        guard let cgImage else { throw CocoaError(.fileWriteUnknown) }
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else {
            throw CocoaError(.fileWriteUnknown, userInfo: [NSURLErrorKey: url])
        }
        CGImageDestinationAddImage(destination, cgImage, [kCGImagePropertyHasAlpha: alpha] as CFDictionary)
        guard CGImageDestinationFinalize(destination) else {
            throw CocoaError(.fileWriteUnknown, userInfo: [NSURLErrorKey: url])
        }
    }

    // MARK: -

    /// the scale of the image's pixels to its points
    private var pixelScale: CGFloat {
#if canImport(AppKit)
        guard let cgImage, size.width > 0 else { return 1 }
        return CGFloat(cgImage.width) / size.width
#else
        scale
#endif
    }

    /// an image of the CGImage provided, with the scale of the
    /// @param image provided
    private static func image(_ cgImage: CGImage, like image: ILImage) -> ILImage {
#if canImport(AppKit)
        let scale = image.pixelScale
        return NSImage(cgImage: cgImage, size: CGSize(width: CGFloat(cgImage.width) / scale, height: CGFloat(cgImage.height) / scale))
#else
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
#endif
    }

#if !canImport(AppKit)
    /// the transform which draws the image upright, at the
    /// @param size provided, in pixels
    private func orientationTransform(for size: CGSize) -> CGAffineTransform {
        var transform = CGAffineTransform.identity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height).rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0).rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height).rotated(by: -.pi / 2)
        default:
            break
        }
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0).scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0).scaledBy(x: -1, y: 1)
        default:
            break
        }
        return transform
    }
#endif
}

// MARK: - PDF Images

#if os(iOS) || os(visionOS)
/// A UIImage of the first page of a PDF, which renders the PDF again when it is resized
public final class ILPDFImage: UIImage, ImageResizing, @unchecked Sendable {
    private var document: CGPDFDocument?

    /// the first page of the PDF in the
    /// @param data provided, rendered at the
    /// @param scale provided
    public convenience init?(pdfData data: Data, scale: CGFloat = ILScreen.mainScale) {
        guard let provider = CGDataProvider(data: data as CFData), let document = CGPDFDocument(provider) else { return nil }
        self.init(pdfDocument: document, scale: scale)
    }

    /// the first page of the PDF file at the
    /// @param url provided, rendered at the
    /// @param scale provided
    public convenience init?(pdfURL url: URL, scale: CGFloat = ILScreen.mainScale) {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        self.init(pdfDocument: document, scale: scale)
    }

    private convenience init?(pdfDocument document: CGPDFDocument, scale: CGFloat) {
        guard let page = document.page(at: 1),
              let rendered = Self.render(document, size: page.getBoxRect(.cropBox).size, scale: scale, preserveAspectRatio: true) else {
            return nil
        }
        self.init(cgImage: rendered, scale: scale, orientation: .up)
        self.document = document
    }

    public func resized(to size: CGSize, scale: CGFloat) -> ILImage? {
        guard let document, let rendered = Self.render(document, size: size, scale: scale, preserveAspectRatio: true) else { return nil }
        return UIImage(cgImage: rendered, scale: scale, orientation: .up)
    }

    /// @returns the first page of the
    /// @param document rendered at the
    /// @param size and
    /// @param scale provided
    private static func render(_ document: CGPDFDocument, size: CGSize, scale: CGFloat, preserveAspectRatio: Bool) -> CGImage? {
        guard size.width > 0, size.height > 0, let page = document.page(at: 1) else { return nil }
        let bounds = CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale)
        guard let context = CGContext(data: nil, width: Int(bounds.width), height: Int(bounds.height), bitsPerComponent: 8, bytesPerRow: 0,
                                      space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else {
            return nil
        }
        let pageBounds = page.getBoxRect(.cropBox)
        if pageBounds.width < bounds.width { // scale it up
            context.scaleBy(x: bounds.width / pageBounds.width, y: bounds.height / pageBounds.height)
        }
        else { // scale it down
            context.concatenate(page.getDrawingTransform(.cropBox, rect: bounds, rotate: 0, preserveAspectRatio: preserveAspectRatio))
        }
        context.drawPDFPage(page)
        return context.makeImage()
    }
}
#endif

// MARK: - Bundles

#if !canImport(AppKit)
public extension Bundle {
    /// the image resource named, as AppKit has it, rendering PDFs with ILPDFImage
    func image(forResource name: String) -> UIImage? {
#if os(iOS) || os(visionOS)
        if (name as NSString).pathExtension == "pdf" {
            guard let url = url(forResource: (name as NSString).deletingPathExtension, withExtension: "pdf") else { return nil }
            return ILPDFImage(pdfURL: url)
        }
#endif
        return ILImage.named(name, in: self)
    }
}
#endif
