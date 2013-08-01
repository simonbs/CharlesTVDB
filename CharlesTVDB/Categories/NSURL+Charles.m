//
//  NSURL+Charles.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 27/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "NSURL+Charles.h"

@implementation NSURL (Charles)

#pragma mark -
#pragma mark Public Methods

- (NSURL *)URLByAddingQueryParameterWithValue:(NSString *)value forKey:(NSString *)key
{
    NSParameterAssert(value != nil);
    NSParameterAssert(key != nil);
    
    NSString *queryString = [NSString stringWithFormat:@"%@=%@", key, value];
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@%@", [self absoluteString], [self query] ? @"&" : @"?", queryString];
    
    return [NSURL URLWithString:urlString];
}

@end
