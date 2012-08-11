//
//  SSProgram+Additions.m
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/27/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSProgram+Additions.h"
#import "SSProgram.h"
#import "SSStatement.h"
#import "SSCommand.h"
#import "SSCommand+Additions.h"
#import "SSVariable.h"
#import "SSVariable+Additions.h"
#import "SSParameter.h"
#import "SSString.h"
#import "NSManagedObject+Additions.h"
#import "NSString+Additions.h"
#import <Seuss/Seuss.h>

@implementation SSProgram (Additions)

+ (SSProgram *)programWithName:(NSString *)name data:(NSData *)data inContext:(NSManagedObjectContext *)context {
    SSProgram * program = nil;
    
    SUString * file = SUStringCreate([name cStringUsingEncoding:NSUTF8StringEncoding]);
    SUList * tokens = SUTokenizeData([data bytes], [data length], file);
    SUList * errors = SUListCreate();
    SUProgram * suProgram = SUProgramCreate(tokens, errors);
    
    if (suProgram) {
        program = [[SSProgram alloc] initWithManagedObjectContext:context];
        
        NSMutableDictionary * commandCache = [[NSMutableDictionary alloc] init];
        NSMutableDictionary * variableCache = [[NSMutableDictionary alloc] init];
        
        // Parse functions
        SUList * functions = SUProgramGetFunctions(suProgram);
        SUListEnumerateWithBlock(functions, ^(SUTypeRef value, unsigned int index, int *stop) {
            SUFunction * function = value;
            SSCommand * command = [[SSCommand alloc] initWithFunction:function inContext:context];
            [program addCommandsObject:command];
            [commandCache setObject:command forKey:[NSString stringWithFormat:@"%x", (unsigned int)function]];
        });
        
        // Parse statements
        SUList * statements = SUProgramGetStatements(suProgram);
        SUListEnumerateWithBlock(statements, ^(SUTypeRef value, unsigned int index, int *stop) {
            SUStatement * suStatement = value;
            SUFunction * function = SUStatementGetFunction(suStatement);
            
            NSString * key = [NSString stringWithFormat:@"%x", (unsigned int)function];
            SSCommand * command = [commandCache objectForKey:key];
            if (!command) {
                command = [[SSCommand alloc] initWithFunction:function inContext:context];
                [program addCommandsObject:command];
                [commandCache setObject:command forKey:key];
            }
            
            SSStatement * statement = [[SSStatement alloc] initWithManagedObjectContext:context];
            statement.program = program;
            statement.command = command;
            statement.order = index;
            
            SUList * parameters = SUStatementGetParameters(suStatement);
            SUListEnumerateWithBlock(parameters, ^(SUTypeRef value, unsigned int index, int *stop) {
                SUTypeRef suParameter = value;
                
                SSParameter * parameter = [[SSParameter alloc] initWithManagedObjectContext:context];
                parameter.order = index;
                
                // Variable
                if (SUTypeIsVariable(suParameter)) {
                    NSString * name = [[NSString alloc] initWithTokens:SUVariableGetName(suParameter)];
                    SSVariable * variable = [variableCache objectForKey:name];
                    if (!variable) {
                        variable = [[SSVariable alloc] initWithName:name inContext:context];
                        [variableCache setObject:variable forKey:name];
                    }
                    parameter.variable = variable;
                    parameter.type = SSParameterTypeVariable;
                }
                
                // String
                else {
                    SSString * string = [[SSString alloc] initWithManagedObjectContext:context];
                    string.value = [NSString stringWithUTF8String:SUStringGetCString(suParameter)];
                    parameter.string = string;
                    parameter.type = SSParameterTypeString;
                }
                
                [statement addParametersObject:parameter];
            });
        });
    }
    
    SURelease(file);
    SURelease(tokens);
    SURelease(errors);
    SURelease(suProgram);
    
    return program;
}

- (NSData *)data {
    return nil;
}

@end
