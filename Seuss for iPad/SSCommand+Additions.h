//
//  SSCommand+Additions.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/28/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <Seuss/Seuss.h>
#import "SSCommand.h"

@interface SSCommand (Additions)

@property (readonly) NSString * signatureKey;

- (id)initWithFunction:(SUFunction *)function inContext:(NSManagedObjectContext *)context;

@end
