//
//  MTButton.m
//  Tutor
//
//  Created by Dominic Rodemer on 03.08.23.
//

#import "MTButton.h"

#import "UIColor+Tutor.h"

@interface MTButton ()

@property (nonatomic, strong) UIColor *color;

- (void)updateBorderColor;

@end

@implementation MTButton

+ (UIImage *)imageWithColor:(UIColor *)color
{
   CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
   UIGraphicsBeginImageContext(rect.size);
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextSetFillColorWithColor(context, [color CGColor]);
   CGContextFillRect(context, rect);
   UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();

   return image;
}

+ (MTButton *)buttonWithImage:(UIImage *)image
{
    CGSize size = [MTButton buttonSize];
    MTButton *button = [MTButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    button.layer.cornerRadius = size.width/2;
    button.layer.masksToBounds = YES;
    button.tintColor = [UIColor mt_tintColor];
    [button setImage:image forState:UIControlStateNormal];
    
    return button;
}

+ (MTButton *)buttonWithColor:(UIColor *)color
{
    CGSize size = [MTButton buttonSize];
    MTButton *button = [MTButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    button.layer.cornerRadius = size.width/2;
    button.layer.masksToBounds = YES;
    button.tintColor = [UIColor mt_tintColor];
    button.color = color;
    
    return button;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.on = NO;
    [self updateBorderColor];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    
    [self updateBorderColor];
    self.color = color;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self updateBorderColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [self updateBorderColor];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    [self updateBorderColor];
}



#pragma mark Accessors
#pragma mark ---
- (BOOL)isOn
{
    return on;
}

- (void)setOn:(BOOL)isOn
{
    on = isOn;
    
    self.layer.borderWidth = on ? 5.0 : 2.0;
}

- (UIColor *)color
{
    return color;
}

- (void)setColor:(UIColor *)aColor
{
    color = aColor;
    
    if (color)
    {
        [self setBackgroundImage:[MTButton imageWithColor:color] forState:UIControlStateNormal];
        [self setBackgroundImage:[MTButton imageWithColor:[color colorWithAlphaComponent:0.3]] forState:UIControlStateHighlighted];
    }
    else
    {
        [self setBackgroundImage:nil forState:UIControlStateNormal];
        [self setBackgroundImage:nil forState:UIControlStateHighlighted];
    }
}



#pragma mark Public
#pragma mark ---
+ (CGSize)buttonSize
{
    return CGSizeMake(44.0, 44.0);
}



#pragma mark Private
#pragma mark ---
- (void)updateBorderColor
{
    self.layer.borderColor = self.highlighted || self.selected || !self.enabled ? [[self.tintColor colorWithAlphaComponent:0.3] CGColor] : [self.tintColor CGColor];
}

@end
