//
//  CharlesTimeZoneHelper.m
//  CharlesMacDemo
//
//  Created by Simon Støvring on 10/08/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesTimeZoneHelper.h"
#import "CharlesTVSeries.h"
#import "CharlesTVSeriesDetails.h"
#import "CharlesModels.h"

enum {
    kTimeZoneMapAbbreviationType = 0,
    kTimeZoneMapNameType,
};

#define kTimeZoneMapTimeZoneKey @"timeZone"
#define kTimeZoneMapTypeKey @"type"
#define kTimeZoneMapNetworksKey @"networks"

#define kTimeZoneAbbreviationCET @"CET"
#define kTimeZoneAbbreviationGMT @"GMT"
#define kTimeZoneAbbreviationEST @"US/Eastern"

#define STRING_CONTAINS(str, contains) [str rangeOfString:contains].location != NSNotFound

@implementation CharlesTimeZoneHelper

#pragma mark -
#pragma mark Public Methods

+ (void)configureTVSeriesWithTimeZone:(CharlesTVSeries *)tvSeries
{
    [self configureTVSeriesWithTimeZone:tvSeries useDefaultTimeZone:nil];
}

+ (void)configureTVSeriesWithTimeZone:(CharlesTVSeries *)tvSeries useDefaultTimeZone:(NSTimeZone *)defaultTimeZone
{
    NSTimeZone *timeZone = [self timeZoneForNetwork:tvSeries.network];
    if (!timeZone && defaultTimeZone)
    {
        timeZone = defaultTimeZone;
    }
    
    if ([timeZone isEqual:[NSTimeZone timeZoneWithName:@"US/Eastern"]]) {
        NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
        if ([localTimeZone isEqual:[NSTimeZone timeZoneWithAbbreviation:@"MST"]]) {
            timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CST"];
        } else if ([localTimeZone isEqual:[NSTimeZone timeZoneWithAbbreviation:@"PST"]]) {
            timeZone = localTimeZone;
        }
    }
    
    if (timeZone)
    {
        CharlesTVSeriesDetails *details = tvSeries.details;
        
        // Date formatter for episodes
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        dateFormatter.timeZone = timeZone;
        
        // Configure the date formatter with the airtime if we know it
        if (details.formattedAirtime)
        {
            // Some of the dates provided are formatted with 12-hour notation
            if (details.formattedAirtime.length > 5)
            {
                dateFormatter.dateFormat = @"yyyy-MM-dd h:mm a";
            }
            else
            {
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
            }
        }
        else
        {
            dateFormatter.dateFormat = @"yyyy-MM-dd";
        }
        
        // Check if we know the first aired date of the TV series
        if (tvSeries.formattedFirstAired && [tvSeries.formattedFirstAired length] > 0)
        {
            NSString *firstAired = tvSeries.formattedFirstAired;
            if (details.formattedAirtime)
            {
                firstAired = [firstAired stringByAppendingFormat:@" %@", details.formattedAirtime];
            }
            
            NSDate *firstAiredDate = [dateFormatter dateFromString:firstAired];
            
            // Store the first air date on the TV series
            [tvSeries setValue:firstAiredDate forKey:@"firstAired"];
        }
        
        // Every season in the TV series
        for (CharlesSeason *season in details.seasons)
        {
            // Every episode in the season
            for (CharlesEpisode *episode in season.episodes)
            {
                // Check if we actually know when the episode aired for the first time
                if (episode.formattedFirstAired && [episode.formattedFirstAired length] > 0)
                {
                    NSString *firstAired = episode.formattedFirstAired;
                    if (details.formattedAirtime)
                    {
                        firstAired = [firstAired stringByAppendingFormat:@" %@", details.formattedAirtime];
                    }
                    
                    // Store the first aired date in the episode
                    [episode setValue:[dateFormatter dateFromString:firstAired] forKey:@"firstAired"];
                }
            }
        }
    }
}

+ (NSTimeZone *)timeZoneForNetwork:(NSString *)network
{
    network = [network lowercaseString];
    
    NSTimeZone *result = nil;
    
    NSArray *map = [self timeZoneMap];
    for (NSDictionary *mapEntry in map)
    {
        // Check if we can find a network which is equal to or contains the input
        NSArray *knownNetworks = [mapEntry objectForKey:kTimeZoneMapNetworksKey];
        
        // Check if the input network is known in this map entry
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ == SELF || %@ CONTAINS[c] SELF", network, network];
        NSArray *filteredNetworks = [knownNetworks filteredArrayUsingPredicate:predicate];
        if ([filteredNetworks count] > 0)
        {
            // Create a timezone from the match
            NSString *timeZone = [mapEntry objectForKey:kTimeZoneMapTimeZoneKey];
            NSInteger type = [[mapEntry objectForKey:kTimeZoneMapTypeKey] integerValue];
            switch (type) {
                case kTimeZoneMapAbbreviationType:
                    result = [NSTimeZone timeZoneWithAbbreviation:timeZone];
                    break;
                case kTimeZoneMapNameType:
                    result = [NSTimeZone timeZoneWithName:timeZone];
                    break;
                default:
                    break;
            }
            
            // We found our match, stop looking
            break;
        }
    }
    
    return result;
}

#pragma mark -
#pragma mark Private Methods

+ (NSArray *)timeZoneMap
{
    return @[ @{ kTimeZoneMapTimeZoneKey : kTimeZoneAbbreviationCET,
                 kTimeZoneMapTypeKey     : @(kTimeZoneMapAbbreviationType),
                 kTimeZoneMapNetworksKey : @[ @"dr1", @"dr2", @"tv2", @"svt", @"nrk" ] },
              @{ kTimeZoneMapTimeZoneKey : kTimeZoneAbbreviationGMT,
                 kTimeZoneMapTypeKey     : @(kTimeZoneMapAbbreviationType),
                 kTimeZoneMapNetworksKey : @[ @"e4", @"itv1", @"channel 4", @"bbc" ] },
              @{ kTimeZoneMapTimeZoneKey : kTimeZoneAbbreviationEST,
                 kTimeZoneMapTypeKey     : @[ @"amc", @"fox", @"cbs", @"pbs", @"hbo", @"showtime", @"abc", @"cw", @"the cw"]
                  }];
}

@end
