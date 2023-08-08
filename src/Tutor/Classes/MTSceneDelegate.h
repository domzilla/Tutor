//
//  MTSceneDelegate.h
//  Tutor
//
//  Created by Dominic Rodemer on 03.08.23.
//

#import <UIKit/UIKit.h>

#import "MTRootWindowController.h"

@interface MTSceneDelegate : UIResponder <UIWindowSceneDelegate>
{
    MTRootWindowController *rootWindowController;
}

@property (nonatomic, strong, readonly) MTRootWindowController *rootWindowController;


@end
