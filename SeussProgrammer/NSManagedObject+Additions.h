//
//  NSManagedObject+Additions.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/28/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Additions)

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
