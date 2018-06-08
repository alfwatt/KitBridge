
# KitBridge

KitBridge: Bringing UIKit and AppKit Closer Together

<small>From <a href="https://istumbler.net/labs/">iStumbler Labs</a></small>

## Goals

KitBridge allows you to create views which can be used in both iOS and macOS applications.

<img src="./kit-bridge-orangecard.png" alt="OrangeCard on macOS, tvOS and iOS">

KitBridge supports <a href="https://gitlab.com/alfwatt/cardview">CardView</a> <a href="https://github.com/alfwatt/CardView">[Github]</a>
and <a href="https://gitlab.com/alfwatt/SparkKit">SparkKit</a> <a href="https://github.com/alfwatt/SparkKit">[Github]</a>,
which offer a nice looking text view subclass, and a simple fast graphing toolkit.

<img src="./kit-bridge-stack.png" alt="Stack Diagram Showing CardView and SparkKit on the top layer">

Overall the goal of KitBridge is to provide *just enough* support to make writing apps which target
multiple platforms and UI modes easier, but withouth trying to emulate the iOS/tvOS app runtime on
macOS or vice versa.

Apps will have a single set of source files and one plist for each platform they want to target, along with 
storboards, xibs, xcassets and other platform specific resources. 


## Bridged Classes

Bridged classes are `#define` directives which allow you to write a kit class name, e.g.: `ILColor`
and when your app is complied, the appropriate `NS` or `UI` class from the `AppKit` or `UIKit` will
be substituted at compile time with no performance penalty.

    - ILApplicationDelegate
    - ILBezierPath
    - ILColor
    - ILFont
    - ILGradient
    - ILImage
    - ILViewController
    - ILWindow

The `#defines`  `IL_UI_KIT` and `IL_APP_KIT` can be used to segregate implementations when
needed, e.g. ILApplicationDelegates might use them to initialize the app for each platform in their 
`main(...)` function:

    #include <KitBridge/KitBridge.h>

    int main(int argc, char* _Nonnull argv[]) {
    #ifdef IL_APP_KIT
        return NSApplicationMain(argc, (const char* _Nonnull*) argv);
    #elif IL_UI_KIT
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([SparkyDelegate class]));
        }
    #endif
    }


## Bridged Functions

A number of geometry and printing functions are included for conveniences, see `KitBridgeFunctions.h` for details.


## ILViews Interface

The ILViews interfaces defines the `initView` and `updateView` methods or ILView subclasses.


## Categories

Categories are defined on AppKit classes to provide adaption to various UIKit methods.

Applications can then use the UIKit interface throughout, with only a small performance
penalty on macOS for the bridge code.


## TODO Items

- semantic colors from AppKit for ILColor on UIKit
- cocoapods & c. package definitions
- swift bridging header
- open source example app (besides the CardView and SparkKit)
- Implement ILGradient on top of CGGradient on UIKit
- ILSparkMeterTextStyle on ILSparkStack needs to offset values in the view

## License

    The MIT License (MIT)

    Copyright (c) 2017-2018 Alf Watt

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
