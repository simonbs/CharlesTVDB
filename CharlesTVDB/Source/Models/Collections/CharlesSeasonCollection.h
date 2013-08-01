//
//  CharlesSeasonCollection.h
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesCollection.h"

@class CharlesSeason;

@interface CharlesSeasonCollection : CharlesCollection

- (CharlesSeason *)seasonAtIndex:(NSUInteger)index;
- (NSInteger)indexOfSeason:(CharlesSeason *)season;
- (NSArray *)allSeasons;

@end
