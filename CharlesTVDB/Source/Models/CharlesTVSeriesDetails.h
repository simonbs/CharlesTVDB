//
//  CharlesTVSeriesDetails.h
//  CharlesTVDB
//
//  Created by Simon Støvring on 31/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CharlesArtwork, CharlesSeasonCollection;

@interface CharlesTVSeriesDetails : NSObject

@property (nonatomic, readonly) NSArray *actors;
@property (nonatomic, readonly) NSArray *genres;
@property (nonatomic, readonly) CharlesArtwork *fanart;
@property (nonatomic, readonly) CharlesArtwork *poster;
@property (nonatomic, readonly) CharlesSeasonCollection *seasons;

@end
