//
//  CharlesTimeZoneHelper.h
//  CharlesMacDemo
//
//  Created by Simon Støvring on 10/08/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CharlesTVSeries;

@interface CharlesTimeZoneHelper : NSObject

+ (NSTimeZone *)timeZoneForNetwork:(NSString *)network;
+ (void)configureTVSeriesWithTimeZone:(CharlesTVSeries *)tvSeries;
+ (void)configureTVSeriesWithTimeZone:(CharlesTVSeries *)tvSeries useDefaultTimeZone:(NSTimeZone *)defaultTimeZone;

@end
