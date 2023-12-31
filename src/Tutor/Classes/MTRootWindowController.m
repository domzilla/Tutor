//
//  MTRootWindowController.m
//  Tutor
//
//  Created by Dominic Rodemer on 08.08.23.
//

#import "MTRootWindowController.h"

#import "UIColor+Tutor.h"
#import "MTTutorViewController.h"

@implementation MTRootWindowController

@synthesize window;

- (id)initWithWindowScene:(UIWindowScene *)windowScene
{
    if (self = [super init])
    {
        window = [[UIWindow alloc] initWithWindowScene:windowScene];
        window.tintColor = [UIColor mt_tintColor];
        
        tutorViewController = [[MTTutorViewController alloc] initWithNibName:nil bundle:nil];
        window.rootViewController = tutorViewController;
    }
    
    return self;
}

@end
