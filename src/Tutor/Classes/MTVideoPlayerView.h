//
//  MTVideoPlayerView.h
//  Tutor
//
//  Created by Dominic Rodemer on 15.05.24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTVideoPlayerView : UIView
{
    NSURL *videoURL;
    CGSize videoSize;
    CGFloat scale;
}

@property (nonatomic) CGSize maximumViewSize;
@property (nonatomic) CGFloat scale;

@property (nonatomic, strong) NSURL *videoURL;

- (void)play;
- (void)pause;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
