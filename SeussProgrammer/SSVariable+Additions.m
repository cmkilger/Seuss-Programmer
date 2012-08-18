//
//  SSVariable+Additions.m
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/31/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSVariable+Additions.h"
#import "NSManagedObject+Additions.h"
#import "SSString.h"

@implementation SSVariable (Additions)

- (id)initWithName:(NSString *)name inContext:(NSManagedObjectContext *)context {
    SSVariable * variable = [[SSVariable alloc] initWithManagedObjectContext:context];
    variable.name = name;
    return variable;
}

@end
