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
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        CharlesImage *image = (CharlesImage *)responseObject;
        
        [self setValue:image forKey:@"image"];
        [self setValue:@(YES) forKey:@"loaded"];
        
        if (completion)
        {
            completion(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion)
        {
            completion(NO, error);
        }
    }];
    
    [operation start];
}

@end
