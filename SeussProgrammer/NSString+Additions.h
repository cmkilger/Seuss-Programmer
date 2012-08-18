//
//  NSString+Additions.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/31/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Seuss/Seuss.h>

@interface NSString (Additions)

- (id)initWithWords:(SUList *)words;
- (id)initWithTokens:(SUList *)tokens;

@end
