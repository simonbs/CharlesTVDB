//
//  NSURL+Charles.h
//  CharlesTVDB
//
//  Created by Simon Støvring on 27/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Charles)

- (NSURL *)URLByAddingQueryParameterWithValue:(NSString *)value forKey:(NSString *)key;

@end
