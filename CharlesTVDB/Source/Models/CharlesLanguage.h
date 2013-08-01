//
//  CharlesLanguage.h
//  CharlesTVDB
//
//  Created by Simon Støvring on 27/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharlesLanguage : NSObject

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *abbreviation;
@property (nonatomic, readonly) NSString *name;

+ (void)loadAllLanguages:(void (^)(NSArray *languages))completion failure:(void (^)(NSError *error))failure;

@end
