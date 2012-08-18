//
//  SSCanvas.m
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSCanvasView.h"
#import "SSCommandView.h"
#import "SSStatementView.h"
#import "SSVariableView.h"
#import "SSProgram.h"
#import "SSProgram+Additions.h"
#import "SSCommand.h"
#import "SSCommand+Additions.h"
#import "SSParameter.h"
#import "SSVariable.h"
#import "SSStatement.h"

#import <QuartzCore/QuartzCore.h>
#import <Seuss/Seuss.h>

@interface SSCanvasView ()

@property (strong) NSString * filePath;

@property (strong) NSMutableArray * commandViews;
@property (strong) NSMutableArray * variableViews;
@property (strong) NSMutableArray * statementViews;

@property (strong) SSStatementView * movingStatement;
@property (strong) UIView * movingParameter;

@property (strong) UIScrollView * mainView;
@property (strong) UIScrollView * commandResevoir;
@property (strong) UIScrollView * variableResevoir;

@property (strong) NSManagedObjectContext * context;

- (void)addCommand:(SSCommand *)command;
- (void)addVariable:(SSVariable *)statement;

@end

@implementation SSCanvasView

@synthesize filePath = _filePath;
@synthesize commandViews = _commandViews;
@synthesize variableViews = _variableViews;
@synthesize statementViews = _statementViews;
@synthesize movingStatement = _movingStatement;
@synthesize movingParameter = _movingVariable;
@synthesize mainView = _mainView;
@synthesize commandResevoir = _commandResevoir;
@synthesize variableResevoir = _variableResevoir;
@synthesize context = _context;
@synthesize program = _program;

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
    self.commandResevoir.backgroundColor = [UIColor clearColor];    
    [self addSubview:self.commandResevoir];
    
    commandFrame.origin.y = CGRectGetMaxY(commandFrame);
    commandFrame.size.height = CGRectGetMaxY(self.bounds) - commandFrame.origin.y;
    self.variableResevoir = [[UIScrollView alloc] initWithFrame:commandFrame];
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

- (void)addCommand:(SSCommand *)command {
    SSCommandView * view = [[SSCommandView alloc] initWithCommand:command];
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

- (void)addVariable:(SSVariable *)variable {
    SSVariableView * view = [[SSVariableView alloc] initWithVariable:variable];
    [view addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveParameter:)]];
    [view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveParameter:)]];
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
    UIView * view = (SSStatementView *)[gesture view];
    CGPoint point = [gesture locationInView:self.mainView];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (!self.movingStatement) {
                SSStatementView * movingView = nil;
                if ([view isMemberOfClass:[SSCommandView class]]) {
                    SSCommandView * commandView = (SSCommandView *)view;
                    movingView = [[SSStatementView alloc] initWithCommand:commandView.command];
                    [movingView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveStatement:)]];
                    [movingView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveStatement:)]];
                    movingView.layer.shadowColor = [[UIColor blackColor] CGColor];
                    movingView.layer.shadowOpacity = 0.6;
                    movingView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
                    movingView.layer.shadowRadius = 3.0;
                    movingView.layer.cornerRadius = 3.0;
                }
                else {
                    movingView = (SSStatementView *)view;
                    [self.statementViews removeObject:movingView];
                    [self updateProgram];
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
                [self updateProgram];
                [UIView animateWithDuration:0.1 animations:^{
                    movingView.transform = CGAffineTransformIdentity;
                    movingView.alpha = 1.0;
                    movingView.layer.shadowOpacity = 0.6;
                    [self layoutStatements];
                }];
            }
            else {
                NSManagedObjectContext * context = [self.program managedObjectContext];
                [context deleteObject:movingView.statement];
                [self updateProgram];
                [UIView animateWithDuration:0.1 animations:^{
                    movingView.transform = CGAffineTransformMakeScale(3.0, 3.0);
                    movingView.alpha = 0.0;
                    movingView.center = point;
                    [self layoutStatements];
                } completion:^(BOOL finished) {
                    [movingView removeFromSuperview];
                }];
            }
        } break;
            
        default:
            break;
    }
}

- (void)moveParameter:(UIGestureRecognizer *)gesture {
    UIView * view = [gesture view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (!self.movingParameter) {
                UIView * movingView = view;
                if ([self.variableViews containsObject:movingView]) {
                    CGPoint point = [gesture locationInView:self.mainView];
                    movingView = [[SSVariableView alloc] initWithVariable:[(SSVariableView *)view variable]];
                    [movingView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveParameter:)]];
                    [movingView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveParameter:)]];
                    movingView.layer.shadowColor = [[UIColor blackColor] CGColor];
                    movingView.layer.shadowOpacity = 0.6;
                    movingView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
                    movingView.layer.shadowRadius = 3.0;
                    movingView.layer.cornerRadius = 3.0;
                    movingView.center = point;
                    [self.mainView addSubview:movingView];
                }
                else {
                    SSStatementView * statementView = (SSStatementView *)[movingView superview];
                    [statementView removeParameterForView:movingView];
                    movingView.center = [gesture locationInView:statementView];
                    [[movingView superview] bringSubviewToFront:movingView];
                    [self.mainView bringSubviewToFront:statementView];
                    [self updateProgram];
                }
                self.movingParameter = movingView;
                [UIView animateWithDuration:0.1 animations:^{
                    movingView.transform = CGAffineTransformMakeScale(1.25, 1.25);
                    movingView.alpha = 0.6;
                    movingView.layer.shadowOpacity = 0.1;
                }];
            }
        } break;
            
        case UIGestureRecognizerStateChanged: {
            UIView * movingView = self.movingParameter;
            CGPoint point = [gesture locationInView:[movingView superview]];
            movingView.center = point;
            for (SSStatementView * statementView in self.statementViews) {
                if (CGRectContainsPoint(statementView.frame, [self.mainView convertPoint:point fromView:[movingView superview]])) {
                    CGPoint statementPoint = [[movingView superview] convertPoint:point toView:statementView];
                    [statementView prepareForParameterView:movingView atPoint:statementPoint animated:YES];
                }
                else {
                    [statementView unprepareAnimated:YES];
                }
            }
            [[movingView superview] bringSubviewToFront:movingView];
            
        } break;
            
        case UIGestureRecognizerStateEnded: {
            BOOL added = NO;
            UIView * movingView = self.movingParameter;
            self.movingParameter = nil;
            for (SSStatementView * statementView in self.statementViews) {
                CGPoint point = [gesture locationInView:self.mainView];
                if (CGRectContainsPoint(statementView.frame, point)) {
                    [self.mainView bringSubviewToFront:statementView];
                    added = [statementView addParameterView:movingView atPoint:[statementView convertPoint:point fromView:self.mainView]];
                    [self updateProgram];
                    break;
                }
            }
            if (!added) {
                [UIView animateWithDuration:0.2 animations:^{
                    movingView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [movingView removeFromSuperview];
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
        frame.origin.x = 40;
        frame.origin.y = y;
        statementView.frame = frame;
        y += 29 + CGRectGetHeight(frame);
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

- (void)addStatement:(SSStatement *)statement {
    SSStatementView * statementView = [[SSStatementView alloc] initWithStatement:statement];
    [statementView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveStatement:)]];
    [statementView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveStatement:)]];
    [statementView addParameterGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveParameter:)]];
    [statementView addParameterGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveParameter:)]];
    [self.statementViews addObject:statementView];
    [self.mainView addSubview:statementView];
}

- (void)reset {
    [self.statementViews removeAllObjects];
    [self.commandViews removeAllObjects];
    [self.variableViews removeAllObjects];
    for (UIView * subview in [self.mainView subviews])
        [subview removeFromSuperview];
    for (UIView * subview in [self.commandResevoir subviews])
        [subview removeFromSuperview];
    for (UIView * subview in [self.variableResevoir subviews])
        [subview removeFromSuperview];
}

- (void)updateProgram {
    SSProgram * program = self.program;
    program.statements = nil;
    [self.statementViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SSStatementView * statementView = obj;
        SSStatement * statement = statementView.statement;
        statement.program = program;
        statement.order = idx;
    }];
    
    NSError * error = nil;
    NSManagedObjectContext * context = [program managedObjectContext];
    [context save:&error];
    if (error) {
        NSLog(@"ERROR: %@", error);
    }
    
    [self saveFile];
}

- (void)loadFileAtPath:(NSString *)path {
    [self reset];
    
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel * model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    NSPersistentStoreCoordinator * coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    NSManagedObjectContext * context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSString * name = [[path lastPathComponent] stringByDeletingPathExtension];
    SSProgram * program = [SSProgram programWithName:name data:data inContext:context];
    
    NSSortDescriptor * signatureSort = [NSSortDescriptor sortDescriptorWithKey:@"signatureKey" ascending:YES];
    for (SSCommand * command in [program.commands sortedArrayUsingDescriptors:[NSArray arrayWithObject:signatureSort]])
        [self addCommand:command];
    
    NSSortDescriptor * orderSort = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    for (SSStatement * statement in [program.statements sortedArrayUsingDescriptors:[NSArray arrayWithObject:orderSort]])
        [self addStatement:statement];
    
    NSMutableDictionary * variableCache = [[NSMutableDictionary alloc] init];
    NSSet * parameters = [program.statements valueForKeyPath:@"@distinctUnionOfSets.parameters"];
    NSSortDescriptor * variableSort = [NSSortDescriptor sortDescriptorWithKey:@"variable.name" ascending:YES];
    for (SSParameter * parameter in [parameters sortedArrayUsingDescriptors:[NSArray arrayWithObject:variableSort]]) {
        if (parameter.variable) {
            SSVariable * variable = [variableCache objectForKey:parameter.variable.name];
            if (!variable) {
                variable = parameter.variable;
                [self addVariable:variable];
                [variableCache setObject:variable forKey:variable.name];
            }
        }
    }
    
    self.context = context;
    self.program = program;
    self.filePath = path;
    
    [self setNeedsLayout];
}

- (void)saveFile {
    [[self.program data] writeToFile:self.filePath atomically:YES];
}

@end
