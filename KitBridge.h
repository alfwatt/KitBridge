/*

    iStumbler Labs UIKit & AppKit Bridging Header

    https://istumbler.net/labs/

*/
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#ifndef ILKitBridge_h
#define ILKitBridge_h
#include <TargetConditionals.h>

/* UIKit */
#if TARGET_OS_IPHONE || TARGET_OS_TV
#import <UIKit/UIKit.h>
#define ILColor UIColor
#define ILGradient NSObject // TODO Implement ILGradient on top of CGGradient
#define ILFont UIFont
#define ILImage UIImage
#define ILView UIView
#define ILWindow UIWindow
#define ILViewController UIViewController
#define ILApplicationDelegate UIApplicationDelegate
#define IL_UI_KIT 1

/* AppKit */
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#define ILColor NSColor
#define ILGradient NSGradient
#define ILFont NSFont
#define ILImage NSImage
#define ILView NSView
#define ILWindow NSWindow
#define ILViewController NSViewController
#define ILApplicationDelegate NSApplicationDelegate
#define ILGradient NSGradient
#define IL_APP_KIT 1
#endif

#endif /* ILKitBridge_h */


#pragma mark -

/*! @brief adds common init and update methods to all views in the SparkKit */
@protocol ILViews <NSObject>

/*! @brief run from initWithFrame: or initWithCoder: to initilzize the view */
- (void) initView;

/*! @brief have the view query it's data source and redraw itself */
- (void) updateView;

@end

#pragma mark -

/*
    The MIT License (MIT)

    Copyright (c) 2016-2017 Alf Watt

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
*/
