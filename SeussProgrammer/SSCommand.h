//
//  SSCommand.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/31/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SSParameter, SSProgram, SSStatement, SSString;

@interface SSCommand : NSManagedObject

@property (nonatomic) BOOL builtin;
@property (nonatomic, retain) NSSet *parameters;
@property (nonatomic, retain) SSProgram *program;
@property (nonatomic, retain) NSSet *signature;
@property (nonatomic, retain) NSSet *statements;
@end

@interface SSCommand (CoreDataGeneratedAccessors)

- (void)addParametersObject:(SSParameter *)value;
- (void)removeParametersObject:(SSParameter *)value;
- (void)addParameters:(NSSet *)values;
- (void)removeParameters:(NSSet *)values;

- (void)addSignatureObject:(SSString *)value;
- (void)removeSignatureObject:(SSString *)value;
- (void)addSignature:(NSSet *)values;
- (void)removeSignature:(NSSet *)values;

- (void)addStatementsObject:(SSStatement *)value;
- (void)removeStatementsObject:(SSStatement *)value;
- (void)addStatements:(NSSet *)values;
- (void)removeStatements:(NSSet *)values;

@end
