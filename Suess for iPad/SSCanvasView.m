//
//  SSCanvas.m
//  Suess for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSCanvasView.h"
#import "SSStatementView.h"
#import "SSVariableView.h"

#import <QuartzCore/QuartzCore.h>

@interface SSCanvasView ()

@property (strong) NSMutableArray * commandViews;
@property (strong) NSMutableArray * variableViews;
@property (strong) NSMutableArray * statementViews;

@property (strong) SSStatementView * movingStatement;
@property (strong) SSVariableView * movingVariable;

@property (strong) UIScrollView * mainView;
@property (strong) UIScrollView * commandResevoir;
@property (strong) UIScrollView * variableResevoir;

@end

@implementation SSCanvasView

@synthesize commandViews = _commandViews;
@synthesize variableViews = _variableViews;
@synthesize statementViews = _statementViews;
@synthesize movingStatement = _movingStatement;
@synthesize movingVariable = _movingVariable;
@synthesize mainView = _mainView;
@synthesize commandResevoir = _commandResevoir;
@synthesize variableResevoir = _variableResevoir;

- (void)initialize {
    _commandViews = [[NSMutableArray alloc] init];
    _variableViews = [[NSMutableArray alloc] init];
    _statementViews = [[NSMutableArray alloc] init];
    
    CGFloat resevoirWidth = 320;
    
    CGRect mainViewFrame = self.bounds;
    mainViewFrame.size.width -= resevoirWidth;
    self.mainView = [[UIScrollView alloc] initWithFrame:mainViewFrame];
    self.mainView.backgroundColor = [UIColor colorWithRed:0.9 green:1.0 blue:0.9 alpha:1.0];
    [self addSubview:self.mainView];
    
    CGRect commandFrame = self.bounds;
    commandFrame.origin.x = commandFrame.size.width - resevoirWidth;
    commandFrame.size.width = resevoirWidth;
    commandFrame.size.height = floorf(commandFrame.size.height / 2);
    self.commandResevoir = [[UIScrollView alloc] initWithFrame:commandFrame];
    self.commandResevoir.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:1.0 alpha:1.0];
    [self addSubview:self.commandResevoir];
    
    commandFrame.origin.y = CGRectGetMaxY(commandFrame);
    commandFrame.size.height = CGRectGetMaxY(self.bounds) - commandFrame.origin.y;
    self.variableResevoir = [[UIScrollView alloc] initWithFrame:commandFrame];
    self.variableResevoir.backgroundColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.9 alpha:1.0];
    [self addSubview:self.variableResevoir];
}

- (void)awakeFromNib {
    [self initialize];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)addStatement:(NSString *)statement {
    SSStatementView * view = [[SSStatementView alloc] initWithStatement:statement];
    [view addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveStatement:)]];
    [view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveStatement:)]];
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOpacity = 0.6;
    view.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    view.layer.shadowRadius = 3.0;
    view.layer.cornerRadius = 3.0;
    [self.commandViews addObject:view];
    [self.commandResevoir addSubview:view];
    [self setNeedsLayout];
}

- (void)addVariable:(NSString *)variable {
    SSVariableView * view = [[SSVariableView alloc] initWithVariable:variable];
    [view addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveVariable:)]];
    [view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveVariable:)]];
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOpacity = 0.6;
    view.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    view.layer.shadowRadius = 3.0;
    view.layer.cornerRadius = 3.0;
    [self.variableViews addObject:view];
    [self.variableResevoir addSubview:view];
    [self setNeedsLayout];
}

- (void)moveStatement:(UIGestureRecognizer *)gesture {
    SSStatementView * view = (SSStatementView *)[gesture view];
    CGPoint point = [gesture locationInView:self];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (!self.movingStatement) {
                SSStatementView * movingView = view;
                if ([self.commandViews containsObject:movingView]) {
                    movingView = [[SSStatementView alloc] initWithStatement:view.statement];
                    [movingView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveStatement:)]];
                    [movingView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveStatement:)]];
                    movingView.layer.shadowColor = [[UIColor blackColor] CGColor];
                    movingView.layer.shadowOpacity = 0.6;
                    movingView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
                    movingView.layer.shadowRadius = 3.0;
                    movingView.layer.cornerRadius = 3.0;
                }
                else {
                    [self.statementViews removeObject:movingView];
                }
                movingView.center = point;
                [self addSubview:movingView];
                self.movingStatement = movingView;
                [UIView animateWithDuration:0.1 animations:^{
                    movingView.transform = CGAffineTransformMakeScale(1.25, 1.25);
                    movingView.alpha = 0.6;
                    movingView.layer.shadowOpacity = 0.1;
                }];
            }
        } break;
            
        case UIGestureRecognizerStateChanged: {
            self.movingStatement.center = point;
            [UIView animateWithDuration:0.1 animations:^{
                [self layoutStatements];
            }];
        } break;
            
        case UIGestureRecognizerStateEnded: {
            SSStatementView * movingView = self.movingStatement;
            self.movingStatement = nil;
            if (CGRectContainsPoint(self.mainView.frame, point)) {
                NSUInteger index = 0;
                for (SSStatementView * statementView in self.statementViews) {
                    if (CGRectGetMidY(statementView.frame) < movingView.center.y)
                        index++;
                    else
                        break;
                }
                [self.statementViews insertObject:movingView atIndex:index];
                [UIView animateWithDuration:0.1 animations:^{
                    movingView.transform = CGAffineTransformIdentity;
                    movingView.alpha = 1.0;
                    movingView.center = point;
                    movingView.layer.shadowOpacity = 0.6;
                    [self layoutStatements];
                }];
            }
            else {
                [UIView animateWithDuration:0.1 animations:^{
                    movingView.transform = CGAffineTransformMakeScale(3.0, 3.0);
                    movingView.alpha = 0.0;
                    movingView.center = point;
                } completion:^(BOOL finished) {
                    [self.movingStatement removeFromSuperview];
                }];
            }
        } break;
            
        default:
            break;
    }
}

- (void)moveVariable:(UIGestureRecognizer *)gesture {
    SSVariableView * view = (SSVariableView *)[gesture view];
    CGPoint point = [gesture locationInView:self];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (!self.movingVariable) {
                SSVariableView * movingView = view;
                if ([self.variableViews containsObject:movingView]) {
                    movingView = [[SSVariableView alloc] initWithVariable:view.variable];
                    [movingView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveVariable:)]];
                    [movingView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveVariable:)]];
                    movingView.layer.shadowColor = [[UIColor blackColor] CGColor];
                    movingView.layer.shadowOpacity = 0.6;
                    movingView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
                    movingView.layer.shadowRadius = 3.0;
                    movingView.layer.cornerRadius = 3.0;
                }
                else {
                    // TODO: remove from the statement
                }
                movingView.center = point;
                [self addSubview:movingView];
                self.movingVariable = movingView;
                [UIView animateWithDuration:0.1 animations:^{
                    movingView.transform = CGAffineTransformMakeScale(1.25, 1.25);
                    movingView.alpha = 0.6;
                    movingView.layer.shadowOpacity = 0.1;
                }];
            }
        } break;
            
        case UIGestureRecognizerStateChanged: {
            self.movingVariable.center = point;

            // TODO: unprepare any previously prepared view, prepare the new view if needed
            //SSStatementView * statementView = nil;
            for (SSStatementView * tmpStatementView in self.statementViews) {
                
                if (CGRectContainsPoint(tmpStatementView.frame, point)) 
                {
                    if (tmpStatementView.bounds.size.width < 200) //temp.bounds.size.width < CGRectGetWidth(self.movingVariable.bounds) + 5) {
                    { 
                        [tmpStatementView prepareForVariablView:self.movingVariable atPoint:[self convertPoint:point toView:tmpStatementView]];
                        
                        [UIView animateWithDuration:0.1 animations:^{
                            self.movingVariable.transform = CGAffineTransformIdentity;
                            self.movingVariable.alpha = 1.0;
                            self.movingVariable.center = point;
                            self.movingVariable.layer.shadowOpacity = 0.6;
                            //[self layoutStatements];
                        }];
                        
                        break;
                    }
                    else 
                    {
                        //CGFloat tempStatementHeight = CGRectGetHeight(tmpStatementView.bounds);
                        //CGRect statementThreshHold = tmpStatementView.frame;
                        //statementThreshHold.size.width += 60;
                        
                        if (!CGRectContainsRect(tmpStatementView.frame, self.movingVariable.frame)) 
                        {
                            [tmpStatementView unprepare];
                            break;                        
                        }
                    }                    
                }
            }
            
        } break;
            
        case UIGestureRecognizerStateEnded: {
            SSVariableView * movingView = self.movingVariable;
            self.movingVariable = nil;
            if (CGRectContainsPoint(self.mainView.frame, point)) {
                // TODO: Add the variable to the statement
                [UIView animateWithDuration:0.1 animations:^{
                    movingView.transform = CGAffineTransformIdentity;
                    movingView.alpha = 1.0;
                    movingView.center = point;
                    movingView.layer.shadowOpacity = 0.6;
                    [self layoutStatements];
                }];
            }
            else {
                [UIView animateWithDuration:0.1 animations:^{
                    movingView.transform = CGAffineTransformMakeScale(3.0, 3.0);
                    movingView.alpha = 0.0;
                    movingView.center = point;
                } completion:^(BOOL finished) {
                    [self.movingVariable removeFromSuperview];
                }];
            }
        } break;
            
        default:
            break;
    }
}

- (void)layoutStatements {
    CGFloat y = 20;
    SSStatementView * movingStatement = self.movingStatement;
    CGFloat movingY = movingStatement.center.y;
    CGFloat movingHeight = movingStatement.frame.size.height;
    for (SSStatementView * statementView in self.statementViews) {
        CGRect frame = statementView.frame;
        frame.origin.x = 20;
        frame.origin.y = y;
        y += 10 + frame.size.height;
        if (movingStatement && movingY < CGRectGetMidY(frame))
            frame.origin.y += movingHeight;
        statementView.frame = frame;
        NSLog(@"%@", statementView);
    }
}

- (void)layoutSubviews {
    CGFloat y = 20;
    for (UIView * statementView in self.commandViews) {
        CGRect frame = statementView.frame;
        frame.origin.x = 20;
        frame.origin.y = y;
        statementView.frame = frame;
        y += 10 + CGRectGetHeight(frame);
    }
    
    y = 20;
    for (UIView * statementView in self.variableViews) {
        CGRect frame = statementView.frame;
        frame.origin.x = 20;
        frame.origin.y = y;
        statementView.frame = frame;
        y += 10 + CGRectGetHeight(frame);
    }
    
    [self layoutStatements];
}

@end
