//
//  MTInkingTool.m
//  Tutor
//
//  Created by Dominic Rodemer on 09.08.23.
//

#import "MTInkingTool.h"

@interface MTInkingTool ()

@property (nonatomic, assign) NSInteger identifier;

@end

@implementation MTInkingTool

@synthesize identifier;

- (id)initWithInkType:(PKInkType)type color:(UIColor *)color width:(CGFloat)width identifier:(NSInteger)identifier
{
    if (self = [super initWithInkType:type color:color width:width])
    {
        self.identifier = identifier;
    }
    
    return self;
}

@end
