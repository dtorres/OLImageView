//
//  OLImage.m
//  MMT
//
//  Created by Diego Torres on 9/1/12.
//  Copyright (c) 2012 Onda. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "OLImage.h"

inline static double CGImageSourceGetGifFrameDelay(CGImageSourceRef imageSource, NSUInteger index)
{
    double frameDuration = 0.0f;
    
    CFDictionaryRef theImageProperties;
    if ((theImageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, NULL))) {
        CFDictionaryRef gifProperties;
        if (CFDictionaryGetValueIfPresent(theImageProperties, kCGImagePropertyGIFDictionary, (const void **)&gifProperties)) {
            const void *frameDurationValue;
            if (CFDictionaryGetValueIfPresent(gifProperties, kCGImagePropertyGIFUnclampedDelayTime, &frameDurationValue)) {
                frameDuration = [(__bridge NSNumber *)frameDurationValue floatValue];
                if (frameDuration <= 0) {
                    if (CFDictionaryGetValueIfPresent(gifProperties, kCGImagePropertyGIFDelayTime, &frameDurationValue)) {
                        frameDuration = [(__bridge NSNumber *)frameDurationValue floatValue];
                    }
                }
            }
        }
        CFRelease(theImageProperties);
    }
    
    return frameDuration;
}

inline static BOOL CGImageSourceGetFramesAndDurations(NSTimeInterval *finalDuration, NSTimeInterval *frameDurations, NSMutableArray *arrayToFill, CGImageSourceRef imageSource)
{
    BOOL evenFrameDuration = YES;
    NSUInteger numberOfFrames = CGImageSourceGetCount(imageSource);
    for (NSUInteger i = 0; i < numberOfFrames; ++i) {
        
        //Implement as Browsers do, to ensure UX.
        //See: http://nullsleep.tumblr.com/post/16524517190/animated-gif-minimum-frame-delay-browser-compatibility
        //See also: http://blogs.msdn.com/b/ieinternals/archive/2010/06/08/animated-gifs-slow-down-to-under-20-frames-per-second.aspx
        double proposedFrameDuration = CGImageSourceGetGifFrameDelay(imageSource, i);
        #ifndef OLExactGIFRepresentation
        proposedFrameDuration = (proposedFrameDuration >= 0.02) ? proposedFrameDuration : 0.10f;
        #endif
        frameDurations[i] = proposedFrameDuration;
        
        if (evenFrameDuration && i > 0 && frameDurations[i] != frameDurations[i-1]) {
            evenFrameDuration = NO;
        }
        
        CGImageRef theImage = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
        [arrayToFill addObject:[UIImage imageWithCGImage:theImage]];
        CFRelease(theImage);
        *finalDuration += frameDurations[i];
    }
    
    return evenFrameDuration;
}

@interface OLImage ()

@property (nonatomic, readwrite, getter = isGIF) BOOL GIF;
@property (nonatomic, readwrite) NSTimeInterval totalDuration;
@property (nonatomic, readwrite) NSMutableArray *images;

@end

@implementation OLImage
@synthesize GIF, frameDurations, images;
@synthesize totalDuration = _totalDuration;


+ (id)imageWithData:(NSData *)data
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)(data), NULL);
    if (!imageSource)
        return nil;
    
    if (!UTTypeConformsTo(CGImageSourceGetType(imageSource), kUTTypeGIF)) {
        CFRelease(imageSource);
        return [UIImage imageWithData:data];
    }
    NSUInteger numberOfFrames = CGImageSourceGetCount(imageSource);
    NSTimeInterval *finalDuration = (NSTimeInterval *) malloc(sizeof(NSTimeInterval));
    NSTimeInterval *frameDurations = (NSTimeInterval *) malloc(numberOfFrames  * sizeof(NSTimeInterval));
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:numberOfFrames];
    
    BOOL evenDuration = CGImageSourceGetFramesAndDurations(finalDuration, frameDurations, images, imageSource);
    CFRelease(imageSource);
    NSTimeInterval theFinal = *finalDuration;
    free(finalDuration);
    if (evenDuration) {
        return [UIImage animatedImageWithImages:images duration:theFinal];
    }
    
    
    OLImage *animatedImage = [[OLImage  alloc] init];
    animatedImage.images = images;
    animatedImage.totalDuration = theFinal;
    animatedImage.frameDurations = frameDurations;
    if (numberOfFrames > 1) {
        animatedImage.GIF = YES;
    }
    
    return animatedImage;
}

- (id)initWithData:(NSData *)data {
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)(data), NULL);
    
    if (!UTTypeConformsTo(CGImageSourceGetType(imageSource), kUTTypeGIF)) {
        CFRelease(imageSource);
        return [super initWithData:data];
    }
    
    if (imageSource) {
        NSTimeInterval *aFinalDuration = NULL;
        NSUInteger numberOfFrames = CGImageSourceGetCount(imageSource);
        
        self.images = [NSMutableArray arrayWithCapacity:numberOfFrames];
        CGImageSourceGetFramesAndDurations(aFinalDuration, self.frameDurations, self.images, imageSource);
        _totalDuration = *aFinalDuration;
        
        if (numberOfFrames > 1) {
            self.GIF = YES;
        }
        return self;
    }
    return nil;
    
}

- (NSTimeInterval)duration {
    return 0;
}

@end
