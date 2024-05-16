//
//  MTVideoPlayerControllsViewController.m
//  Tutor
//
//  Created by Dominic Rodemer on 15.05.24.
//

#import "MTVideoPlayerControllsViewController.h"

#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

#import "UIColor+Tutor.h"
#import "MTButton.h"
#import "MTVideoPlayerView.h"

@interface MTVideoPlayerControllsViewController ()

@property (nonatomic, strong) MTVideoPlayerView *videoPlayerView;

@end

@implementation MTVideoPlayerControllsViewController

- (id)initWithVideoPlayerView:(MTVideoPlayerView *)videoPlayerView
{
    if (self  = [super initWithNibName:nil bundle:nil])
    {
        self.videoPlayerView = videoPlayerView;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor mt_toolbarColor];
    
    UIImageSymbolConfiguration *symbolConfiguration = [UIImageSymbolConfiguration configurationWithPointSize:20 weight:UIImageSymbolWeightRegular scale:UIImageSymbolScaleMedium];
    
    loadButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"folder"
                                                   withConfiguration:symbolConfiguration]];
    [loadButton addTarget:self
                   action:@selector(loadButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadButton];
    
    playButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"play.fill"
                                                   withConfiguration:symbolConfiguration]];
    [playButton addTarget:self
                   action:@selector(playButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    pauseButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"pause.fill"
                                                   withConfiguration:symbolConfiguration]];
    [pauseButton addTarget:self
                   action:@selector(pauseButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseButton];
    
    stopButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"stop.fill"
                                                   withConfiguration:symbolConfiguration]];
    [stopButton addTarget:self
                   action:@selector(stopButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    
    upButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"arrowshape.up.circle"
                                                   withConfiguration:symbolConfiguration]];
    [upButton addTarget:self
                   action:@selector(upButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upButton];
    
    downButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"arrowshape.down.circle"
                                                   withConfiguration:symbolConfiguration]];
    [downButton addTarget:self
                   action:@selector(downButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downButton];
    
    leftButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"arrowshape.left.circle"
                                                   withConfiguration:symbolConfiguration]];
    [leftButton addTarget:self
                   action:@selector(leftButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    rightButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"arrowshape.right.circle"
                                                   withConfiguration:symbolConfiguration]];
    [rightButton addTarget:self
                   action:@selector(rightButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    opacitySlider = [[UISlider alloc] initWithFrame:CGRectZero];
    opacitySlider.minimumValue = 0.0;
    opacitySlider.maximumValue = 1.0;
    opacitySlider.value = self.videoPlayerView.layer.opacity;
    [opacitySlider addTarget:self action:@selector(opacitySliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:opacitySlider];
    
    scaleSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    scaleSlider.minimumValue = 0.8;
    scaleSlider.maximumValue = 1.2;
    scaleSlider.value = 1.0;
    [scaleSlider addTarget:self action:@selector(scaleSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:scaleSlider];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat offset = 20.0;
    CGSize buttonSize = [MTButton buttonSize];
    CGPoint buttonOrigin = CGPointMake(offset, offset);
    
    loadButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + offset;
    playButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + offset;
    pauseButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + offset;
    stopButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    
    buttonOrigin.x = offset;
    buttonOrigin.y += buttonSize.height + offset;
    upButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + offset;
    downButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + offset;
    leftButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + offset;
    rightButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    
    buttonOrigin.y += buttonSize.height + offset;
    opacitySlider.frame = CGRectMake(offset, buttonOrigin.y, self.view.frame.size.width - 2*offset, 30.0);
    
    buttonOrigin.y += opacitySlider.frame.size.height + offset;
    scaleSlider.frame = CGRectMake(offset, buttonOrigin.y, self.view.frame.size.width - 2*offset, 30.0);
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(276.0, 250.0);
}



#pragma mark Actions
#pragma mark ---
- (void)loadButtonAction:(id)sender
{
    UIDocumentBrowserViewController *documentBrowserViewController = [[UIDocumentBrowserViewController alloc] initForOpeningContentTypes:@[UTTypeMPEG, UTTypeMovie]];
    documentBrowserViewController.view.tintColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ? [UIColor whiteColor] : [UIColor blackColor];
    }];
    documentBrowserViewController.allowsPickingMultipleItems = NO;
    documentBrowserViewController.delegate = self;
    
    [self presentViewController:documentBrowserViewController animated:YES completion:nil];
}

- (void)playButtonAction:(id)sender
{
    [self.videoPlayerView play];
}

- (void)pauseButtonAction:(id)sender
{
    [self.videoPlayerView pause];
}

- (void)stopButtonAction:(id)sender
{
    [self.videoPlayerView stop];
}

- (void)upButtonAction:(id)sender
{
    self.videoPlayerView.frame = CGRectMake(self.videoPlayerView.frame.origin.x,
                                            self.videoPlayerView.frame.origin.y - 10.0,
                                            self.videoPlayerView.frame.size.width,
                                            self.videoPlayerView.frame.size.height);
}

- (void)downButtonAction:(id)sender
{
    self.videoPlayerView.frame = CGRectMake(self.videoPlayerView.frame.origin.x,
                                            self.videoPlayerView.frame.origin.y + 10.0,
                                            self.videoPlayerView.frame.size.width,
                                            self.videoPlayerView.frame.size.height);
}

- (void)leftButtonAction:(id)sender
{
    self.videoPlayerView.frame = CGRectMake(self.videoPlayerView.frame.origin.x - 10.0,
                                            self.videoPlayerView.frame.origin.y,
                                            self.videoPlayerView.frame.size.width,
                                            self.videoPlayerView.frame.size.height);
}

- (void)rightButtonAction:(id)sender
{
    self.videoPlayerView.frame = CGRectMake(self.videoPlayerView.frame.origin.x + 10.0,
                                            self.videoPlayerView.frame.origin.y,
                                            self.videoPlayerView.frame.size.width,
                                            self.videoPlayerView.frame.size.height);
}

- (void)opacitySliderAction:(id)sender
{
    self.videoPlayerView.layer.opacity = opacitySlider.value;
}

- (void)scaleSliderAction:(id)sender
{
    self.videoPlayerView.scale = scaleSlider.value;
}



#pragma mark UIDocumentBrowserViewControllerDelegate
#pragma mark ---
- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *> *)documentURLs
{
    NSURL *url = [documentURLs firstObject];
    [self.videoPlayerView setVideoURL:url];
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
