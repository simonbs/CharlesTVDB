//
//  CharlesEpisode.h
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CharlesArtwork, CharlesSeason;

@interface CharlesEpisode : NSObject

@property (nonatomic, readonly) NSNumber *identifier;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSNumber *episodeNumber;
@property (nonatomic, readonly) NSNumber *seasonNumber;
@property (nonatomic, readonly) NSString *overview;
@property (nonatomic, readonly) NSArray *writers;
@property (nonatomic, readonly) NSArray *directors;
@property (nonatomic, readonly) NSArray *guestStars;
@property (nonatomic, readonly) NSString *formattedFirstAired;
@property (nonatomic, readonly) NSString *imdbId;
@property (nonatomic, readonly) CharlesArtwork *thumb;
@property (nonatomic, readonly, weak) CharlesSeason *season;

/**
 *  This is not set unless you configure the TV series using the CharlesTimeZoneHelper.
 */
@property (nonatomic, readonly) NSDate *firstAired;

@end
