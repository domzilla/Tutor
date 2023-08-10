//
//  MTButton.h
//  Tutor
//
//  Created by Dominic Rodemer on 03.08.23.
//

#import <UIKit/UIKit.h>

@interface MTButton : UIButton
{
    BOOL on;
    UIColor *color;
}

@property (nonatomic, assign, getter=isOn) BOOL on;

@property (nonatomic, strong, readonly) UIColor *color;

+ (MTButton *)buttonWithImage:(UIImage *)image;
+ (MTButton *)buttonWithColor:(UIColor *)color;

+ (CGSize)buttonSize;

@end
