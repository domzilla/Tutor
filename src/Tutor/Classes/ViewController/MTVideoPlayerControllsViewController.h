//
//  MTVideoPlayerControllsViewController.h
//  Tutor
//
//  Created by Dominic Rodemer on 15.05.24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MTButton;
@class MTVideoPlayerView;

@interface MTVideoPlayerControllsViewController : UIViewController <UIDocumentBrowserViewControllerDelegate>
{
    MTButton *loadButton;
    MTButton *playButton;
    MTButton *pauseButton;
    MTButton *stopButton;
    
    MTButton *upButton;
    MTButton *downButton;
    MTButton *leftButton;
    MTButton *rightButton;
    
    UISlider *opacitySlider;
    UISlider *scaleSlider;
}

@property (nonatomic, strong, readonly) MTVideoPlayerView *videoPlayerView;

- (id)initWithVideoPlayerView:(MTVideoPlayerView *)videoPlayerView;

@end

NS_ASSUME_NONNULL_END
