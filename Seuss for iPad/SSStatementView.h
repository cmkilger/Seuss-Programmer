//
//  SSStatementView.h
//  Suess for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSVariableView;

@interface SSStatementView : UIView

@property (readonly) NSString * statement;

- (id)initWithStatement:(NSString *)statement;
- (void)addVariableView:(SSVariableView *)variable atIndex:(NSUInteger)index;

- (void)prepareForVariableView:(SSVariableView *)variableView atPoint:(CGPoint)point;
- (void)addVariableView:(SSVariableView *)variableView atPoint:(CGPoint)point;
- (void)unprepare;

@end
