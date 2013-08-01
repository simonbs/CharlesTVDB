//
//  CharlesTVSeries.h
//  CharlesTVDB
//
//  Created by Simon Støvring on 27/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CharlesArtwork, CharlesTVSeriesDetails, CharlesTVSeriesCollection;

@interface CharlesTVSeries : NSObject

@property (nonatomic, readonly) NSNumber *identifier;
@property (nonatomic, readonly) NSString *language;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *overview;
@property (nonatomic, readonly) NSString *network;
@property (nonatomic, readonly) NSDate *firstAired;
@property (nonatomic, readonly) NSString *zap2itId;
@property (nonatomic, readonly) NSString *imdbId;
@property (nonatomic, readonly) CharlesArtwork *banner;
@property (nonatomic, readonly) CharlesTVSeriesDetails *details;
@property (nonatomic, readonly, getter = isDetailsLoaded) BOOL detailsLoaded;

+ (void)loadTVSeriesWithId:(NSUInteger)seriesId completion:(void (^)(CharlesTVSeries *tvSeries))completion failure:(void (^)(NSError *error))failure;
+ (void)loadTVSeriesWithImdbId:(NSString *)imdbId completion:(void (^)(CharlesTVSeries *tvSeries))completion failure:(void (^)(NSError *error))failure;
+ (void)loadTVSeriesWithZap2itId:(NSString *)zap2itId completion:(void (^)(CharlesTVSeries *tvSeries))completion failure:(void (^)(NSError *error))failure;
+ (void)searchTVSeriesByName:(NSString *)name completion:(void (^)(CharlesTVSeriesCollection *results))completion failure:(void (^)(NSError *error))failure;
- (void)loadDetails:(void(^)(BOOL success, NSError *error))completion;

@end
