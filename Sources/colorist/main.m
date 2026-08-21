#import <Foundation/Foundation.h>

@import KitBridge;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        for (ILColor* color in @[
            // Adaptable colors
            ILColor.systemBlueColor,
            ILColor.systemBrownColor,
            ILColor.systemCyanColor,
            ILColor.systemGreenColor,
            ILColor.systemIndigoColor,
            ILColor.systemMintColor,
            ILColor.systemOrangeColor,
            ILColor.systemPinkColor,
            ILColor.systemPurpleColor,
            ILColor.systemRedColor,
            ILColor.systemTealColor,
            ILColor.systemYellowColor,
            
            // Adaptable gray colors
            ILColor.systemGrayColor,
            ILColor.systemGray2Color,
            ILColor.systemGray3Color,
            ILColor.systemGray4Color,
            ILColor.systemGray5Color,
            ILColor.systemGray6Color,
        
            // Transparent Color
            ILColor.clearColor,        /* 0.0 white, 0.0 alpha */

            // Fixed Colors
            ILColor.blackColor,        /* 0.0 white */
            ILColor.blueColor,         /* 0.0, 0.0, 1.0 RGB */
            ILColor.brownColor,        /* 0.6, 0.4, 0.2 RGB */
            ILColor.cyanColor,         /* 0.0, 1.0, 1.0 RGB */
            ILColor.darkGrayColor,     /* 0.333 white */
            ILColor.grayColor,         /* 0.5 white */
            ILColor.greenColor,        /* 0.0, 1.0, 0.0 RGB */
            ILColor.lightGrayColor,    /* 0.667 white */
            ILColor.magentaColor,      /* 1.0, 0.0, 1.0 RGB */
            ILColor.orangeColor,       /* 1.0, 0.5, 0.0 RGB */
            ILColor.purpleColor,       /* 0.5, 0.0, 0.5 RGB */
            ILColor.redColor,          /* 1.0, 0.0, 0.0 RGB */
            ILColor.whiteColor,        /* 1.0 white */
            ILColor.yellowColor,       /* 1.0, 1.0, 0.0 RGB */
    
            // Label colors
            ILColor.labelColor,
            ILColor.secondaryLabelColor,
            ILColor.tertiaryLabelColor,
            ILColor.quaternaryLabelColor,

            // Text Colors
            ILColor.textColor,
            ILColor.placeholderTextColor,
            ILColor.selectedTextColor,
            ILColor.textBackgroundColor,
            ILColor.selectedTextBackgroundColor,
            ILColor.keyboardFocusIndicatorColor,
            ILColor.unemphasizedSelectedTextColor,
            ILColor.unemphasizedSelectedTextBackgroundColor,
//          ILColor.textInsertionPointColor,

            // Content Colors
            ILColor.linkColor,
            ILColor.separatorColor,
            ILColor.selectedContentBackgroundColor,
            ILColor.unemphasizedSelectedContentBackgroundColor,

            // Menu Colors
            ILColor.selectedMenuItemTextColor,

            // Table Colors
            ILColor.gridColor,
            ILColor.headerTextColor,
            ILColor.alternatingContentBackgroundColors[0],
            ILColor.alternatingContentBackgroundColors[1],

            // Control Colors
            ILColor.controlAccentColor,
            ILColor.controlColor,
            ILColor.controlTextColor,
            ILColor.controlBackgroundColor,
            ILColor.disabledControlTextColor,
            ILColor.selectedControlColor,
            ILColor.selectedControlTextColor,
            ILColor.alternateSelectedControlTextColor,
            // ILColor.scrubberTexturedBackgroundColor, // this is nil in tests
            
            // Window Colors
            ILColor.windowBackgroundColor,
            ILColor.windowFrameTextColor,
            ILColor.underPageBackgroundColor,

            // MARK: - Highlights and Shadows
            ILColor.findHighlightColor,
            ILColor.highlightColor,
            ILColor.shadowColor
        ]) {
            NSLog(@"%@  %-28@ %-28@ %@", color.hexColor, color.rgbaColor, color.hslaColor, color.colorName);
        }

        // colorWithCSSColor tests
        NSLog(@"---------- CSS Color Tests ----------");
        for (NSString* cssColor in @[
            @"#F14",
            @"#FB194C",
            @"rgb(128, 60, 14)",
            @"rgb(128,60,14)",
            @"rgba(128, 60, 14, 0.666)",
            @"hsl(358, 44%, 98%)",
            @"hsla(123, 80%, 90%, 0.666)"
        ]) {
            NSLog(@"%@ - %@", [ILColor colorWithCSSColor:cssColor], cssColor);
        }
    }
    
    return 0;
}
