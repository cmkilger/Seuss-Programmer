//
//  SSStatementView.m
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSStatementView.h"
#import "SSVariableView.h"
#import "SSStringView.h"
#import "SSStatement.h"
#import "SSCommand.h"
#import "SSCommand+Additions.h"
#import "NSManagedObject+Additions.h"
#import "SSString.h"
#import "SSParameter.h"
#import "SSVariable.h"

#define DEFAULT_HEIGHT 60.0

#define DEFAULT_VARIABLE_WIDTH 100.0
#define LEFT_PADDING 15.0
#define MIDDLE_PADDING 8.0
#define RIGHT_PADDING 15.0

#define PARAMETER_VERTICAL_PADDING 8.0

#define SIGNATURE_BASE_INDEX 1000
#define PARAMETER_BASE_INDEX 2000
#define PARAMETER_BACK_BASE_INDEX 3000
#define PARAMETER_FRONT_BASE_INDEX 4000

#define SSStatementFont() [UIFont fontWithName:@"DoctorSoosLight" size:28.0]

@interface SSStatementView ()

@property (strong, readwrite) SSStatement * statement;
@property (strong) SSParameter * previousParameter;

- (UILabel *)signatureLabelAtIndex:(NSUInteger)index;
- (UIView *)parameterViewAtIndex:(NSUInteger)index;

@end

@implementation SSStatementView

@synthesize statement = _statement;
@synthesize previousParameter = _previousParameter;

- (id)initWithCommand:(SSCommand *)command {
    NSManagedObjectContext * context = [command managedObjectContext];
    SSStatement * statement = [[SSStatement alloc] initWithManagedObjectContext:context];
    statement.command = command;
    return [self initWithStatement:statement];
}

- (id)initWithStatement:(SSStatement *)statement {
    self = [super initWithFrame:CGRectMake(0, 0, DEFAULT_VARIABLE_WIDTH, DEFAULT_HEIGHT)];
    if (self) {
        self.statement = statement;
        self.backgroundColor = [UIColor clearColor];
        
        // Select background image
        UIImage * backgroundImage = nil;
        if ([statement.command.signatureKey caseInsensitiveCompare:@"Write"] == NSOrderedSame)
            backgroundImage = [UIImage imageNamed:@"blue_sm_btn.png"];
        else if ([statement.command.signatureKey caseInsensitiveCompare:@"Read"] == NSOrderedSame)
            backgroundImage = [UIImage imageNamed:@"green_btn_sm.png"];
        backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 12)];
        UIImageView * backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        backgroundImageView.frame = self.bounds;
        [self addSubview:backgroundImageView];
        
        [self updateLayout];
    }
    return self;
}

- (void)addParameterGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    NSUInteger count = [self.statement.command.signature count];
    for (int i = 0; i < count; i++) {
        UIView * view = [self parameterViewAtIndex:i];
        [view addGestureRecognizer:gestureRecognizer];
    }
}

- (UILabel *)signatureLabelAtIndex:(NSUInteger)index {
    UILabel * label = (UILabel *)[self viewWithTag:SIGNATURE_BASE_INDEX+index];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:self.bounds];
        label.font = SSStatementFont();
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.tag = SIGNATURE_BASE_INDEX+index;
        [self addSubview:label];
    }
    return label;
}

- (UIView *)parameterViewAtIndex:(NSUInteger)index {
    return [self viewWithTag:PARAMETER_BASE_INDEX+index];
}

- (void)prepareForParameterView:(SSVariableView *)variableView atPoint:(CGPoint)point {
    CGFloat width = LEFT_PADDING;
    CGFloat variableWidth = CGRectGetWidth(variableView.frame);
    NSUInteger count = [self.statement.command.signature count];
    for (NSUInteger i = 0; i < count; i++) {
        UILabel * signatureLabel = [self signatureLabelAtIndex:i];
        width += CGRectGetWidth(signatureLabel.frame) + MIDDLE_PADDING;
        
        if (point.x >= width && point.x <= width + variableWidth) {
            [self prepareForParameterView:variableView atIndex:i];
            return;
        }
        
        CGFloat parameterWidth = DEFAULT_VARIABLE_WIDTH;
        UIView * parameterView = [self parameterViewAtIndex:i];
        if (parameterView)
            parameterWidth = CGRectGetWidth(parameterView.frame);
        width += DEFAULT_VARIABLE_WIDTH + MIDDLE_PADDING;
    }
    [self unprepare];
}

- (void)prepareForParameterView:(UIView *)parameterView atIndex:(NSUInteger)index {
    if (!self.previousParameter) {
        NSManagedObjectContext * context = self.statement.managedObjectContext;
        
        self.previousParameter.statement = self.statement;
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"order = %d", index];
        SSParameter * previousParameter = [[self.statement.parameters filteredSetUsingPredicate:predicate] anyObject];
        previousParameter.statement = nil;
        self.previousParameter = previousParameter;
        
        SSParameter * newParameter = [[SSParameter alloc] initWithManagedObjectContext:context];
        newParameter.order = previousParameter.order;
        newParameter.statement = self.statement;
        
        if ([parameterView isKindOfClass:[SSVariableView class]]) {
            SSVariableView * variableView = (SSVariableView *)parameterView;
            newParameter.variable = variableView.variable;
            newParameter.type = SSParameterTypeVariable;
        }
        else if ([parameterView isKindOfClass:[SSStringView class]]) {
            SSStringView * stringView = (SSStringView *)parameterView;
            SSString * string = [[SSString alloc] initWithManagedObjectContext:context];
            string.value = stringView.string;
            newParameter.string = string;
            newParameter.type = SSParameterTypeString;
        }
                
        [self updateLayoutWithPreparedWidth:CGRectGetWidth(parameterView.frame) atIndex:index];
    }
}

- (BOOL)addParameterView:(UIView *)variableView atPoint:(CGPoint)point {
    CGFloat width = LEFT_PADDING;
    CGFloat variableWidth = CGRectGetWidth(variableView.frame);
    NSUInteger count = [self.statement.command.signature count];
    for (NSUInteger i = 0; i < count; i++) {
        UILabel * signatureLabel = [self signatureLabelAtIndex:i];
        width += CGRectGetWidth(signatureLabel.frame) + MIDDLE_PADDING;
        
        if (point.x >= width && point.x <= width + variableWidth) {
            return [self addParameterView:variableView atIndex:i];
        }
        
        CGFloat parameterWidth = DEFAULT_VARIABLE_WIDTH;
        UIView * parameterView = [self parameterViewAtIndex:i];
        if (parameterView)
            parameterWidth = CGRectGetWidth(parameterView.frame);
        width += DEFAULT_VARIABLE_WIDTH + MIDDLE_PADDING;
    }

    return NO;
}

- (BOOL)addParameterView:(UIView *)parameterView atIndex:(NSUInteger)index {
    NSManagedObjectContext * context = self.statement.managedObjectContext;
    
    self.previousParameter = nil;
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"order = %d", index];
    SSParameter * previousParameter = [[self.statement.parameters filteredSetUsingPredicate:predicate] anyObject];
    previousParameter.statement = nil;
    
    SSParameter * newParameter = [[SSParameter alloc] initWithManagedObjectContext:context];
    newParameter.order = previousParameter.order;
    newParameter.statement = self.statement;
    
    if ([parameterView isKindOfClass:[SSVariableView class]]) {
        SSVariableView * variableView = (SSVariableView *)parameterView;
        newParameter.variable = variableView.variable;
        newParameter.type = SSParameterTypeVariable;
    }
    else if ([parameterView isKindOfClass:[SSStringView class]]) {
        SSStringView * stringView = (SSStringView *)parameterView;
        SSString * string = [[SSString alloc] initWithManagedObjectContext:context];
        string.value = stringView.string;
        newParameter.string = string;
        newParameter.type = SSParameterTypeString;
    }
    
    [[self viewWithTag:PARAMETER_BASE_INDEX + index] removeFromSuperview];
    parameterView.tag = PARAMETER_BASE_INDEX + index;
    [self addSubview:parameterView];
    
    [self updateLayout];
    
    return YES;
}

- (void)unprepare {
    if (self.previousParameter) {
        // TODO: Delete temporary objects
//        NSManagedObjectContext * context = self.statement.managedObjectContext;
        int16_t order = self.previousParameter.order;
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"order = %d", order];
        SSParameter * newParameter = [[self.statement.parameters filteredSetUsingPredicate:predicate] anyObject];
        newParameter.statement = nil;
        self.previousParameter.statement = self.statement;
//        [context deleteObject:newParameter.string];
//        [context deleteObject:newParameter];
        self.previousParameter = nil;
        [self updateLayout];
    }
}

- (void)updateLayout {
    [self updateLayoutWithPreparedWidth:0 atIndex:NSUIntegerMax];
}

- (void)updateLayoutWithPreparedWidth:(CGFloat)preparedWidth atIndex:(NSUInteger)preparedIndex {
    // Select background image
    UIImage * slitBack = [[UIImage imageNamed:@"slit_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 17, 0, 16)];
    UIImage * slitFront = nil;
    if ([self.statement.command.signatureKey caseInsensitiveCompare:@"Write"] == NSOrderedSame)
        slitFront = [UIImage imageNamed:@"slit_front_blue.png"];
    else if ([self.statement.command.signatureKey caseInsensitiveCompare:@"Read"] == NSOrderedSame)
        slitFront = [UIImage imageNamed:@"slit_front_green.png"];
    slitFront = [slitFront resizableImageWithCapInsets:UIEdgeInsetsMake(0, 17, 0, 16)];
    
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray * signature = [self.statement.command.signature sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    NSArray * parameters = [self.statement.parameters sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    UIFont * font = SSStatementFont();
    CGFloat x = LEFT_PADDING;
    NSUInteger index = 0;
    NSUInteger parameterIndex = 0;
    for (SSString * string in signature) {
        NSString * value = string.value;
        UILabel * label = [self signatureLabelAtIndex:index];
        CGFloat width = ceilf([value sizeWithFont:font].width);
        label.frame = CGRectMake(x, PARAMETER_VERTICAL_PADDING, width, DEFAULT_HEIGHT - PARAMETER_VERTICAL_PADDING);
        label.text = value;
        [self addSubview:label];
        x += width + MIDDLE_PADDING;
        
        UIImageView * backSlitView = (UIImageView *)[self viewWithTag:PARAMETER_BACK_BASE_INDEX + index];
        if (!backSlitView) {
            backSlitView = [[UIImageView alloc] initWithImage:slitBack];
            backSlitView.tag = PARAMETER_BACK_BASE_INDEX + index;
        }
        UIImageView * frontSlitView = (UIImageView *)[self viewWithTag:PARAMETER_FRONT_BASE_INDEX + index];
        if (!frontSlitView) {
            frontSlitView = [[UIImageView alloc] initWithImage:slitFront];
            frontSlitView.tag = PARAMETER_FRONT_BASE_INDEX + index;
        }
        [self addSubview:backSlitView];
        
        SSParameter * parameter = nil;
        UIView * parameterView = [self parameterViewAtIndex:index];
        
        if (index == preparedIndex) {
            if (parameterIndex < [parameters count] && (parameter = [parameters objectAtIndex:parameterIndex]) && parameter.order == index)
                parameterIndex++;
            backSlitView.frame = CGRectMake(x - 5, 15, preparedWidth + 10, CGRectGetHeight(backSlitView.frame));
            frontSlitView.frame = CGRectMake(x - 5, 45, preparedWidth + 10, CGRectGetHeight(frontSlitView.frame));
            parameterView.hidden = YES;
            x += preparedWidth + MIDDLE_PADDING;
        }
        else if (parameterIndex < [parameters count] && (parameter = [parameters objectAtIndex:parameterIndex]) && parameter.order == index) {
            parameterIndex++;
            
            if (!parameterView) {
                switch (parameter.type) {
                    case SSParameterTypeVariable: {
                        parameterView = [[SSVariableView alloc] initWithVariable:parameter.variable];
                    } break;
                        
                    case SSParameterTypeString: {
                        parameterView = [[SSStringView alloc] initWithString:parameter.string.value];
                    } break;
                        
                    default:
                        break;
                }
                
                parameterView.tag = PARAMETER_BASE_INDEX + index;
            }
            
            CGRect parameterFrame = parameterView.frame;
            parameterFrame.origin.x = x;
            parameterFrame.origin.y = PARAMETER_VERTICAL_PADDING;
            parameterView.frame = parameterFrame;
            parameterView.hidden = NO;
            
            backSlitView.frame = CGRectMake(x - 5, 15, CGRectGetWidth(parameterFrame) + 10, CGRectGetHeight(backSlitView.frame));
            frontSlitView.frame = CGRectMake(x - 5, 45, CGRectGetWidth(parameterFrame) + 10, CGRectGetHeight(frontSlitView.frame));
            
            [self addSubview:parameterView];
            
            x += CGRectGetWidth(parameterFrame) + MIDDLE_PADDING;
        }
        else {
            [parameterView removeFromSuperview];
            backSlitView.frame = CGRectMake(x - 5, 15, DEFAULT_VARIABLE_WIDTH + 10, CGRectGetHeight(backSlitView.frame));
            frontSlitView.frame = CGRectMake(x - 5, 45, DEFAULT_VARIABLE_WIDTH + 10, CGRectGetHeight(frontSlitView.frame));
            x += DEFAULT_VARIABLE_WIDTH + MIDDLE_PADDING;
        }
        
        [self addSubview:frontSlitView];
        
        index++;
    }
    
    static NSString * periodString = @".";
    CGFloat periodWidth = [periodString sizeWithFont:font].width;
    UILabel * periodLabel = [self signatureLabelAtIndex:index];
    periodLabel.frame = CGRectMake(x, PARAMETER_VERTICAL_PADDING, periodWidth, DEFAULT_HEIGHT - PARAMETER_VERTICAL_PADDING);
    periodLabel.text = periodString;
    
    x += periodWidth + RIGHT_PADDING;
    
    CGRect frame = self.frame;
    frame.size.width = x;
    frame.size.height = DEFAULT_HEIGHT;
    self.frame = frame;
    
    [self addSubview:periodLabel];
}

@end
