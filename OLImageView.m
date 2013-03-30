//
//  OLImageView.m
//  OLImageViewDemo
//
//  Created by Diego Torres on 9/5/12.
//  Copyright (c) 2012 Onda Labs. All rights reserved.
//

#import "OLImageView.h"
#import "OLImage.h"
#import <QuartzCore/QuartzCore.h>

@interface OLImageView ()

@property (nonatomic, strong) OLImage *animatedImage;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) NSTimeInterval currentFrameTimeStamp;
@property (nonatomic) NSUInteger currentFrameIndex;
@property (nonatomic) NSUInteger loopCountdown;

@end

@implementation OLImageView

@synthesize runLoopMode = _runLoopMode;

- (id)init
{
    self = [super init];
    if (self) {
        self.currentFrameIndex = 0;
    }
    return self;
}

- (void)dealloc
{
    [self stopAnimating];
}

- (NSString *)runLoopMode
{
    return _runLoopMode ?: NSDefaultRunLoopMode;
}

- (void)setRunLoopMode:(NSString *)runLoopMode
{
    if (runLoopMode != _runLoopMode) {
        _runLoopMode = runLoopMode;
        [self stopAnimating];
        [self startAnimating];
    }
}

- (void)setImage:(UIImage *)image
{
    [self stopAnimating];
    self.currentFrameIndex = 0;
    self.animatedImage = nil;
    self.loopCountdown = 0;
    
    if ([image isKindOfClass:[OLImage class]] && image.images) {
        self.animatedImage = (OLImage *)image;
        self.layer.contents = (__bridge id)([[self.animatedImage.images objectAtIndex:0] CGImage]);
        self.loopCountdown = self.animatedImage.loopCount ?: NSUIntegerMax;
        [self startAnimating];
    } else {
        [super setImage:image];
    }
}

- (BOOL)isAnimating
{
    return (self.displayLink != nil);
}

- (void)stopAnimating
{
    if (!self.animatedImage) {
        [super stopAnimating];
        return;
    }
    
    self.loopCountdown = 0;
    
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)startAnimating
{
    if (!self.animatedImage) {
        [super startAnimating];
        return;
    }
    
    if (self.isAnimating) {
        return;
    }
    
    self.loopCountdown = self.animatedImage.loopCount ?: NSUIntegerMax;
    
    self.currentFrameTimeStamp = 0;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeKeyframe:)];
	[self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:self.runLoopMode];
}

- (void)changeKeyframe:(CADisplayLink *)displayLink
{
    NSTimeInterval timestamp = displayLink.timestamp;
    if (timestamp - self.currentFrameTimeStamp >= self.animatedImage.frameDurations[self.currentFrameIndex]) {
        self.currentFrameTimeStamp = timestamp;
        if (++self.currentFrameIndex >= [self.animatedImage.images count]) {
            if (--self.loopCountdown == 0) {
                [self stopAnimating];
                return;
            }
            self.currentFrameIndex = 0;
        }
        [self.layer setNeedsDisplay];
    }
}

- (void)displayLayer:(CALayer *)layer
{
    layer.contents = (__bridge id)([[self.animatedImage.images objectAtIndex:self.currentFrameIndex] CGImage]);
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window) {
        [self startAnimating];
    } else {
        [self stopAnimating];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (!self.animatedImage) {
        [super setHighlighted:highlighted];
    }
}

- (UIImage *)image
{
    return self.animatedImage ?: [super image];
}

@end
