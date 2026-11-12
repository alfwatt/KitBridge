# KitBridge <a id="kitbridge"></a>

KitBridge: Bringing UIKit and AppKit Closer Together, in Swift

From [iStumbler Labs](https://istumbler.net/labs/).


## Contents <a id="contents"></a>

- [Goals](#goals)
- [Support](#support)
- [Bridged Types](#types)
- [Extensions](#extensions)
- [Drawing](#drawing)
- [SwiftUI](#swiftui)
- [Model Controller Multiple Views](#mcmv)
- [Custom Fonts](#fonts)
- [To Do Items](#todo)
- [Version History](#versions)
- [MIT License](#license)


## Goals <a id="goals"></a>

KitBridge allows you to create views which can be used in both iOS and macOS applications.

<img src="Images/kit-bridge-orangecard.png" alt="OrangeCard on macOS, tvOS and iOS" style="width:420px">

KitBridge supports [CardView](https://github.com/alfwatt/CardView), 
[SparkKit](https://github.com/alfwatt/SparkKit),
which offer a nice looking text view subclass, and a simple fast graphing toolkit as well as
other iStumbler Labs frameworks.

<img src="Images/kit-bridge-stack.png" alt="Stack Diagram Showing CardView and SparkKit on the top layer" style="width:420px">

Overall the goal of KitBridge is to provide *just enough* support to make writing apps which target
multiple platforms and UI modes easier, but without trying to emulate the iOS/tvOS app runtime on
macOS or vice versa.

Apps will have a single set of source files and one plist for each platform they want to target; 
along with storyboards, xibs, xcassets, and other platform specific resources.


## Support KitBridge! <a id="support"></a>

Are you using KitBridge in your apps? Would you like to help support the project and get a sponsor credit?

Visit our [Patreon Page](https://www.patreon.com/istumblerlabs) and patronize us in exchange for great rewards!


## Bridged Types <a id="types"></a>

[`Platform.swift`](./Sources/KitBridge/Platform.swift) defines `typealias`es which let you write a kit class name,
e.g. `ILColor`, which is `NSColor` on the Mac and `UIColor` on the iPhone, iPad, TV, Vision Pro and watch.
Use `#if os(macOS)` or `#if canImport(AppKit)` to separate implementations when needed.

On the watch and visionOS, which have no `UIScreen`, `ILScreen` stands in with the scale images are drawn at,
and `ILScreen.mainScale` is the main screen's scale on every platform, from any thread.

UIKit has no gradient class, `ILGradient` is `NSGradient` on the Mac and a class with NSGradient's API, drawn with a
`CGGradient`, everywhere else.


## Extensions <a id="extensions"></a>

Extensions on AppKit's classes adapt them to UIKit's API, and the semantic colors of each are available on both,
so an app can use one spelling throughout.

- [`ILColor+KitBridge`](./Sources/KitBridge/ILColor+KitBridge.swift)
  - `ILColor(css:)` reads CSS colors: `#FFF`, `#FFFFFF`, `#FFFFFF80`, `rgb()`, `rgba()`, `hsl()` and `hsla()`
  - `cssHex`, `cssRGB`, `cssRGBA`, `cssHSL`, `cssHSLA` and `colorName` write them
  - `complementary` and `contrasting` colors, `ciColor` on AppKit
  - The semantic colors of AppKit and UIKit on both, named as UIKit names its colors in Swift, without "Color":
    `ILColor.label`, `.text`, `.textBackground`, `.controlText`, `.disabledControlText`, `.controlAccent`,
    `.windowBackground`, `.systemBackground`, `.systemGray2`…
  - The semantic and system colors UIKit lacks on the watch
- [`ILFont+KitBridge`](./Sources/KitBridge/ILFont+KitBridge.swift)
  - `ApplicationFontFace`, `ILFont.applicationFont(_:)`, `applicationFont(replacing:)` and `applicationFontSize`
  - `userFixedPitchFont(ofSize:)` on UIKit
- [`ILImage+KitBridge`](./Sources/KitBridge/ILImage+KitBridge.swift)
  - `resized(to:quality:)`, `resized(scale:)`, `resized(toWidth:)`, `cropped(to:)`, `inverted()`
  - `hasSamePixels(as:)` and `writePNG(to:alpha:)`
  - `ILImage.named(_:in:)`, and on AppKit `init(cgImage:)`, `init(systemName:)`, `cgImage` and `withTintColor(_:)`
  - `ImageResizing` and `ILPDFImage`, which renders a PDF again when it's resized, and `Bundle.image(forResource:)` on UIKit
- [`ILBezierPath+KitBridge`](./Sources/KitBridge/ILBezierPath+KitBridge.swift)
  - UIBezierPath's `init(roundedRect:cornerRadius:)`, `init(arcCenter:…)`, `addLine(to:)`, `addCurve(to:…)`,
    `addQuadCurve(to:controlPoint:)` and `addArc(withCenter:…)` on NSBezierPath, `elementCount` on UIBezierPath
  - `forEachElement(_:)`
- [`ILGradient+KitBridge`](./Sources/KitBridge/ILGradient+KitBridge.swift)
  - NSGradient's `init(starting:ending:)`, `init(colors:)`, `numberOfColorStops`, `interpolatedColor(atLocation:)`,
    `draw(in:angle:)` for rects and paths, `draw(from:to:options:)` and `draw(fromCenter:radius:toCenter:radius:options:)` on UIKit
  - `init(colors:locations:)`, `colors`, `locations` and `cgGradient` on both
- [`ILDrawing`](./Sources/KitBridge/ILDrawing.swift)
  - `ILGraphicsContext.current` and `ILGraphicsContext.drawing(in:_:)`, which makes a CGContext current for the kit's drawing
  - `ILImage.rendered(size:scale:opaque:_:)`, a bitmap drawn with its origin top left, off the main thread if you like
  - `ILDrawing`, `ILDrawingBlock`, `ILDrawingView` and `ILDrawingCell`, see [Drawing](#drawing)
- [`ILPasteboard+KitBridge`](./Sources/KitBridge/ILPasteboard+KitBridge.swift)
  - UIPasteboard's API on NSPasteboard: `items` as dictionaries, `addItems(_:)`, `string(s)`, `image(s)`, `url(s)`,
    `color(s)`, `hasStrings`… `data(forPasteboardType:)` and `value(forPasteboardType:)`
  - `isClear`, `hasItems`, `snapshot()` and `hasSameItems(as:)` on both
- [`ILView+KitBridge`](./Sources/KitBridge/ILView+KitBridge.swift)
  - `ILViewLifecycle` with `initView()` and `updateView()`
  - `renderedImage` and `replaceSystemFonts()`, `setNeedsDisplay()` on NSView
  - `text` on NSTextView and NSTextField, `attributeRuns` on UIKit's NSTextStorage
  - `open(_:)` on NSApplication, `sendAction(_:to:from:)` on UIApplication, `instantiateInitialViewController()` and
    `instantiateViewController(withIdentifier:)` on NSStoryboard, `startAnimating()` and `stopAnimating()` on
    NSProgressIndicator and `title` on UIButton
- [`NSAttributedString+KitBridge`](./Sources/KitBridge/NSAttributedString+KitBridge.swift)
  - `init(string:font:)`, `init(string:link:attributes:)`, `ranges(of:value:)` and `replaceAttribute(_:value:with:)`
- [`Geometry`](./Sources/KitBridge/Geometry.swift)
  - `CGFloat.radians(fromDegrees:)`, `.degrees(fromRadians:)`, `.radians(fromPercent:)` and `.twelveOClock`
  - `CGVector(from:to:)`, `length` and `radians`, `CGPoint.moved(toward:distance:)`
  - `CGRect.center` and `largestCenteredSquare`, `isNormal` on points, sizes and rects
  - `CGPath.elementCount` and `pathDescription`

`colorist` prints KitBridge's colors in CSS formats: `swift run colorist`


## Drawing <a id="drawing"></a>

An `ILDrawing` draws into a rect of a CGContext, with its origin top left as UIKit has it, and the context current for
`ILBezierPath`, `ILColor.set()`, `ILImage.draw` and string drawing. The same drawing goes anywhere:

| Where | How | Platforms |
| --- | --- | --- |
| A view | `ILDrawingView(drawing:)` | all but the watch |
| A row of a cell based `NSTableView` | `ILDrawingCell`, with the drawing as its `objectValue` | macOS |
| An image | `drawing.image(size:scale:opaque:)` | all |
| SwiftUI | `ILDrawingCanvas(drawing)` | all |

    struct SignalBar: ILDrawing {
        let percent: CGFloat

        func draw(in rect: CGRect, context: CGContext) {
            ILColor.controlAccent.setFill()
            ILBezierPath(roundedRect: CGRect(x: rect.minX, y: rect.minY, width: rect.width * percent, height: rect.height),
                         cornerRadius: 2).fill()
        }
    }

### Drawing in Tables

Tables draw many small views and scroll them often, so the drawing should only happen when a row's value changes:

- `ILDrawingView` is layer backed and flipped on the Mac, and draws again only when its drawing is set or it's
  resized, scrolling composites the layers it has already drawn. Set `drawsOpaque` when the drawing fills the view,
  and `drawsAsynchronously` when it has many fills or images.
- `ILDrawingCell` is the quickest way to draw many rows on the Mac: a cell based table draws every row's value with
  one cell, without a view or a layer for each row. Subclasses override `drawing` to draw their own values.
- `ILImage.rendered` doesn't need the main thread, draw rows which don't change ahead of time and show the images.
- Don't add layers in `draw(withFrame:in:)` or `draw(_:)`, they're called every time the table draws the row.


## SwiftUI <a id="swiftui"></a>

`ILViewRepresentable` is NSViewRepresentable and UIViewRepresentable with one spelling, so a SwiftUI view can host
the kit's views with the same code on every platform which has them. Swift can't infer the `ILViewType`, declare it:

    struct SparkLine: ILViewRepresentable {
        typealias ILViewType = ILSparkLine
        let data: ILSparkLineDataSource

        func makeView(context: Context) -> ILSparkLine { ILSparkLine() }
        func updateView(_ view: ILSparkLine, context: Context) { view.dataSource = data }
    }

Or make and update the view with blocks: `ILViewBridge { ILSparkLine() } update: { $0.dataSource = data }`

`Color(ilColor:)`, `Image(ilImage:)`, `Font(ilFont:)`, `Path(_: ILBezierPath)` and `ILBezierPath(_: Path)` convert
the kit's drawing types to SwiftUI's and back, SwiftUI has `ILColor(_: Color)`.


## Model Controller Multiple Views (MCMV) <a id="mcmv"></a>

Porting either an existing iOS or macOS app using KitBridge will be easier or harder depending
on how well the original code complies to the Model View Controller (MVC) design pattern.

In an MVC app with clean separation adding support for a new platform means adapting the
existing controller to the UI Idiom in use by creating Multiple Views, hence MCMV. This requires
more code and UI design time than an emulation environment but allows for customization of the
model to each UI idiom as closely as possible.

Here is the outline of an example project using KitBridge:

    - Example.xcodeproj
        - ExampleDelegate.swift
        - ExampleViewController.swift
        - Resources
            - Localizable.strings
        - macOS
            - Info.plist
            - MainMenu.xib
            - ExampleView.xib
        - iOS
            - Info.plist
            - Main.storyboard
            - LaunchScreen.storyboard
        - tvOS
            - Info.plist
            - Main.storyboard

A controller conforms to each platform's protocols in its own extension:

    import KitBridge

    class ExampleController: ILViewController {
        @IBOutlet var tableView: ILTableView!
    }

    #if os(macOS)
    extension ExampleController: NSTableViewDataSource, NSTableViewDelegate { … }
    #else
    extension ExampleController: UITableViewDataSource, UITableViewDelegate { … }
    #endif


## Custom Fonts <a id="fonts"></a>

`ILFont.applicationFont(_:)` and `ILView.replaceSystemFonts()` replace the system fonts with the fonts
defined in your app's `Info.plist`:

    <plist>
        <dict>
            <!-- the rest of your Info.plist... -->
            <key>ILFontRegularFace</key><string>Helvetica</string>
            <key>ILFontBoldFace</key><string>Helvetica-Bold</string>
            <key>ILFontLightFace</key><string>Helvetica-Light</string>
            <key>ILFontFixedFace</key><string>Monaco</string>
            <key>ILFontSerifFace</key><string>Georgia</string>
        </dict>
    </plist>

`replaceSystemFonts()` descends the view hierarchy and replaces the system fonts with the fonts in the
`Info.plist`. Set `ILFontSize` to a number in the `Info.plist`, or the user's defaults, to set the
application's font size.


## To Do Items <a id="todo"></a>

- open source example app (besides the CardView and SparkKit)
- ILSparkMeterTextStyle on ILSparkStack needs to offset values in the view
- colorist: Add command line options to parse and convert colors


## Version History <a id="versions"></a>

- `3.1.0` : Drawing and SwiftUI
  - `ILDrawing`, drawn by `ILDrawingView`, `ILDrawingCell` in Mac tables, into images, and in SwiftUI with `ILDrawingCanvas`
  - `ILGradient` on UIKit and the watch, NSGradient's API drawn with a CGGradient, it was `NSObject`
  - `ILGraphicsContext` and `ILImage.rendered(size:scale:opaque:_:)`
  - `ILViewRepresentable` and `ILViewBridge` host the kit's views in SwiftUI with one spelling
  - SwiftUI's `Color`, `Image`, `Font` and `Path` from the kit's drawing types, `ILBezierPath` from `Path`

- `3.0.0` : Breaking API changes, KitBridge is written in Swift
  - Requires macOS 14, iOS 17, tvOS 17, watchOS 10 or visionOS 26
  - Swift only: the Objective-C `#define`s, `IL_APP_KIT` and `IL_UI_KIT` are gone, Objective-C apps can use KitBridge 2.x
  - `KitBridgeSwift` is merged into `KitBridge`, which no longer re-exports AppKit and UIKit, import them where you use them
  - The semantic colors of both kits on both, with one spelling: `ILColor.controlText`, `.textBackground`, `.label`…
  - CSS `hsl()` colors are hue, saturation and lightness, as CSS has them, they were hue, saturation and brightness
  - NSPasteboard's `items` writes one pasteboard item for each dictionary, `strings`, `images` and `colors` read the
    pasteboard's objects, `snapshot()` replaces `copy` and `deepCopy`
  - `largestCenteredSquare` is centered, `ILRectSquareInRect` offset the square twice the margin
  - Tests run with `swift test`

| 2.x | 3.0 |
| --- | --- |
| `ILColor.controlTextColor` (AppKit), `ILColor.controlText` (UIKit) | `ILColor.controlText` everywhere |
| `+colorWithCSSColor:` | `ILColor(css:)` |
| `hexColor`, `rgbColor`, `rgbaColor`, `hslColor`, `hslaColor` | `cssHex`, `cssRGB`, `cssRGBA`, `cssHSL`, `cssHSLA` |
| `complementaryColor`, `contrastingColor`, `CIColor` | `complementary`, `contrasting`, `ciColor` |
| `+applicationFontFace:`, `+applicationFontForSystemFont:` | `ILFont.applicationFont(_:)`, `applicationFont(replacing:)` |
| `+defaultFontSize`, `+applicationFontSize` | `ILFont.applicationFontSize` |
| `ILFontBoldFace`… | `ApplicationFontFace.bold`… |
| `-resizedImageToWidth:`, `-resizedImageToScale:`, `-resizedImage:` | `resized(toWidth:)`, `resized(scale:)`, `resized(to:)` |
| `-croppedImage:`, `-isEqualToImage:`, `-writePNGToURL:…` | `cropped(to:)`, `hasSamePixels(as:)`, `writePNG(to:alpha:)` |
| `+imageNamed:inBundle:compatibleWithTraitCollection:` | `ILImage.named(_:in:)` |
| `ILImageResizing` | `ImageResizing` |
| `ILCGPath`, `-enumeratePathWithBlock:`, `ILCGPathElementCount()`, `ILCGPathDescription()` | `cgPath`, `forEachElement(_:)`, `CGPath.elementCount`, `pathDescription` |
| `-isEqualToPasteboard:`, `-deepCopy`, `-copy` | `hasSameItems(as:)`, `snapshot()` |
| `+attributedString:withFont:`, `+attributedString:withLink:…` | `NSAttributedString(string:font:)`, `(string:link:attributes:)` |
| `-rangesForAttribute:value:`, `-replaceAttribute:value:newValue:` | `ranges(of:value:)`, `replaceAttribute(_:value:with:)` |
| `-openURL:` on NSApplication | `open(_:)` |
| `ILZeroAngleRadians`, `ILDegreesToRadians()`, `ILRadiansToDegrees()`, `ILPercentToRadians()` | `CGFloat.twelveOClock`, `.radians(fromDegrees:)`, `.degrees(fromRadians:)`, `.radians(fromPercent:)` |
| `ILVectorFromPointToPoint()`, `ILVectorLength()`, `ILVectorRadians()` | `CGVector(from:to:)`, `length`, `radians` |
| `ILRectSquareInRect()`, `ILPointCenteredInRect()`, `ILPointOnLineToPointAtDistance()` | `largestCenteredSquare`, `center`, `moved(toward:distance:)` |
| `ILIsNormalPoint()`, `ILIsNormalSize()`, `ILIsNormalRect()` | `isNormal` |

- `2.2.0` : [29 Apr 2025]()
  - `templateTintedWithColor:` → `imageWithTintColor:` on macOS
  - Add `sendAction:to:from:` to `UIApplication`
  - Fix `-rangesForAttribute:value:` to return correct ranges for attributes with
  multiple values (e.g. `NSFontAttributeName` with multiple fonts in the same string)
  
- `2.1.1` : [28 Apr 2025]()
  - No pasteboard equality on iOS (really this time)
  - Fix `rangesForAttribute:`
  
- `2.1.0` : [20 Apr 2025]()
  - Adds `-initWIthCGImage:` to `ILImage`
  - Adds `-rangesForAttribute:value:` to `NSAttributedString`
  - Adds `-replaceAttributes:value:newValue:` to `NSAttributedString`
  - Adds `-attributeRuns` to `NSTextStorage` on iOS 
  - The Struggle for Pasteboard Equality has failed on iOS
  
- `2.0.0`
  - Remove Foundation categories to [ILFoundation](https://github.com/alfwatt/ILFoundation.git)
  
- `1.3.1`
  - Swift Package Manager Support
  
- `1.3`: [25 Jan 2023](https://github.com/alfwatt/KitBridge/releases/tag/1.3) 
  - Modernize Build Settings with minimum 10.14 targets for most platforms
  - Removed ILWebView and WebKit dependency
  - Adds IL/UI/NSStoryboard
  - Adds IL/UI/NSCollectionView/Item/Delegate
  - Adds ILCGPath to ILBezierPath
  
- KitBridge `1.2.1` : [21 Jun 2022](https://github.com/alfwatt/KitBridge/releases/tag/1.2.1) 
  - Fix Packaging

- KitBridge `1.2`: [13 Jun 2022](https://github.com/alfwatt/KitBridge/releases/tag/1.2)
  - Add Swift Package Manager Support

- KitBridge `1.1`: [17 Aug 2018](https://github.com/alfwatt/KitBridge/releases/tag/1.1)  

- KitBridge `1.0`: 19 Jan 2018 —

- KitBridge `beta`: 22 May 2017


## Using KitBridge in your App

- Clone the latest sources: `git clone https://github.com/alfwatt/KitBridge.git`
  near or inside your application's source
- Drag `KitBridge.xcodproj` into your project
- include the `KitBridge.framework` in your applications `Resources/Frameworks` directory
    - link the appropriate version of `KitBridge.framework` to all the targets which it


## Swift Package <a id="spm"></a>

A Swift Package is defined in `Package.swift` for projects using Swift Package Manager, 
you can include the following URL in your project to use it:

    https://github.com/alfwatt/KitBridge.git


## License <a id="license"></a>

    The MIT License (MIT)

    Copyright © 2017-2026 Alf Watt <alf@istumbler.net>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
