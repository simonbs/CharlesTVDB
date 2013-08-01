//
//  CharlesSeasonCollection.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesSeasonCollection.h"
#import "CharlesCollectionPrivateInterface.h"

@implementation CharlesSeasonCollection

#pragma mark -
#pragma mark Public Methods

- (CharlesSeason *)seasonAtIndex:(NSUInteger)index
{
    return [self objectAtIndex:index];
}

- (NSInteger)indexOfSeason:(CharlesSeason *)season
{
    return [self indexOfObject:season];
}

- (NSArray *)allSeasons
{
    return [self allObjects];
}

@end
