//
//  MTButton.m
//  Tutor
//
//  Created by Dominic Rodemer on 03.08.23.
//

#import "MTButton.h"

#import "UIColor+Tutor.h"

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
    [button setBackgroundImage:[MTButton imageWithColor:color] forState:UIControlStateNormal];
    [button setBackgroundImage:[MTButton imageWithColor:[color colorWithAlphaComponent:0.3]] forState:UIControlStateHighlighted];
    
    return button;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.on = NO; //Sert initial border color (tintColor)
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.layer.borderColor = selected || !self.enabled ? [[self.tintColor colorWithAlphaComponent:0.3] CGColor] : [self.tintColor CGColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.layer.borderColor = highlighted || !self.enabled ? [[self.tintColor colorWithAlphaComponent:0.3] CGColor] : [self.tintColor CGColor];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    self.layer.borderColor = !enabled ? [[self.tintColor colorWithAlphaComponent:0.3] CGColor] : [self.tintColor CGColor];
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


#pragma mark Public
#pragma mark ---
+ (CGSize)buttonSize
{
    return CGSizeMake(44.0, 44.0);
}

@end
