//
//  CharlesArtwork.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 31/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesArtwork.h"
#import "AFNetworking.h"

@implementation CharlesArtwork

#pragma mark -
#pragma mark Lifecycle

- (void)dealloc
{
    _url = nil;
    _image = nil;
}

#pragma mark -
#pragma mark Public Methods

- (void)loadImage:(void (^)(BOOL, NSError *))completion
{
    if (self.isLoaded)
    {
        completion(YES, nil);
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, CharlesImage *image) {
        [self setValue:image forKey:@"image"];
        [self setValue:@(YES) forKey:@"loaded"];
        
        if (completion)
        {
            completion(YES, nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        if (completion)
        {
            completion(NO, error);
        }
    }];
    [operation start];
}

@end
