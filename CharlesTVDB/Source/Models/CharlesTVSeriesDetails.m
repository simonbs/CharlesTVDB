//
//  CharlesTVSeriesDetails.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 31/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesTVSeriesDetails.h"
#import "CharlesSeasonCollection.h"

@implementation CharlesTVSeriesDetails

#pragma mark 
#pragma mark Lifecycle

- (id)init
{
    if (self = [super init])
    {
        _seasons = [[CharlesSeasonCollection alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    _actors = nil;
    _genres = nil;
    _fanart = nil;
    _poster = nil;
    _seasons = nil;
}

@end
