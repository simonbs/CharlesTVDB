//
//  CharlesArtwork.h
//  CharlesTVDB
//
//  Created by Simon Støvring on 31/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CharlesMacros.h"

@interface CharlesArtwork : NSObject

@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) CharlesImage *image;
@property (nonatomic, readonly, getter = isLoaded) BOOL loaded;

- (void)loadImage:(void (^)(BOOL success, NSError *error))completion;

@end
