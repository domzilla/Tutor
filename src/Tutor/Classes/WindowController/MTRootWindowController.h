//
//  MTRootWindowController.h
//  Tutor
//
//  Created by Dominic Rodemer on 08.08.23.
//

#import <UIKit/UIKit.h>

@class MTTutorViewController;

@interface MTRootWindowController : UIResponder
{
    UIWindow *window;
    
    MTTutorViewController *tutorViewController;
}

@property (nonatomic, strong, readonly) UIWindow *window;

- (id)initWithWindowScene:(UIWindowScene *)windowScene;

@end
