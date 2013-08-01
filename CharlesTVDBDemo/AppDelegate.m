//
//  AppDelegate.m
//  CharlesTVDBDemo
//
//  Created by Simon Støvring on 01/08/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "AppDelegate.h"
#import "CharlesTVDB.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [CharlesTVSeries searchTVSeriesByName:@"The Mentalist" completion:^(NSArray *results) {
        for (CharlesTVSeries *tvSeries in results)
        {
            NSLog(@"Name: %@", tvSeries.name);
            NSLog(@"Overview:\n%@", tvSeries.overview);
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
