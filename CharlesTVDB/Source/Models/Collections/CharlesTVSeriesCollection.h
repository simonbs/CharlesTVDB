//
//  CharlesTVSeriesCollection.h
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesCollection.h"

@class CharlesTVSeries;

@interface CharlesTVSeriesCollection : CharlesCollection

- (CharlesTVSeries *)tvSeriesAtIndex:(NSUInteger)index;
- (NSInteger)indexOfTVSeries:(CharlesTVSeries *)tvSeries;
- (NSArray *)allTVSeries;

@end
