//
//  OLImage.h
//  MMT
//
//  Created by Diego Torres on 9/1/12.
//  Copyright (c) 2012 Onda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OLImage : UIImage

///-----------------------
/// @name Image Attributes
///-----------------------

/**
 A C array containing the frame durations.
 
 The number of frames is defined by the count of the `images` array property.
 */
@property (nonatomic, readonly) NSTimeInterval *frameDurations;

/**
 Total duration of the animated image.
 */
@property (nonatomic, readonly) NSTimeInterval totalDuration;

/**
 Number of loops the image can do before it stops
 */
@property (nonatomic, readonly) NSUInteger loopCount;

@end


///----------------------------
/// @name Partial Image Methods
///----------------------------

@interface OLImage (IncrementalData)
/**
 Creates and returns an image object with the Incremental Data processed
 
 @param data The image data. This can be partial data or `nil`
 @return A new image object with the specified data or partial container if none was provided.
 */
+ (instancetype)imageWithIncrementalData:(NSData *)data;

/**
 Update the image instance with new data
 
 @param data The image data. This can be partial data.
 This calls `updateWithData:final:` with `NO` as the `finalize` argument.
 */
- (void)updateWithData:(NSData *)data;

/**
 Update the image instance with new data
 
 @param data The image data. This can be partial data.
 @param finalize `YES` if this the data provided is complete
 */
- (void)updateWithData:(NSData *)data final:(BOOL)finalize;

/**
 Whether the instance is a partial or complete image.
 */
@property (nonatomic, readonly, getter = isPartial) BOOL partial;

@end