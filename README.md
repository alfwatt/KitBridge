<a id="kitbridge"></a>
# KitBridge

KitBridge: Bringing UIKit and AppKit Closer Together

<p style="font-size: 0.8em; color:dark-gray;">From <a href="https://istumbler.net/labs/">iStumbler Labs</a>.</p>

<a id="contents"></a>
## Contents

- <a href="#goals">Goals</a>
- <a href="#support">Support</a>
- <a href="#classes">Classes</a>
- <a href="#functions">Functions</a>
- <a href="#protocols">Protocols</a>
- <a href="#categories">Categories</a>
- <a href="#swift">Swift</a>
- <a href="#mcmv">Model Controller Multiple Views</a>
- <a href="#todo">To Do Items</a>
- <a href="#versions">Version History</a>
- <a href="#license">MIT License</a>


<a id="goals"></a>
## Goals

KitBridge allows you to create views which can be used in both iOS and macOS applications.

<img src="Images/kit-bridge-orangecard.png" alt="OrangeCard on macOS, tvOS and iOS">

KitBridge supports <a href="https://gitlab.com/alfwatt/cardview">CardView</a> 
<a href="https://github.com/alfwatt/CardView">[Github]</a>, 
<a href="https://gitlab.com/alfwatt/SparkKit">SparkKit</a> 
<a href="https://github.com/alfwatt/SparkKit">[Github]</a>,
which offer a nice looking text view subclass, and a simple fast graphing toolkit as well as
other iStumbler Labs frameworks.

<img src="Images/kit-bridge-stack.png" alt="Stack Diagram Showing CardView and SparkKit on the top layer">

Overall the goal of KitBridge is to provide *just enough* support to make writing apps which target
multiple platforms and UI modes easier, but without trying to emulate the iOS/tvOS app runtime on
macOS or vice versa.

Apps will have a single set of source files and one plist for each platform they want to target, along with 
storyboards, xibs, xcassets and other platform specific resources. 

<a id="support"></a>
## Support KitBridge!

Are you using KitBridge in your apps? Would you like to help support the project and get a sponsor credit?

Visit our [Patreon Page](https://www.patreon.com/istumblerlabs) and patronize us in exchange for great rewards!

<a id="classes"></a>
## Bridged Classes

Bridged classes are `#define` directives which allow you to write a kit class name, e.g.: `ILColor`
and when your app is complied, the appropriate `NS` or `UI` class from the `AppKit` or `UIKit` will
be substituted at compile time with no performance penalty.

    #define ILApplication UIApplication / NSApplication
    #define ILApplicationDelegate UIApplicationDelegate / NSApplicationDelegate
    #define ILBezierPath UIBezierPath / NSBezierPath
    #define ILButton UIButton / NSButton
    #define ILColor UIColor / NSColor
    #define ILFont UIFont / NSFont
    #define ILGradient NSObject / NSGradient
    #define ILImage UIImage / NSImage
    #define ILLabel UILabel / NSTextView
    #define ILPasteboard UIPasteboard / NSPasteboard
    #define ILProgressView UIActivityIndicatorView / NSProgressIndicator
    #define ILResponder UIResponder / NSResponder
    #define ILScreen UIScreen / NSScreen
    #define ILTextView UITextView / NSTextView
    #define ILTextField UITextField / NSTextField
    #define ILView UIView / NSView
    #define ILWindow UIWindow / NSWindow

The `#defines`  `IL_UI_KIT` and `IL_APP_KIT` can be used to segregate implementations when
needed, e.g. ILApplicationDelegates might use them to initialize the app for each platform in their 
`main(...)` function:

    #include <KitBridge/KitBridge.h>

    int main(int argc, char* _Nonnull argv[]) {
    #if IL_APP_KIT
        return NSApplicationMain(argc, (const char* _Nonnull*) argv);
    #elif IL_UI_KIT
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([SparkyDelegate class]));
        }
    #endif
    }


<a id="functions"></a>
## Bridged Functions

A number of geometry and printing functions are included for conveniences, see 
<a href="./Sources/KitBridge/KitBridgeFunctions.h">`KitBridgeFunctions.h`</a> for details.


<a id="protocols"></a>
## Protocols

### ILViews

The <a href="./Sources/KitBridge/ILViews.h">`ILViews`</a> protocol defines the `-initView` and `-updateView` methods for ILView subclasses.


<a id="categories"></a>
## Categories

Categories are defined on AppKit classes to provide adaption to various UIKit methods.

Applications can then use the UIKit interface throughout, with only a small performance
penalty on macOS for the bridge code.

- <a id="ILApplication+KitBridge" href="./Sources/KitBridge/ILApplication+KitBridge.h">`ILApplication+KitBridge`</a>
    - Adds `openURL:` method
- <a id="ILBezierPath+KitBridge" href="./Sources/KitBridge/ILBezierPath+KitBridge.h">`ILBezierPath+KitBridge`</a>
    - Adds Path Description and Count functions and methods
    - Adds `enumeratePathWithBlock:` method
- <a id="ILButton+KitBridge" href="./Sources/KitBridge/ILButton+KitBridge.h">`ILButton+KitBridge`</a>
- <a id="ILColor+KitBridge" href="./Sources/KitBridge/ILColor+KitBridge.h">`ILColor+KitBridge`</a>
    - Adds CSS color string properties
    - Adds complementary and contrasting color properties
    - Adds CIColor property to AppKit
    - Adds semantic colors from AppKit to UIKit
- <a id="ILFont+KitBridge" href="./Sources/KitBridge/ILFont+KitBridge.h">`ILFont+KitBridge`</a>
    - Adds `-applicationFontFace:` along with `info.plist` keys to define font faces for your application
    - Adds `-replaceSystemFonts` on `ILView` which replaces standard system fonts with the application font faces
- <a id="ILImage+KitBridge" href="./Sources/KitBridge/ILImage+KitBridge.h">`ILImage+KitBridge`</a>
- <a id="ILProgressView+KitBridge" href="./Sources/KitBridge/ILProgressView+KitBridge.h">`ILProgressView+KitBridge`</a>
- <a id="ILScreen+KitBridge" href="./Sources/KitBridge/ILScreen+KitBridge.h">`ILScreen+KitBridge`</a>
- <a id="ILTextView+KitBridge" href="./Sources/KitBridge/ILTextView+KitBridge.h">`ILTextView+KitBridge`</a>
- <a id="NSBundle+KitBridge" href="./Sources/KitBridge/NSBundle+KitBridge.h">`NSBundle+KitBridge`</a>


<a id="swift"></a>
## Swift Support

For applications that use Swift `KitBridgeAliases.swift` is provided along with a generated `module.map` 
files in the Swift enabled products.

Swift applications can't see the `#defines` used to bridge classes for Objective-C code, so Swift `typealias` directives 
are used to allow the usage of the various `IL` type names. 

Swift annotations like `@UIApplicationMain` and `@NSApplicationMain` can't be aliases so you'll need to include a
`main.swift` file for the project:

    import Foundation
    import KitBridge

    #if os(macOS)
    NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    #elseif os(iOS)
    let argv = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
    UIApplicationMain(CommandLine.argc, argv, nil, "SwiftSettingsDelegate")
    #endif

### Swift Controller Views

To implement IL/NS/UIViewController 

    #if os(iOS)
    import UIKit
    #elseif os(macOS)
    import AppKit
    #endif
    import KitBridgeSwiftf

    class ExampleView: ILViewController {
    }

<a id="mcmv"></a>
## Model Controller Multiple Views (MCMV)

Porting either an existing iOS or macOS app using KitBridge will be easier or harder depending
on how well the original code complies to the Model View Controller (MVC) design pattern.

In an MVC app with clean separation adding support for a new platform means adapting the
existing controller to the UI Idiom in use by creating Multiple Views, hence MCMV. This requires 
more code and UI design time than an emulation environment but allows for customization of the
model to each UI idiom as closely as possible.

Here is the outline of an example project using KitBridge:

    - Example.xcodeproj
        - ExampleDelegate.h
        - ExampleDelegate.m
        - ExampleViewController.h
        - ExampleViewController.m
        - Resources
            - Localizable.strings
        - macOS
            - Info.plist
            - MainMenu.xib
            - ExampleView.xib
            - Example.xcassets
        - iOS
            - Info.plist
            - ExampleView.xib
            - Main.storyboard
            - LaunchScreen.storyboard
            - Example.xcassets
        - tvOS
            - Info.plist
            - ExampleView.xib
            - Main.storyboard
            - LaunchScreen.storyboards
            - Example.xcassets

Bridging `NSViewController`/`UIViewController` is desirable but unfortunately Xcode will not recognize the
subclasses in the Interface Builder due to indexing issues. Instead the `ExampleController.h` needs to define the controller
inside of `#if` blocks:

    #import <KitBridge/KitBridge.h>

    #if IL_APP_KIT
    @interface ExampleController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
    @property(nonatomic,retain) IBOutlet NSTableView* tableView;
    #endif
    /* Note the separate #if blocks, #elif confuses the Xcode indexer
       You may also have to swap the order of the blocks at design time, when setting up the xibs */
    #if IL_UI_KIT
    @interface ExampleController : UIViewController <UITableViewDataSource, UITableViewDelegate>
    @property(nonatomic,retain) IBOutlet UITableView* tableView;
    #endif
    
    . . .
    
    @end

In the implementation file the various protocols are defined inside of `#if` blocks for each platform
(alternately, you could also have separate `.m` files for each platform, or even use a base class with
platform specific subclasses):

    #import "ExampleController.h"

    @implementation ExampleController
    
    #if IL_APP_KIT
    // MARK: - NSViewController Overrides . . .
    // MARK: - NSTableViewDataSource . . .
    // MARK: - NSTableViewDelegate . . .
    #elif IL_UI_KIT
    // MARK: - UIViewController Overrides . . .
    // MARK: - UITableViewDataSource . . .
    // MARK: - UITableViewDelegate . . .    
    #endif
    
    @end

<a id="gotchas"></a>
## Gotchas

In no specific order these are things to keep an eye out for as you write and deploy your app.

- KitBridge will support apps which go at least as far back as macOS 10.10
    - xcasset catalogs are not well supported on macOS 10.10 and 10.11

<a id="todo"></a>
## To Do Items

- open source example app (besides the CardView and SparkKit)
- Implement ILGradient on top of CGGradient on UIKit
- ILSparkMeterTextStyle on ILSparkStack needs to offset values in the view
- colorist: Add command line options to parse and convert colors

<a id="versions"></a>
## Version History

-  22 May 2017 — Initial Release
- `KitBridge-1.0`: 19 January 2018 — 
- `KitBridge-1.1`: 17 August 2018 —  
- `KitBridge-1.2`: June 2022 - Add Swift Package Manager Support
    - `1.2.1` : Fix Packaging
- `KitBridge-1.3`: January 2023 - Modernize Build Settings with minimum 10.14 targets for most platforms
    - Removed ILWebView and WebKit dependency
    - Added IL/UI/NSStoryboard
    - Added IL/UI/NSCollectionView/Item/Delegate
    - Added ILCGPath to ILBezierPath


<a id="license"></a>
## License

    The MIT License (MIT)

    Copyright © 2017-2024 Alf Watt <alf@istumbler.net>

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
