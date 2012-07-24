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
#import <Suess/Suess.h>

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
    
    UIImageView *backgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"workarea_bg_only.png"]];
    [self addSubview:backgroundImg];
    [self sendSubviewToBack:backgroundImg];
    
    CGRect commandFrame = self.bounds;
    commandFrame.origin.x = commandFrame.size.width - resevoirWidth;
    commandFrame.size.width = resevoirWidth;
    commandFrame.size.height = floorf(commandFrame.size.height / 2);
    self.commandResevoir = [[UIScrollView alloc] initWithFrame:commandFrame];
    //self.commandResevoir.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:1.0 alpha:1.0];
    self.commandResevoir.backgroundColor = [UIColor clearColor];    
    [self addSubview:self.commandResevoir];
    
    commandFrame.origin.y = CGRectGetMaxY(commandFrame);
    commandFrame.size.height = CGRectGetMaxY(self.bounds) - commandFrame.origin.y;
    self.variableResevoir = [[UIScrollView alloc] initWithFrame:commandFrame];
    //self.variableResevoir.backgroundColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.9 alpha:1.0];
    self.variableResevoir.backgroundColor = [UIColor clearColor];        
    [self addSubview:self.variableResevoir];
    
    CGRect mainViewFrame = self.bounds;
    mainViewFrame.size.width -= resevoirWidth;
    self.mainView = [[UIScrollView alloc] initWithFrame:mainViewFrame];
    self.mainView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.mainView];
    
    self.mainView.clipsToBounds = NO;
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
                [self.mainView addSubview:movingView];
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
            [UIView animateWithDuration:0.2 animations:^{
                for (SSStatementView * statementView in self.statementViews) {
                    if (CGRectContainsPoint(statementView.frame, point))
                        [statementView prepareForVariableView:self.movingVariable atPoint:[self convertPoint:point toView:statementView]];
                    else
                        [statementView unprepare];
                }
            }];
            
        } break;
            
        case UIGestureRecognizerStateEnded: {
            BOOL added = NO;
            SSVariableView * movingView = self.movingVariable;
            self.movingVariable = nil;
            movingView.alpha = 1.0;
            movingView.transform = CGAffineTransformIdentity;
            for (SSStatementView * statementView in self.statementViews) {
                if (CGRectContainsPoint(statementView.frame, point)) {
                    added = YES;
                    [statementView addVariableView:movingView atPoint:point];
                    break;
                }
            }
            if (!added) {
                [UIView animateWithDuration:0.1 animations:^{
                    movingView.alpha = 0.0;
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
        frame.origin.x = 30;
        frame.origin.y = y;
        y += frame.size.height;
        if (movingStatement && movingY < CGRectGetMidY(frame))
            frame.origin.y += movingHeight;
        statementView.frame = frame;
    }
    
    self.mainView.contentSize = CGSizeMake(self.mainView.bounds.size.width, y+20);
}

- (void)layoutSubviews {
    CGFloat y = 15;
    for (UIView * statementView in self.commandViews) {
        CGRect frame = statementView.frame;
        frame.origin.x = 60;
        frame.origin.y = y;
        statementView.frame = frame;
        y += 50 + CGRectGetHeight(frame);
    }
    self.commandResevoir.contentSize = CGSizeMake(self.commandResevoir.bounds.size.width, y+20);
    
    y = 30;
    for (UIView * statementView in self.variableViews) {
        CGRect frame = statementView.frame;
        frame.origin.x = 60;
        frame.origin.y = y;
        statementView.frame = frame;
        y += 10 + CGRectGetHeight(frame);
    }
    self.variableResevoir.contentSize = CGSizeMake(self.variableResevoir.bounds.size.width, y+20);
    
    [self layoutStatements];
}

#pragma mark - Loading

- (void)addStatement:(NSString *)name withVariable:(NSString *)parameter {
    SSStatementView * statement = [[SSStatementView alloc] initWithStatement:name];
    
    [statement addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveStatement:)]];
    [statement addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveStatement:)]];
    
    [self.statementViews addObject:statement];
    
    [self.mainView addSubview:statement];
    
    SSVariableView * variable = [[SSVariableView alloc] initWithVariable:parameter];
    [statement addVariableView:variable atIndex:0];
}

- (void)loadFileAtPath:(NSString *)path {
    [self.statementViews removeAllObjects];
    [self.commandViews removeAllObjects];
    [self.variableViews removeAllObjects];
    for (UIView * subview in [self.mainView subviews])
        [subview removeFromSuperview];
    for (UIView * subview in [self.commandResevoir subviews])
        [subview removeFromSuperview];
    for (UIView * subview in [self.variableResevoir subviews])
        [subview removeFromSuperview];
    
    [self addStatement:@"Write"];
    [self addStatement:@"Read"];
    [self addVariable:@"new line"];
    
    SUString * file = SUStringCreate([path cStringUsingEncoding:NSUTF8StringEncoding]);
    SUList * tokens = SUTokenizeFile(file);
    SUList * errors = SUListCreate();
    SUProgram * program = SUProgramCreate(tokens, errors);
    
    SUList * statements = SUProgramGetStatements(program);
    SUIterator * statementIterator = SUListCreateIterator(statements);
    SUStatement * statement = NULL;
    while ((statement = SUIteratorNext(statementIterator))) {
        SUList * signature = SUFunctionGetSignature(SUStatementGetFunction(statement));
        SUList * words = SUListGetValueAtIndex(signature, 0);
        SUString * name = SUListGetValueAtIndex(words, 0);
        NSString * nameString = [NSString stringWithCString:SUStringGetCString(name) encoding:NSUTF8StringEncoding];
        
        SUList * parameters = SUStatementGetParameters(statement);
        SUTypeRef parameter = SUListGetValueAtIndex(parameters, 0);
        NSString * parameterString = nil;
        if (SUTypeIsVariable(parameter)) {
            SUList * name = SUVariableGetName((SUVariable*)parameter);
            NSMutableString * string = [NSMutableString string];
            SUToken * word = NULL;
            SUIterator * wordIterator = SUListCreateIterator(name);
            while ((word = SUIteratorNext(wordIterator))) {
                if ([string length] > 0)
                    [string appendString:@" "];
                [string appendString:[NSString stringWithCString:SUStringGetCString(SUTokenGetValue(word)) encoding:NSUTF8StringEncoding]];
            }
            SURelease(wordIterator);
            parameterString = string;
        }
        else {
            parameterString = [NSString stringWithUTF8String:SUStringGetCString(parameter)];
        }
        
        [self addStatement:nameString withVariable:parameterString];
    }
    
    SUList * functions = SUProgramGetFunctions(program);
    SUIterator * functionIterator = SUListCreateIterator(functions);
    SUFunction * function = NULL;
    while ((function = SUIteratorNext(functionIterator))) {
        SUList * signature = SUFunctionGetSignature(function);
        SUList * words = SUListGetValueAtIndex(signature, 0);
        SUString * name = SUListGetValueAtIndex(words, 0);
        NSString * nameString = [NSString stringWithUTF8String:SUStringGetCString(name)];
        if (!([nameString isEqualToString:@"Write"] || [nameString isEqualToString:@"Read"]))
            [self addStatement:nameString];
    }
    
    SUList * variables = SUProgramGetVariables(program);
    SUIterator * variableIterator = SUListCreateIterator(variables);
    SUVariable * variable = NULL;
    while ((variable = SUIteratorNext(variableIterator))) {
        NSMutableString * nameString = [[NSMutableString alloc] init];
        SUList * signature = SUVariableGetName(variable);
        SUIterator * signatureIterator = SUListCreateIterator(signature);
        SUToken * token = NULL;
        while ((token = SUIteratorNext(signatureIterator))) {
            SUString * name = SUTokenGetValue(token);
            if ([nameString length] > 0)
                [nameString appendString:@" "];
            [nameString appendString:[NSString stringWithUTF8String:SUStringGetCString(name)]];
        }
        if (![nameString isEqualToString:@"new line"])
            [self addVariable:nameString];
        SURelease(signatureIterator);
    }
    
    SURelease(functionIterator);
    SURelease(statementIterator);
    SURelease(file);
    SURelease(tokens);
    SURelease(errors);
    SURelease(program);
    
    [self setNeedsLayout];
}

@end
