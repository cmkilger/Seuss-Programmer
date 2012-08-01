//
//  SSString.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/31/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SSCommand, SSParameter;

@interface SSString : NSManagedObject

@property (nonatomic) int16_t order;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) SSCommand *command;
@property (nonatomic, retain) SSParameter *parameter;

@end
