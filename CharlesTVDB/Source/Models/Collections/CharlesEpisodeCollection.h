//
//  CharlesEpisodeCollection.h
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesCollection.h"

@class CharlesEpisode;

@interface CharlesEpisodeCollection : CharlesCollection

- (CharlesEpisode *)episodeAtIndex:(NSUInteger)index;
- (NSInteger)indexOfEpisode:(CharlesEpisode *)episode;
- (NSArray *)allEpisodes;

@end
