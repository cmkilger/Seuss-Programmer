//
//  SSVariable.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/31/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SSParameter;

@interface SSVariable : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *parameters;
@end

@interface SSVariable (CoreDataGeneratedAccessors)

- (void)addParametersObject:(SSParameter *)value;
- (void)removeParametersObject:(SSParameter *)value;
- (void)addParameters:(NSSet *)values;
- (void)removeParameters:(NSSet *)values;

@end
