//
//  CharlesRequest.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesRequest.h"
#import "CharlesClient.h"
#import "NSURL+Charles.h"
#import "NSString+Charles.h"

@implementation CharlesRequest

#pragma mark -
#pragma mark Lifecycle

- (id)initWithPath:(NSString *)path usingAPIKey:(BOOL)useAPIKey
{
    if (self = [super init])
    {
        _url = useAPIKey ? [self baseUrlWithAPIKey] : [self baseUrl];
        _url = [_url URLByAppendingPathComponent:path];
    }
    
    return self;
}

+ (CharlesRequest *)requestWithPath:(NSString *)path usingAPIKey:(BOOL)useAPIKey
{
    return [[[self class] alloc] initWithPath:path usingAPIKey:useAPIKey];
}

- (void)dealloc
{
    _url = nil;
}

#pragma mark -
#pragma mark Public Methods

- (void)addQueryParameterWithValue:(NSString *)value forKey:(NSString *)key
{
    value = [value urlEncodeUsingEncoding:NSUTF8StringEncoding];
    key = [key urlEncodeUsingEncoding:NSUTF8StringEncoding];
    _url = [_url URLByAddingQueryParameterWithValue:value forKey:key];
}

- (void)startWithCompletion:(void(^)(DDXMLDocument *xmlDocument))completion failure:(void(^)(NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    AFKissXMLRequestOperation *operation = [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
        if (completion)
        {
            completion(XMLDocument);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
        if (failure)
        {
            failure(error);
        }
    }];
    [operation start];
}

#pragma mark -
#pragma mark Private Methods

- (NSURL *)baseUrlWithAPIKey
{
    NSAssert([[CharlesClient sharedClient].apiKey length] != 0, @"The request requires an API key to be set on the client.");
    
    return [[self baseUrl] URLByAppendingPathComponent:[CharlesClient sharedClient].apiKey];
}

- (NSURL *)baseUrl
{
    return [NSURL URLWithString:CharlesAPIBaseUrl];
}

@end
