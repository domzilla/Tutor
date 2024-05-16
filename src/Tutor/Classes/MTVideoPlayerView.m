//
//  MTVideoPlayerView.m
//  Tutor
//
//  Created by Dominic Rodemer on 15.05.24.
//

#import "MTVideoPlayerView.h"

#import <AVFoundation/AVFoundation.h>

@interface MTVideoPlayerView ()

@property (nonatomic, strong) AVPlayer *player;

- (void)updateSize;

@end


@implementation MTVideoPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = NO;
        self.layer.opacity = 0.3;
        videoSize = CGSizeZero;
        
        scale = 1.0;
    }
    
    return self;
}



#pragma mark Accessors
#pragma mark ---
- (NSURL *)videoURL
{
    return videoURL;
}

- (void)setVideoURL:(NSURL *)aVideoURL
{
    [videoURL stopAccessingSecurityScopedResource];
    videoURL = aVideoURL;
    [videoURL startAccessingSecurityScopedResource];
    
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:aVideoURL options:nil];
    [urlAsset loadTracksWithMediaType:AVMediaTypeVideo completionHandler:^(NSArray<AVAssetTrack *> *tracks, NSError *error) {
        AVAssetTrack *track = [tracks firstObject];
        if (track)
        {
            self->videoSize = CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform);
            [self updateSize];
        }
    }];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    [(AVPlayerLayer*)self.layer setPlayer:self.player];
}

- (CGFloat)scale
{
    return scale;
}

- (void)setScale:(CGFloat)aScale
{
    scale = aScale;
    [self updateSize];
}



#pragma mark Public
#pragma mark ---
- (void)play
{
    if (self.player.status == AVPlayerItemStatusReadyToPlay)
        [self.player play];
}

- (void)pause
{
    [self.player pause];
}

- (void)stop
{
    [self.player pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(0.0, NSEC_PER_SEC)];
}

- (BOOL)isPlaying
{
    return (self.player.rate == 1.0);
}



#pragma mark Private
#pragma mark ---
- (void)updateSize
{
    CGSize size = self.maximumViewSize;
    if (!CGSizeEqualToSize(videoSize, CGSizeZero))
    {
        size.height = size.width/videoSize.width * videoSize.height;
        if (size.height > self.maximumViewSize.height)
        {
            CGFloat downScale = self.maximumViewSize.height/size.height;
            size.width *= downScale;
            size.height *= downScale;
        }
    }
    
    size.width *= scale;
    size.height *= scale;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    });
}

@end
