//
//  UIColor+Tutor.m
//  Tutor
//
//  Created by Dominic Rodemer on 08.08.23.
//

#import "UIColor+Tutor.h"

@implementation UIColor (Tutor)

+ (UIColor *)mt_tintColor
{
    return [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ? [UIColor blackColor] : [UIColor whiteColor];
    }];
}

+ (UIColor *)mt_toolbarColor
{
    return [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ? [UIColor whiteColor] : [UIColor blackColor];
    }];
}

+ (UIColor *)mt_secondaryBackgroundColor
{
    return [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ? [UIColor colorWithWhite:0.3 alpha:1.0] : [UIColor colorWithWhite:0.8 alpha:1.0];
    }];
}

+ (UIColor *)mt_canvasBackgroundColor
{
    return [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ? [UIColor blackColor] : [UIColor whiteColor];
    }];
}

+ (UIColor *)mt_primaryColor
{
    return [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ? [UIColor whiteColor] : [UIColor blackColor];
    }];
}

+ (UIColor *)mt_darkPrimaryColor
{
    return [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ? [UIColor blackColor] : [UIColor whiteColor];
    }];
}

+ (UIColor *)mt_redColor
{
    return [UIColor colorWithRed:233.0/255 green:54.0/255 blue:100.0/255 alpha:1.0];
}

+ (UIColor *)mt_greenColor
{
    return [UIColor colorWithRed:54.0/255 green:233.0/255 blue:138.0/255 alpha:1.0];
}

+ (UIColor *)mt_blueColor
{
    return [UIColor colorWithRed:0.0/255 green:108.0/255 blue:255.0/255 alpha:1.0];
}

+ (UIColor *)mt_yellowColor
{
    return [UIColor colorWithRed:255.0/255 green:240.0/255 blue:2.0/255 alpha:1.0];
}

@end
