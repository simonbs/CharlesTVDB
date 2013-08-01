//
//  CharlesSeason.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesSeason.h"
#import "CharlesEpisodeCollection.h"

@implementation CharlesSeason

#pragma mark -
#pragma mark Lifecycle

- (id)init
{
    if (self = [super init])
    {
        _episodes = [[CharlesEpisodeCollection alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    _seasonNumber = nil;
    _episodes = nil;
    _tvSeries = nil;
}

@end
