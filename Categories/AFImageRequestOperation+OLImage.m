//
//  AFImageRequestOperation+OLImage.m
//  MMTmini
//
//  Created by Diego Torres on 16-10-12.
//  Copyright (c) 2012 Onda. All rights reserved.
//

#import "AFImageRequestOperation+OLImage.h"
#import <objc/runtime.h>
#import "OLImage.h"

static char kAFImageObjectKey;

@interface AFImageRequestOperation (_OLImage)

@property (nonatomic, strong, getter = ol_responseImage, setter = ol_setResponseImage:) UIImage *ol_responseImage;

@end

@implementation AFImageRequestOperation (_OLImage)

@dynamic ol_responseImage;

- (UIImage *)ol_responseImage {
    return (UIImage *)objc_getAssociatedObject(self, &kAFImageObjectKey);
}

- (void)ol_setResponseImage:(UIImage *)image {
    objc_setAssociatedObject(self, &kAFImageObjectKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation AFImageRequestOperation (OLImage)

- (UIImage *)responseImage {
    if (![self ol_responseImage] && [self.responseData length] > 0 && [self isFinished]) {
        UIImage *image = [OLImage imageWithData:self.responseData];
        self.ol_responseImage = image;
    }
    
    return self.ol_responseImage;
}

@end
