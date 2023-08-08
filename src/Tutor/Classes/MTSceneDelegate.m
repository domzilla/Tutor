//
//  MTSceneDelegate.m
//  Tutor
//
//  Created by Dominic Rodemer on 03.08.23.
//

#import "MTSceneDelegate.h"

@interface MTSceneDelegate ()

@end

@implementation MTSceneDelegate

@synthesize rootWindowController;

#pragma mark UIWindowSceneDelegate
#pragma mark ---
- (UIWindow *)window
{
    return rootWindowController.window;
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
{
    rootWindowController = [[MTRootWindowController alloc] initWithWindowScene:(UIWindowScene *)scene];
    [rootWindowController.window makeKeyAndVisible];
}

- (void)sceneDidDisconnect:(UIScene *)scene
{

}

- (void)sceneDidBecomeActive:(UIScene *)scene
{

}

- (void)sceneWillResignActive:(UIScene *)scene
{

}

- (void)sceneWillEnterForeground:(UIScene *)scene
{

}

- (void)sceneDidEnterBackground:(UIScene *)scene
{

}

@end
