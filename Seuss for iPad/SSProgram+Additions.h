//
//  SSProgram+Additions.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/27/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSProgram.h"

@interface SSProgram (Additions)

+ (SSProgram *)programWithName:(NSString *)name data:(NSData *)data inContext:(NSManagedObjectContext *)context;
- (NSData *)data;

@end
