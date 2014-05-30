//
//  OLImageResponseSerializer.m
//  OLImageViewDemo
//
//  Created by Romans Karpelcevs on 29/05/14.
//  Copyright (c) 2014 Onda Labs. All rights reserved.
//

#import "OLImageResponseSerializer.h"
#import "OLImage.h"

@implementation OLImageResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    return [OLImage imageWithData:data];
}

@end
