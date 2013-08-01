//
//  CharlesRequest.h
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFKissXMLRequestOperation.h"

@interface CharlesRequest : NSObject

@property (nonatomic, readonly) NSURL *url;

- (id)initWithPath:(NSString *)path usingAPIKey:(BOOL)useAPIKey;
+ (CharlesRequest *)requestWithPath:(NSString *)path usingAPIKey:(BOOL)useAPIKey;
- (void)addQueryParameterWithValue:(NSString *)value forKey:(NSString *)key;
- (void)startWithCompletion:(void(^)(DDXMLDocument *xmlDocument))completion failure:(void(^)(NSError *error))failure;

@end
