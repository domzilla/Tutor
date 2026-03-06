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

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self registerForTraitChanges:@[UITraitUserInterfaceStyle.class]
                           withAction:@selector(traitCollectionDidChange)];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder])
    {
        [self registerForTraitChanges:@[UITraitUserInterfaceStyle.class]
                           withAction:@selector(traitCollectionDidChange)];
    }

    return self;
}



#pragma mark Private
#pragma mark ---
- (void)updateBorderColor
{
    self.layer.borderColor = [self.tintColor CGColor];
}



#pragma mark UITraitChangeObservable
#pragma mark ---
- (void)traitCollectionDidChange
{
    [self updateBorderColor];
}

@end
