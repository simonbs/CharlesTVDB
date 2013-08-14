//
//  CharlesTVSeriesDetails.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 31/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesTVSeriesDetails.h"

@implementation CharlesTVSeriesDetails

#pragma mark 
#pragma mark Lifecycle

- (void)dealloc
{
    _actors = nil;
    _genres = nil;
    _formattedAirtime = nil;
    _fanart = nil;
    _poster = nil;
    _seasons = nil;
}

@end
