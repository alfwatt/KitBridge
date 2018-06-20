#import <Foundation/Foundation.h>
#import <KitBridge/KitBridge.h>

int main(int argc, const char * argv[])
{
    // NSColor* color;
    // UIColor* color;
    
    @autoreleasepool {
        for (ILColor* color in @[
            [ILColor blackColor],        /* 0.0 white */
            [ILColor darkGrayColor],     /* 0.333 white */
            [ILColor lightGrayColor],    /* 0.667 white */
            [ILColor whiteColor],        /* 1.0 white */
            [ILColor grayColor],         /* 0.5 white */
            [ILColor redColor],          /* 1.0, 0.0, 0.0 RGB */
            [ILColor greenColor],        /* 0.0, 1.0, 0.0 RGB */
            [ILColor blueColor],         /* 0.0, 0.0, 1.0 RGB */
            [ILColor cyanColor],         /* 0.0, 1.0, 1.0 RGB */
            [ILColor yellowColor],       /* 1.0, 1.0, 0.0 RGB */
            [ILColor magentaColor],      /* 1.0, 0.0, 1.0 RGB */
            [ILColor orangeColor],       /* 1.0, 0.5, 0.0 RGB */
            [ILColor purpleColor],       /* 0.5, 0.0, 0.5 RGB */
            [ILColor brownColor],        /* 0.6, 0.4, 0.2 RGB */
            [ILColor clearColor],        /* 0.0 white, 0.0 alpha */
    
            /* Foreground Colors */
            [ILColor labelColor],
            [ILColor secondaryLabelColor],
            [ILColor tertiaryLabelColor],
            [ILColor quaternaryLabelColor],
            [ILColor linkColor],
            [ILColor placeholderTextColor],
            [ILColor windowFrameTextColor],
            [ILColor selectedMenuItemTextColor],
            [ILColor alternateSelectedControlTextColor],
            [ILColor headerTextColor],
            [ILColor separatorColor],
            [ILColor gridColor],

            /* Background Colors */
            [ILColor windowBackgroundColor],
            [ILColor underPageBackgroundColor],
            [ILColor controlBackgroundColor],
            [ILColor selectedContentBackgroundColor],
            [ILColor unemphasizedSelectedContentBackgroundColor],
            [ILColor findHighlightColor],
            [ILColor alternatingContentBackgroundColors][1],

            /* Text Colors */
            [ILColor textColor],
            [ILColor textBackgroundColor],
            [ILColor selectedTextColor],
            [ILColor selectedTextBackgroundColor],
            [ILColor unemphasizedSelectedTextBackgroundColor],
            [ILColor unemphasizedSelectedTextColor],

            /* Control Colors */
            [ILColor controlColor],
            [ILColor controlTextColor],
            [ILColor selectedControlColor],
            [ILColor selectedControlTextColor],
            [ILColor disabledControlTextColor],
            [ILColor keyboardFocusIndicatorColor],
            [ILColor controlAccentColor],
            [ILColor highlightColor],
            [ILColor shadowColor],

            /* System Colors */
            [ILColor systemRedColor],
            [ILColor systemGreenColor],
            [ILColor systemBlueColor],
            [ILColor systemOrangeColor],
            [ILColor systemYellowColor],
            [ILColor systemBrownColor],
            [ILColor systemPinkColor],
            [ILColor systemPurpleColor],
            [ILColor systemGrayColor]
        ]) {
            NSLog(@"%@  %-28@ %-28@ %@", color.hexColor, color.rgbaColor, color.hslaColor, color.colorName);
        }
        
        NSLog(@"# %@", [ILColor colorWithCSSColor:@"#F14"]);
        NSLog(@"## %@", [ILColor colorWithCSSColor:@"#FB194C"]);
        NSLog(@"rgb %@", [ILColor colorWithCSSColor:@"rgb(128, 60, 14)"]);
        NSLog(@"rgb %@", [ILColor colorWithCSSColor:@"rgb(128,60,14)"]);
        NSLog(@"rgba %@", [ILColor colorWithCSSColor:@"rgba(128, 60, 14, 0.666)"]);
        NSLog(@"hsl %@", [ILColor colorWithCSSColor:@"hsl(358, 44%, 98%)"]);
        NSLog(@"hsla %@", [ILColor colorWithCSSColor:@"hsla(123, 80%, 90%, 0.666)"]);
    }
    
    return 0;
}
