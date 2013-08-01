//
//  CharlesSeason.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesSeason.h"

@implementation CharlesSeason

#pragma mark -
#pragma mark Lifecycle

- (void)dealloc
{
    _seasonNumber = nil;
    _episodes = nil;
    _tvSeries = nil;
}

@end
