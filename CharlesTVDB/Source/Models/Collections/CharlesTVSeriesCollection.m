//
//  CharlesTVSeriesCollection.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesTVSeriesCollection.h"
#import "CharlesCollectionPrivateInterface.h"

@implementation CharlesTVSeriesCollection

#pragma mark -
#pragma mark Public Methods

- (CharlesTVSeries *)tvSeriesAtIndex:(NSUInteger)index
{
    return [self objectAtIndex:index];
}

- (NSInteger)indexOfTVSeries:(CharlesTVSeries *)tvSeries
{
    return [self indexOfObject:tvSeries];
}

- (NSArray *)allTVSeries
{
    return [self allObjects];
}

@end
