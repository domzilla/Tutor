//
//  MTRecorder.h
//  Tutor
//
//  Created by Dominic Rodemer on 14.05.24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AVAssetWriter;
@class AVAssetWriterInput;
@class AVAssetWriterInputPixelBufferAdaptor;

@interface MTRecorder : NSObject
{
    CADisplayLink *displayLink;
    
    NSTimeInterval startTimestamp;
    NSString *videoPath;
    
    AVAssetWriter *videoWriter;
    AVAssetWriterInput *videoWriterInput;
    AVAssetWriterInputPixelBufferAdaptor *avAdaptor;
}

@property (nonatomic, strong, readonly) UIView *view;

@property (nonatomic) CGSize outputSize; //width has to be a multiple of 16!! Defaults to 1920X1080

@property (nonatomic, readonly) BOOL recording;

- (id)initWithView:(UIView *)view;

- (void)start;
- (void)stopWithCompletionHandler:(void (^)(void))handler;

@end

NS_ASSUME_NONNULL_END
