//
//  OLImage.h
//  MMT
//
//  Created by Diego Torres on 9/1/12.
//  Copyright (c) 2012 Onda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OLImage : UIImage

@property (nonatomic) NSTimeInterval *frameDurations;
@property (nonatomic, readonly) NSTimeInterval totalDuration;

@end
