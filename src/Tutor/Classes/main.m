//
//  main.m
//  Tutor
//
//  Created by Dominic Rodemer on 03.08.23.
//

#import <UIKit/UIKit.h>
#import "MTAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        appDelegateClassName = NSStringFromClass([MTAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
