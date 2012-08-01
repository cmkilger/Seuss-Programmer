//
//  SSParameter.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/31/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SSParameterType.h"

@class SSCommand, SSStatement, SSString, SSVariable;

@interface SSParameter : NSManagedObject

@property (nonatomic) int16_t order;
@property (nonatomic) SSParameterType type;
@property (nonatomic, retain) SSCommand *command;
@property (nonatomic, retain) SSStatement *statement;
@property (nonatomic, retain) SSVariable *variable;
@property (nonatomic, retain) SSString *string;

@end
