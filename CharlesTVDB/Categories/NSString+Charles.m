//
//  NSString+Charles.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 31/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "NSString+Charles.h"

@implementation NSString (Charles)

#pragma mark -
#pragma mark Public Methods

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    // http://madebymany.com/blog/url-encoding-an-nsstring-on-ios
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding)));
}

@end
