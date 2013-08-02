//
//  AppDelegate.m
//  CharlesMacDemo
//
//  Created by Simon Støvring on 02/08/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

#pragma mark -
#pragma mark Lifecycle

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // We haven't configured the CharlesClient with an API key because TheTVDB doesn't require an API key for search their  TV series, however, I recommend always setting the key.
    [CharlesTVSeries searchTVSeriesByName:@"the mentalist" completion:^(NSArray *results) {
        for (CharlesTVSeries *tvSeries in results)
        {
            NSLog(@"%@", tvSeries.name);
        }
    } failure:^(NSError *error) {
        NSLog(@"Search failed: %@", error);
    }];
}

@end
