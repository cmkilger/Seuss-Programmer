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

@property (strong) NSMutableArray * statementViews;
@property (strong) NSMutableArray * variableViews;
@property (strong) UIView * movingView;

@property (strong) UIScrollView * mainView;
@property (strong) UIScrollView * commandResevoir;
@property (strong) UIScrollView * variableResevoir;

@end

@implementation SSCanvasView

@synthesize statementViews = _statementViews;
@synthesize variableViews = _variableViews;
@synthesize movingView = _movingView;
@synthesize mainView = _mainView;
@synthesize commandResevoir = _commandResevoir;
@synthesize variableResevoir = _variableResevoir;

- (void)initialize {
    _statementViews = [[NSMutableArray alloc] init];
    _variableViews = [[NSMutableArray alloc] init];
    
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
    [self.statementViews addObject:view];
    [self.commandResevoir addSubview:view];
    [self setNeedsLayout];
}

- (void)addVariable:(NSString *)statement {
    
}

- (void)moveStatement:(UIGestureRecognizer *)gesture {
    SSStatementView * view = (SSStatementView *)[gesture view];
    CGPoint point = [gesture locationInView:self];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (!self.movingView) {
                SSStatementView * movingView = view;
                if ([self.statementViews containsObject:movingView]) {
                    movingView = [[SSStatementView alloc] initWithStatement:view.statement];
                    [movingView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveStatement:)]];
                    [movingView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveStatement:)]];
                    movingView.layer.shadowColor = [[UIColor blackColor] CGColor];
                    movingView.layer.shadowOpacity = 0.6;
                    movingView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
                    movingView.layer.shadowRadius = 3.0;
                    movingView.layer.cornerRadius = 3.0;
                }
                movingView.center = point;
                [self addSubview:movingView];
                self.movingView = movingView;
                [UIView animateWithDuration:0.1 animations:^{
                    movingView.transform = CGAffineTransformMakeScale(1.25, 1.25);
                    movingView.alpha = 0.6;
                    movingView.layer.shadowOpacity = 0.1;
                }];
            }
        } break;
            
        case UIGestureRecognizerStateChanged: {
            self.movingView.center = point;
        } break;
            
        case UIGestureRecognizerStateEnded: {
            SSStatementView * movingView = (SSStatementView *)self.movingView;
            self.movingView = nil;
            [UIView animateWithDuration:0.1 animations:^{
                movingView.transform = CGAffineTransformIdentity;
                movingView.alpha = 1.0;
                movingView.center = point;
                movingView.layer.shadowOpacity = 0.6;
            }];
        } break;
            
        default:
            break;
    }
}

- (void)layoutSubviews {
    CGFloat y = 10;
    for (UIView * statementView in self.statementViews) {
        CGRect frame = statementView.frame;
        frame.origin.x = 5;
        frame.origin.y = y;
        statementView.frame = frame;
        y += 10 + CGRectGetHeight(frame);
    }
}

@end
