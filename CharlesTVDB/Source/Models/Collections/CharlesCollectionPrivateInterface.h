//
//  CharlesCollectionPrivateInterface.h
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesCollection.h"

@interface CharlesCollection (Private)

- (void)addObject:(id)obj;
- (void)removeObject:(id)obj;
- (id)objectAtIndex:(NSUInteger)index;
- (NSInteger)indexOfObject:(id)obj;
- (NSArray *)allObjects;

@end
