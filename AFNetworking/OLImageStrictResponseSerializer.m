//
//  OLImageStrictResponseSerializer.m
//  OLImageViewDemo
//
//  Created by Romans Karpelcevs on 16/06/14.
//  Copyright (c) 2014 Onda Labs. All rights reserved.
//

#import "OLImageStrictResponseSerializer.h"
#import "OLImage.h"

@implementation OLImageStrictResponseSerializer

- (id)init
{
    self = [super init];
    if (self) {
        self.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"image/gif", nil];
    }
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    // Decode only valid response codes and MIME types
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error])
        return nil;

    return [OLImage imageWithData:data];
}

@end