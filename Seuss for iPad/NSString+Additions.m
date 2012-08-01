//
//  NSString+Additions.m
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/31/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (id)initWithWords:(SUList *)words {
    NSMutableString * string = [[NSMutableString alloc] init];
    SUListEnumerateWithBlock(words, ^(SUTypeRef value, unsigned int index, int *stop) {
        SUString * word = value;
        if ([string length] > 0)
            [string appendString:@" "];
        [string appendString:[NSString stringWithCString:SUStringGetCString(word) encoding:NSUTF8StringEncoding]];
    });
    return string;
}

- (id)initWithTokens:(SUList *)tokens {
    NSMutableString * string = [[NSMutableString alloc] init];
    SUListEnumerateWithBlock(tokens, ^(SUTypeRef value, unsigned int index, int *stop) {
        SUToken * token = value;
        SUString * word = SUTokenGetValue(token);
        if ([string length] > 0)
            [string appendString:@" "];
        [string appendString:[NSString stringWithCString:SUStringGetCString(word) encoding:NSUTF8StringEncoding]];
    });
    return string;
}

@end
