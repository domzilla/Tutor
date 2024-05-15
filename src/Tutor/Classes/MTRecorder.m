//
//  MTRecorder.m
//  Tutor
//
//  Created by Dominic Rodemer on 14.05.24.
//

#import "MTRecorder.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>


@interface MTRecorder ()

@property (nonatomic, strong) UIView *view;
@property (nonatomic) BOOL recording;

- (void)writeFrame:(UIImage *)frame atTime:(CMTime)time;

@end


@implementation MTRecorder

- (id)initWithView:(UIView *)view
{
    if (self = [super init])
    {
        self.view = view;
        self.outputSize = CGSizeMake(1920, 1080);
        
        NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *videoName = [NSString stringWithFormat:@"%lu.mp4", (unsigned long)[NSDate timeIntervalSinceReferenceDate]];
        videoPath = [documentsDirectoryPath stringByAppendingPathComponent:videoName];
    }
    
    return self;
}



#pragma mark Actions
#pragma mark ---
- (void)displayLinkHandler:(id)sender
{
    NSTimeInterval currentTimestamp = displayLink.timestamp;
    if (startTimestamp < 0)
        startTimestamp = currentTimestamp;
    
    NSTimeInterval time = (currentTimestamp - startTimestamp) * 1000;

    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self writeFrame:image atTime:CMTimeMake(time, 1000)];
}


#pragma mark Public
#pragma mark ---
- (void)start
{    
    NSError* error = nil;
    videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:videoPath]
                                            fileType:AVFileTypeMPEG4
                                               error:&error];
    NSParameterAssert(videoWriter);
    
    NSDictionary *compressionProperties = @{AVVideoAverageBitRateKey:@(1024.0*1024.0)};
    NSDictionary* videoSettings = @{AVVideoCodecKey: AVVideoCodecTypeH264,
                                    AVVideoWidthKey:@((NSUInteger)self.outputSize.width),
                                    AVVideoHeightKey:@((NSUInteger)self.outputSize.height),
                                    AVVideoCompressionPropertiesKey: compressionProperties};
    
    videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                          outputSettings:videoSettings];
    NSParameterAssert(videoWriterInput);
    videoWriterInput.expectsMediaDataInRealTime = YES;
    
    
    NSDictionary *bufferAttributes = @{(__bridge NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA),
                                       (__bridge NSString *)kCVPixelBufferWidthKey: @((NSUInteger)self.outputSize.width),
                                       (__bridge NSString *)kCVPixelBufferHeightKey: @((NSUInteger)self.outputSize.height)};
    avAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
                                                                                 sourcePixelBufferAttributes:bufferAttributes];
    
    [videoWriter addInput:videoWriterInput];
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:CMTimeMake(0, 1000)];

    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkHandler:)];
    displayLink.preferredFramesPerSecond = 24;
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    startTimestamp = -1.0;
    
    self.recording = YES;
}

- (void)stop
{
    [displayLink invalidate];
    displayLink = nil;
    
    self.recording = NO;
    
    [self completeRecordingSession];
}



#pragma mark Private
#pragma mark ---
- (void)writeFrame:(UIImage *)frame atTime:(CMTime)time
{
    if ([videoWriterInput isReadyForMoreMediaData])
    {
        UIGraphicsBeginImageContextWithOptions(self.outputSize, NO, 1);
        CGFloat scaledHeight = self.outputSize.width/frame.size.width * frame.size.height;
        [frame drawInRect:CGRectMake(0,
                                     floorf(self.outputSize.height/2 - scaledHeight/2),
                                     self.outputSize.width,
                                     scaledHeight)];
        UIImage *scaledFrame = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CVPixelBufferRef pixelBuffer = NULL;
        int status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, avAdaptor.pixelBufferPool, &pixelBuffer);
        if (status == 0)
        {
            CGImageRef image = [scaledFrame CGImage];
            CGDataProviderRef imageDataProvider = CGImageGetDataProvider(image);
            CFDataRef imageData = CGDataProviderCopyData(imageDataProvider);
            
            CVPixelBufferLockBaseAddress(pixelBuffer, 0);
            uint8_t* destPixels = CVPixelBufferGetBaseAddress(pixelBuffer);
            CFDataGetBytes(imageData,
                           CFRangeMake(0, CFDataGetLength(imageData)),
                           destPixels);
            
            BOOL success = [avAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:time];
            if (!success)
                NSLog(@"Warning:  Unable to write buffer to video");
            
            CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
            CVPixelBufferRelease(pixelBuffer);
            CFRelease(imageData);
        }
        else
        {
            NSLog(@"Error creating pixel buffer:  status=%d", status);
        }
    }
}

- (void)completeRecordingSession
{
    [videoWriterInput markAsFinished];
        
    __weak __typeof__(self) weakSelf = self;
    [videoWriter finishWritingWithCompletionHandler:^{
        NSLog(@"DONE!");
        __strong __typeof__(weakSelf) strongSelf = weakSelf; if (!strongSelf) return;
        strongSelf->avAdaptor = nil;
        strongSelf->videoWriterInput = nil;
        strongSelf->videoWriter = nil;
    }];
}

@end
