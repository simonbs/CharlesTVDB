//
//  CharlesEpisodeCollection.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesEpisodeCollection.h"
#import "CharlesCollectionPrivateInterface.h"

@implementation CharlesEpisodeCollection

#pragma mark -
#pragma mark Public Methods

- (CharlesEpisode *)episodeAtIndex:(NSUInteger)index
{
    return [self objectAtIndex:index];
}

- (NSInteger)indexOfEpisode:(CharlesEpisode *)episode
{
    return [self indexOfObject:episode];
}

- (NSArray *)allEpisodes
{
    return [self allObjects];
}

@end
