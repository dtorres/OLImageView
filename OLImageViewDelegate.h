//
//  OLImageViewDelegate.h
//  OLImageViewDemo
//
//  Created by Rich Schonthal on 4/16/15.
//  Copyright (c) 2015 Onda Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OLImageView;

@protocol OLImageViewDelegate <NSObject>

@optional

- (BOOL)imageViewShouldStartAnimating:(OLImageView *)imageView;

- (void)imageViewDidLoop:(OLImageView *)imageView;

@end
