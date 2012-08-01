//
//  NSManagedObject+Additions.m
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/28/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "NSManagedObject+Additions.h"

@implementation NSManagedObject (Additions)

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    NSString * entityName = NSStringFromClass([self class]);
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    return [self initWithEntity:entity insertIntoManagedObjectContext:context];
}

@end
