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

@property (nonatomic) NSUInteger currentFrameIndex;
@property (nonatomic) NSTimeInterval currentKeyframeElapsedTime;
@property (nonatomic) OLImage *animatedImage;
@property (nonatomic, strong) NSTimer *keyFrameTimer;

@end

@implementation OLImageView

@synthesize currentFrameIndex;

-(id)init
{
    self = [super init];
    if (self) {
        self.currentFrameIndex = 0;
        self.animatedImage = nil;
        self.keyFrameTimer = nil;
    }
    return self;
}

-(void)setImage:(UIImage *)image
{
    [self stopAnimating];
    self.currentFrameIndex = 0;
    self.animatedImage = nil;
    
    if ([image isKindOfClass:[OLImage class]] && image.images) {
        self.animatedImage = (OLImage *)image;
        self.layer.contents = (__bridge id)([(UIImage *)[self.animatedImage.images objectAtIndex:0] CGImage]);
        [self startAnimating];
    } else {
        [super setImage:image];
    }
}

-(BOOL)isAnimating {
    return (self.keyFrameTimer != nil);
}

-(void)stopAnimating
{
    if (!self.animatedImage) {
        [super stopAnimating];
        return;
    }
    
    if (self.keyFrameTimer) {
        [self.keyFrameTimer invalidate];
        self.keyFrameTimer = nil;
    }
}

-(void)startAnimating
{    
    if (!self.animatedImage) {
        [super startAnimating];
        return;
    }
    if (!self.keyFrameTimer) {
        self.keyFrameTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(changeKeyframe) userInfo:nil repeats:YES];
    }
}

- (void)changeKeyframe
{
    self.currentKeyframeElapsedTime += self.keyFrameTimer.timeInterval;
    if (self.currentKeyframeElapsedTime >= self.animatedImage.frameDurations[self.currentFrameIndex]) {
        NSUInteger newIndex = self.currentFrameIndex + 1;
        if (newIndex >= [self.animatedImage.images count]) {
            newIndex = 0;
        }
        self.currentFrameIndex = newIndex;
        self.currentKeyframeElapsedTime = 0.0f;
        [self.layer setNeedsDisplay];
    }
}

- (void)displayLayer:(CALayer *)layer {
    layer.contents = (__bridge id)([(UIImage *)[self.animatedImage.images objectAtIndex:self.currentFrameIndex] CGImage]);
}

- (void)didMoveToSuperview {
    if (!self.superview) {
        [self stopAnimating];
    } else {
        [self startAnimating];
    }
}

- (UIImage *)image {
    if (self.animatedImage != nil) {
        return self.animatedImage;
    }
    return [super image];
}

@end
