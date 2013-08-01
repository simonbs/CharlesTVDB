//
//  CharlesSeason.h
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CharlesTVSeries;

@interface CharlesSeason : NSObject

@property (nonatomic, readonly) NSNumber *seasonNumber;
@property (nonatomic, readonly) NSArray *episodes;
@property (nonatomic, readonly, weak) CharlesTVSeries *tvSeries;

@end
