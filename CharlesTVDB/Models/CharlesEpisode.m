//
//  CharlesEpisode.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesEpisode.h"

@implementation CharlesEpisode

#pragma mark -
#pragma mark Lifecycle

- (void)dealloc
{
    _identifier = nil;
    _name = nil;
    _episodeNumber = nil;
    _seasonNumber = nil;
    _overview = nil;
    _firstAired = nil;
    _season = nil;
    _thumb = nil;
}

#pragma mark -
#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:self.class])
    {
        return NO;
    }
    
    CharlesEpisode *other = object;
    return [self.identifier isEqualToNumber:other.identifier];
}

@end
