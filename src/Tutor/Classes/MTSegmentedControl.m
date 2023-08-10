//
//  MTSegmentedControl.m
//  Tutor
//
//  Created by Dominic Rodemer on 10.08.23.
//

#import "MTSegmentedControl.h"

@interface MTSegmentedControl ()

- (void)updateBorderColor;

@end

@implementation MTSegmentedControl

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    
    [self updateBorderColor];
}



#pragma mark Private
#pragma mark ---
- (void)updateBorderColor
{
    self.layer.borderColor = [self.tintColor CGColor];
}

@end
