//
//  CharlesLanguage.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 27/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesLanguage.h"
#import "CharlesRequest.h"

@implementation CharlesLanguage

#pragma mark -
#pragma mark Lifecycle

- (void)dealloc
{
    _identifier = nil;
    _abbreviation = nil;
    _name = nil;
}

#pragma mark -
#pragma mark Public Methods

+ (void)loadAllLanguages:(void (^)(NSArray *))completion failure:(void (^)(NSError *))failure
{
    CharlesRequest *request = [CharlesRequest requestWithPath:@"languages.xml" usingAPIKey:YES];
    [request startWithCompletion:^(DDXMLDocument *xmlDocument) {
        if (completion)
        {
            NSArray *langElements = [xmlDocument.rootElement elementsForName:@"Language"];
            NSMutableArray *languages = [NSMutableArray arrayWithCapacity:[langElements count]];
            for (DDXMLElement *element in langElements)
            {
                CharlesLanguage *language = [self languageModelFromXMLElement:element];
                if (language)
                {
                    [languages addObject:language];
                }
            }
            
            completion(languages);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

#pragma mark -
#pragma mark Private Methods

+ (CharlesLanguage *)languageModelFromXMLElement:(DDXMLElement *)element
{
    NSArray *names = [element elementsForName:@"name"];
    NSArray *abbreviations = [element elementsForName:@"abbreviation"];
    NSArray *identifiers = [element elementsForName:@"id"];
    if ([names count] > 0 && [abbreviations count] > 0 && [identifiers count] > 0)
    {
        CharlesLanguage *language = [[CharlesLanguage alloc] init];
        [language setValue:[[names objectAtIndex:0] stringValue] forKey:@"name"];
        [language setValue:[[abbreviations objectAtIndex:0] stringValue] forKey:@"abbreviation"];
        [language setValue:[[identifiers objectAtIndex:0] stringValue] forKey:@"identifier"];
        
        return language;
    }
    
    return nil;
}

@end
