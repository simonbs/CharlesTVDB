//
//  CharlesClient.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 27/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesClient.h"

@implementation CharlesClient

#pragma mark -
#pragma mark Lifecycle

- (id)init
{
    if (self = [super init])
    {
        _language = @"en"; // Default language
    }
    
    return self;
}

+ (CharlesClient *)sharedClient
{
    static CharlesClient *sharedClient = nil;
    
    if (sharedClient == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedClient = [[CharlesClient alloc] init];
        });
    }
    
    return sharedClient;
}

- (void)dealloc
{
    _apiKey = nil;
    _language = nil;
}

@end
