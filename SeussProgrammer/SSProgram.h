//
//  SSProgram.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/31/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SSCommand, SSStatement;

@interface SSProgram : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *commands;
@property (nonatomic, retain) NSSet *statements;
@end

@interface SSProgram (CoreDataGeneratedAccessors)

- (void)addCommandsObject:(SSCommand *)value;
- (void)removeCommandsObject:(SSCommand *)value;
- (void)addCommands:(NSSet *)values;
- (void)removeCommands:(NSSet *)values;

- (void)addStatementsObject:(SSStatement *)value;
- (void)removeStatementsObject:(SSStatement *)value;
- (void)addStatements:(NSSet *)values;
- (void)removeStatements:(NSSet *)values;

@end
