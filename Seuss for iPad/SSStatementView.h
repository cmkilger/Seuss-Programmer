//
//  SSStatementView.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSStatement;
@class SSCommand;

@interface SSStatementView : UIView

@property (strong, readonly) SSStatement * statement;

- (id)initWithCommand:(SSCommand *)command;
- (id)initWithStatement:(SSStatement *)statement;

- (void)addParameterGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;

- (void)prepareForParameterView:(UIView *)variableView atPoint:(CGPoint)point;
- (void)prepareForParameterView:(UIView *)variableView atIndex:(NSUInteger)index;
- (BOOL)addParameterView:(UIView *)variableView atPoint:(CGPoint)point;
- (BOOL)addParameterView:(UIView *)variableView atIndex:(NSUInteger)index;
- (void)unprepare;

@end
