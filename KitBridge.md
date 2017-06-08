
= KitBridge

KitBridge: Bringing UIKit and AppKit Closer Together


== Goals

KitBridge allows you to create views which can be used in both iOS and macOS applications.


== Bridged Classes

Bridged classes are `#define` directives which allow you to write a kit class name, e.g.: `ILColor`
and when your app is complied, the appropriate `NS` or `UI` class from the `AppKit` or `UIKit` will
be substituted.

    - ILApplicationDelegate
    - ILBezierPath
    - ILColor
    - ILFont
    - ILGradient
    - ILImage
    - ILViewController
    - ILWindow

The `IL_UI_KIT` and `IL_APP_KIT` `#defines` can be used to segregate implementations when needed,
e.g. ILApplicationDelegates might use them to initialize the app for each platform in it's 
`main(...)` function:

    int main(int argc, const char * argv[])
    {
    #ifdef IL_APP_KIT
        return NSApplicationMain(argc, argv);
    #elif IL_UI_KIT
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([MyAppDelegateDelegate class]));
        }
    #endif
    }


== Bridged Functions

A number of geometry and printing functions are included for conveniences, see `KitBridgeFunctions.h` for details.


== ILViews Interface

The ILViews interfaces defines the `initView` and `updateView` methods or ILView subclasses.


== Categories

Categories are defined on AppKit classes to provide adaption to various UIKit methods.

Applications can then use the UIKit interface throughout, with only a small performance
penalty on macOS for the bridge code.


= License

    The MIT License (MIT)

    Copyright (c) 2017 Alf Watt

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
