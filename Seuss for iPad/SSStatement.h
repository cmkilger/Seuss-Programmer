//
//  SSStatement.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/31/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SSCommand, SSParameter, SSProgram;

@interface SSStatement : NSManagedObject

@property (nonatomic) int16_t line;
@property (nonatomic) int16_t order;
@property (nonatomic, retain) SSCommand *command;
@property (nonatomic, retain) NSSet *parameters;
@property (nonatomic, retain) SSProgram *program;
@end

@interface SSStatement (CoreDataGeneratedAccessors)

- (void)addParametersObject:(SSParameter *)value;
- (void)removeParametersObject:(SSParameter *)value;
- (void)addParameters:(NSSet *)values;
- (void)removeParameters:(NSSet *)values;

@end
