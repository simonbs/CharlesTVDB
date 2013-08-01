//
//  CharlesTVSeries.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 27/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesTVSeries.h"
#import "CharlesRequest.h"
#import "CharlesEpisode.h"
#import "CharlesSeason.h"
#import "CharlesClient.h"
#import "CharlesArtwork.h"
#import "CharlesTVSeriesDetails.h"

@implementation CharlesTVSeries

#pragma mark -
#pragma mark Lifecycle

- (void)dealloc
{
    _identifier = nil;
    _language = nil;
    _name = nil;
    _overview = nil;
    _network = nil;
    _firstAired = nil;
    _imdbId = nil;
    _zap2itId = nil;
    _banner = nil;
}

#pragma mark -
#pragma mark Public Methods

+ (void)loadTVSeriesWithId:(NSUInteger)seriesId completion:(void (^)(CharlesTVSeries *tvSeries))completion failure:(void (^)(NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"series/%li/all/%@.xml", (unsigned long)seriesId, [CharlesClient sharedClient].language];
    CharlesRequest *request = [CharlesRequest requestWithPath:path usingAPIKey:YES];
    [request startWithCompletion:^(DDXMLDocument *xmlDocument) {
        CharlesTVSeries *tvSeries = [[self class] tvSeriesModelFromDetailsXMLDocument:xmlDocument];
        CharlesTVSeriesDetails *details = [[self class] detailsFromXMLDocument:xmlDocument];
        [tvSeries setValue:details forKey:@"details"];
        [tvSeries setValue:@(YES) forKey:@"detailsLoaded"];
        
        if (completion)
        {
            completion(tvSeries);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

+ (void)loadTVSeriesWithImdbId:(NSString *)imdbId completion:(void (^)(CharlesTVSeries *tvSeries))completion failure:(void (^)(NSError *error))failure
{
    [[self class] loadTVSeriesWithImdbId:imdbId zap2itId:nil completion:completion failure:failure];
}

+ (void)loadTVSeriesWithZap2itId:(NSString *)zap2itId completion:(void (^)(CharlesTVSeries *tvSeries))completion failure:(void (^)(NSError *error))failure
{
    [[self class] loadTVSeriesWithImdbId:nil zap2itId:zap2itId completion:completion failure:failure];
}

+ (void)searchTVSeriesByName:(NSString *)name completion:(void (^)(NSArray *))completion failure:(void (^)(NSError *))failure
{
    CharlesRequest *request = [CharlesRequest requestWithPath:@"GetSeries.php" usingAPIKey:NO];
    [request addQueryParameterWithValue:name forKey:@"seriesname"];
    [request addQueryParameterWithValue:[CharlesClient sharedClient].language forKey:@"language"];
    [request startWithCompletion:^(DDXMLDocument *xmlDocument) {
        if (completion)
        {
            NSArray *seriesElements = [xmlDocument.rootElement elementsForName:@"Series"];
            NSMutableArray *results = [NSMutableArray arrayWithCapacity:[seriesElements count]];
            for (DDXMLElement *element in seriesElements)
            {
                CharlesTVSeries *tvSeries = [self tvSeriesModelFromXMLElement:element];
                [results addObject:tvSeries];
            }
            
            completion(results);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

- (void)loadDetails:(void (^)(BOOL, NSError *))completion
{
    if (self.isDetailsLoaded)
    {
        completion(YES, nil);
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"series/%@/all/%@.xml", self.identifier, [CharlesClient sharedClient].language];
    CharlesRequest *request = [CharlesRequest requestWithPath:path usingAPIKey:YES];
    [request startWithCompletion:^(DDXMLDocument *xmlDocument) {
        CharlesTVSeriesDetails *details = [[self class] detailsFromXMLDocument:xmlDocument];
        [self setValue:details forKey:@"details"];
        [self setValue:@(YES) forKey:@"detailsLoaded"];
        
        if (completion)
        {
            completion(YES, nil);
        }
    } failure:^(NSError *error) {
        if (completion)
        {
            completion(NO, error);
        }
    }];
}

#pragma mark -
#pragma mark Private Methods

+ (void)loadTVSeriesWithImdbId:(NSString *)imdbId zap2itId:(NSString *)zap2itId completion:(void (^)(CharlesTVSeries *tvSeries))completion failure:(void (^)(NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"GetSeriesByRemoteID.php"];
    CharlesRequest *request = [CharlesRequest requestWithPath:path usingAPIKey:NO];
    [request addQueryParameterWithValue:[CharlesClient sharedClient].language forKey:@"language"];
    if ([imdbId length] > 0)
    {
        [request addQueryParameterWithValue:imdbId forKey:@"imdbid"];
    }
    else if ([zap2itId length] > 0)
    {
        [request addQueryParameterWithValue:zap2itId forKey:@"zap2it"];
    }
    [request startWithCompletion:^(DDXMLDocument *xmlDocument) {
        CharlesTVSeries *tvSeries = nil;
        NSArray *seriesElements = [xmlDocument.rootElement elementsForName:@"Series"];
        if ([seriesElements count] > 0)
        {
            DDXMLElement *element = [seriesElements objectAtIndex:0];
            tvSeries = [self tvSeriesModelFromXMLElement:element];
        }
        
        if (completion)
        {
            completion(tvSeries);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

+ (CharlesTVSeries *)tvSeriesModelFromXMLElement:(DDXMLElement *)element
{
    NSArray *seriesIds = [element elementsForName:@"seriesid"];
    NSArray *languages = [element elementsForName:@"language"];
    NSArray *seriesNames = [element elementsForName:@"SeriesName"];
    NSArray *overviews = [element elementsForName:@"Overview"];
    NSArray *imdbIds = [element elementsForName:@"IMDB_ID"];
    NSArray *zap2itIds = [element nodesForXPath:@"zap2it_id" error:nil];
    NSArray *networks = [element elementsForName:@"Network"];
    NSArray *banners = [element elementsForName:@"banner"];
    NSArray *firstAireds = [element elementsForName:@"FirstAired"];
    
    return [self tvSeriesWithNodesSeriesIDs:seriesIds languages:languages seriesNames:seriesNames overviews:overviews imdbIDs:imdbIds zap2itIDs:zap2itIds networks:networks banners:banners firstAireds:firstAireds];
}

+ (CharlesTVSeries *)tvSeriesModelFromDetailsXMLDocument:(DDXMLDocument *)document
{
    NSArray *seriesIds = [document.rootElement nodesForXPath:@"Series/SeriesID" error:nil];
    NSArray *languages = [document.rootElement nodesForXPath:@"Series/Language" error:nil];
    NSArray *seriesNames = [document.rootElement nodesForXPath:@"Series/SeriesName" error:nil];
    NSArray *overviews = [document.rootElement nodesForXPath:@"Series/Overview" error:nil];
    NSArray *imdbIds = [document.rootElement nodesForXPath:@"Series/IMDB_ID" error:nil];
    NSArray *zap2itIds = [document.rootElement nodesForXPath:@"Series/zap2it_id" error:nil];
    NSArray *networks = [document.rootElement nodesForXPath:@"Series/Network" error:nil];
    NSArray *banners = [document.rootElement nodesForXPath:@"Series/banner" error:nil];
    NSArray *firstAireds = [document.rootElement nodesForXPath:@"Series/FirstAired" error:nil];
    
    return [self tvSeriesWithNodesSeriesIDs:seriesIds languages:languages seriesNames:seriesNames overviews:overviews imdbIDs:imdbIds zap2itIDs:zap2itIds networks:networks banners:banners firstAireds:firstAireds];
}

+ (CharlesTVSeries *)tvSeriesWithNodesSeriesIDs:(NSArray *)seriesIds languages:(NSArray *)languages seriesNames:(NSArray *)seriesNames overviews:(NSArray *)overviews imdbIDs:(NSArray *)imdbIds zap2itIDs:(NSArray *)zap2itIds networks:(NSArray *)networks banners:(NSArray *)banners firstAireds:(NSArray *)firstAireds
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    CharlesTVSeries *tvSeries = [[CharlesTVSeries alloc] init];
    if ([seriesIds count] > 0) [tvSeries setValue:[numberFormatter numberFromString:[[seriesIds objectAtIndex:0] stringValue]] forKey:@"identifier"];
    if ([languages count] > 0) [tvSeries setValue:[[languages objectAtIndex:0] stringValue] forKey:@"language"];
    if ([seriesNames count] > 0) [tvSeries setValue:[[seriesNames objectAtIndex:0] stringValue] forKey:@"name"];
    if ([overviews count] > 0) [tvSeries setValue:[[overviews objectAtIndex:0] stringValue] forKey:@"overview"];
    if ([imdbIds count] > 0) [tvSeries setValue:[[imdbIds objectAtIndex:0] stringValue] forKey:@"imdbId"];
    if ([zap2itIds count] > 0) [tvSeries setValue:[[zap2itIds objectAtIndex:0] stringValue] forKey:@"zap2itId"];
    if ([networks count] > 0) [tvSeries setValue:[[networks objectAtIndex:0] stringValue] forKey:@"network"];
    if ([banners count] > 0)
    {
        NSURL *url = [[NSURL URLWithString:CharlesBannersBaseUrl] URLByAppendingPathComponent:[[banners objectAtIndex:0] stringValue]];
        CharlesArtwork *banner = [[CharlesArtwork alloc] init];
        [banner setValue:url forKey:@"url"];
        [tvSeries setValue:banner forKey:@"banner"];
    }
    if ([firstAireds count] > 0)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        dateFormatter.dateFormat = @"y-M-d";
        
        NSDate *firstAired = [dateFormatter dateFromString:[[firstAireds objectAtIndex:0] stringValue]];
        [tvSeries setValue:firstAired forKey:@"firstAired"];
    }
    
    return tvSeries;
}

+ (CharlesEpisode *)episodeModelFromXMLElement:(DDXMLElement *)element
{
    NSArray *identifiers = [element elementsForName:@"id"];
    NSArray *episodeNumbers = [element elementsForName:@"EpisodeNumber"];
    NSArray *seasonNumbers = [element elementsForName:@"SeasonNumber"];
    NSArray *names = [element elementsForName:@"EpisodeName"];
    NSArray *overviews = [element elementsForName:@"Overview"];
    NSArray *directors = [element elementsForName:@"Director"];
    NSArray *writers = [element elementsForName:@"Writer"];
    NSArray *guestStars = [element elementsForName:@"GuestStars"];
    NSArray *firstAireds = [element elementsForName:@"FirstAired"];
 
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        
    CharlesEpisode *episode = [[CharlesEpisode alloc] init];
    if ([identifiers count] > 0) [episode setValue:[numberFormatter numberFromString:[[identifiers objectAtIndex:0] stringValue]] forKey:@"identifier"];
    if ([episodeNumbers count] > 0) [episode setValue:[numberFormatter numberFromString:[[episodeNumbers objectAtIndex:0] stringValue]] forKey:@"episodeNumber"];
    if ([seasonNumbers count] > 0) [episode setValue:[numberFormatter numberFromString:[[seasonNumbers objectAtIndex:0] stringValue]] forKey:@"seasonNumber"];
    if ([names count] > 0) [episode setValue:[[names objectAtIndex:0] stringValue] forKey:@"name"];
    if ([overviews count] > 0) [episode setValue:[[overviews objectAtIndex:0] stringValue] forKey:@"overview"];
    if ([directors count] > 0) [episode setValue:[self arrayFromMultipleValuedString:[[directors objectAtIndex:0] stringValue]] forKey:@"directors"];
    if ([writers count] > 0) [episode setValue:[self arrayFromMultipleValuedString:[[writers objectAtIndex:0] stringValue]] forKey:@"writers"];
    if ([guestStars count] > 0) [episode setValue:[self arrayFromMultipleValuedString:[[guestStars objectAtIndex:0] stringValue]] forKey:@"guestStars"];
    if ([firstAireds count] > 0)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        dateFormatter.dateFormat = @"y-M-d";
        [episode setValue:[dateFormatter dateFromString:[[firstAireds objectAtIndex:0] stringValue]] forKey:@"firstAired"];
    }
    
    return episode;
}

+ (CharlesTVSeriesDetails *)detailsFromXMLDocument:(DDXMLDocument *)document
{
    CharlesTVSeriesDetails *details = [[CharlesTVSeriesDetails alloc] init];
    
    NSArray *actors = [document.rootElement nodesForXPath:@"Series/Actors" error:nil];
    NSArray *genres = [document.rootElement nodesForXPath:@"Series/Genre" error:nil];
    NSArray *fanarts = [document.rootElement nodesForXPath:@"Series/fanart" error:nil];
    NSArray *posters = [document.rootElement nodesForXPath:@"Series/poster" error:nil];
    
    if ([actors count] > 0) [details setValue:[[self class] arrayFromMultipleValuedString:[[actors objectAtIndex:0] stringValue]] forKey:@"actors"];
    if ([genres count] > 0) [details setValue:[[self class] arrayFromMultipleValuedString:[[genres objectAtIndex:0] stringValue]] forKey:@"genres"];
    if ([fanarts count] > 0)
    {
        NSURL *url = [[NSURL URLWithString:CharlesBannersBaseUrl] URLByAppendingPathComponent:[[fanarts objectAtIndex:0] stringValue]];
        CharlesArtwork *fanart = [[CharlesArtwork alloc] init];
        [fanart setValue:url forKey:@"url"];
        [details setValue:fanart forKey:@"fanart"];
    }
    if ([posters count] > 0)
    {
        NSURL *url = [[NSURL URLWithString:CharlesBannersBaseUrl] URLByAppendingPathComponent:[[posters objectAtIndex:0] stringValue]];
        CharlesArtwork *poster = [[CharlesArtwork alloc] init];
        [poster setValue:url forKey:@"url"];
        [details setValue:poster forKey:@"poster"];
    }
    
    NSArray *episodeElements = [document.rootElement elementsForName:@"Episode"];
    NSMutableArray *allEpisodes = [NSMutableArray arrayWithCapacity:[episodeElements count]];
    for (DDXMLElement *element in episodeElements)
    {
        CharlesEpisode *episode = [[self class] episodeModelFromXMLElement:element];
        [allEpisodes addObject:episode];
    }
    
    NSSortDescriptor *seasonSortDesc = [NSSortDescriptor sortDescriptorWithKey:@"seasonNumber" ascending:YES];
    NSSortDescriptor *episodeSortDesc = [NSSortDescriptor sortDescriptorWithKey:@"episodeNumber" ascending:YES];
    [allEpisodes sortUsingDescriptors:@[ seasonSortDesc, episodeSortDesc ]];
    
    // Group episodes into seasons and add the seasons to the series
    NSSortDescriptor *seasonNumberSortDesc = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *seasonNumbers = [[allEpisodes valueForKeyPath:@"@distinctUnionOfObjects.seasonNumber"] sortedArrayUsingDescriptors:@[ seasonNumberSortDesc ]];
    NSMutableArray *seasons = [NSMutableArray arrayWithCapacity:[seasonNumbers count]];
    for (NSNumber *seasonNumber in seasonNumbers)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"seasonNumber == %@", seasonNumber];
        NSArray *episodes = [allEpisodes filteredArrayUsingPredicate:predicate];
        CharlesSeason *season = [[CharlesSeason alloc] init];
        [season setValue:seasonNumber forKey:@"seasonNumber"];
        [season setValue:episodes forKey:@"episodes"];

        [seasons addObject:season];
    }
    
    [details setValue:seasons forKey:@"seasons"];
    
    return details;
}

+ (NSArray *)arrayFromMultipleValuedString:(NSString *)str
{
    NSMutableArray *components = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"|"]];
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:[components count]];
    for (NSString *component in components)
    {
        if ([component length] != 0)
        {
            // Strip spaces from start
            NSRange startRange = NSMakeRange(0, 1);
            NSMutableString *mutable = [NSMutableString stringWithString:component];
            if ([[mutable substringWithRange:startRange] isEqualToString:@" "])
            {
                [mutable replaceCharactersInRange:startRange withString:@""];
            }
            
            // Strip spaces from end
            NSRange endRange = NSMakeRange([mutable length] - 1, 1);
            if ([[mutable substringWithRange:endRange] isEqualToString:@" "])
            {
                [mutable replaceCharactersInRange:endRange withString:@""];
            }
            
            [values addObject:mutable];
        }
    }
    
    return values;
}

#pragma mark -
#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:self.class])
    {
        return NO;
    }
        
    CharlesTVSeries *other = object;
    return [self.identifier isEqualToNumber:other.identifier];
}

@end
