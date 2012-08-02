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
#define MIDDLE_PADDING 4.0
#define RIGHT_PADDING 15.0

#define PARAMETER_VERTICAL_PADDING 8.0

#define SIGNATURE_BASE_INDEX 1000
#define PARAMETER_BASE_INDEX 2000

#define SSStatementFont() [UIFont fontWithName:@"DoctorSoosLight" size:28.0]

@interface SSStatementView ()

@property (strong, readwrite) SSStatement * statement;
@property (strong) UIView * parameterView;

- (UILabel *)signatureLabelAtIndex:(NSUInteger)index;
- (UIView *)parameterViewAtIndex:(NSUInteger)index;

@end

@implementation SSStatementView

@synthesize statement = _statement;
@synthesize parameterView = _variableView;

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
        
        NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        NSArray * signature = [statement.command.signature sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        NSArray * parameters = [statement.parameters sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        
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
            
            if (parameterIndex < [parameters count]) {
                SSParameter * parameter = [parameters objectAtIndex:parameterIndex];
                if (parameter && parameter.order == index) {
                    parameterIndex++;
                    
                    UIView * parameterView = nil;
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
                    
                    CGRect parameterFrame = parameterView.frame;
                    parameterFrame.origin.x = x;
                    parameterFrame.origin.y = PARAMETER_VERTICAL_PADDING;
                    parameterView.frame = parameterFrame;
                    [self addSubview:parameterView];
                    
                    x += CGRectGetWidth(parameterFrame) + MIDDLE_PADDING;
                }
                else {
                    x += DEFAULT_VARIABLE_WIDTH + MIDDLE_PADDING;
                }
            }
            else {
                x += DEFAULT_VARIABLE_WIDTH + MIDDLE_PADDING;
            }
            
            index++;
        }
        
        CGFloat periodWidth = [@"." sizeWithFont:font].width;
        UILabel * periodLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, PARAMETER_VERTICAL_PADDING, periodWidth, DEFAULT_HEIGHT - PARAMETER_VERTICAL_PADDING)];
        periodLabel.text = @".";
        periodLabel.font = font;
        periodLabel.backgroundColor = [UIColor clearColor];
        periodLabel.textColor = [UIColor whiteColor];
        periodLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        x += periodWidth + RIGHT_PADDING;
        
        self.frame = CGRectMake(0, 0, x, DEFAULT_HEIGHT);
        
        [self addSubview:periodLabel];
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
        CGRect signatureFrame = signatureLabel.frame;
        signatureFrame.origin.x = width;
        signatureLabel.frame = signatureFrame;
        width += CGRectGetWidth(signatureFrame) + MIDDLE_PADDING;
        
        UIView * parameterView = [self parameterViewAtIndex:i];
        if (point.x >= width && point.x <= width + variableWidth) {
            parameterView.hidden = YES;
            width += variableWidth + MIDDLE_PADDING;
        }
        else {
            CGFloat parameterWidth = DEFAULT_VARIABLE_WIDTH;
            if (parameterView) {
                CGRect parameterFrame = parameterView.frame;
                parameterFrame.origin.x = width;
                parameterView.frame = parameterFrame;
                parameterWidth = CGRectGetWidth(parameterFrame);
                parameterView.hidden = NO;
            }
            width += parameterWidth + MIDDLE_PADDING;
        }
    }
    
    CGFloat periodWidth = [@"." sizeWithFont:SSStatementFont()].width;
    width += periodWidth + RIGHT_PADDING;
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (BOOL)addParameterView:(UIView *)newParameterView atPoint:(CGPoint)point {
    CGFloat width = LEFT_PADDING;
    CGFloat newParameterWidth = CGRectGetWidth(newParameterView.frame);
    NSUInteger count = [self.statement.command.signature count];
    
    BOOL added = NO;
    
    for (NSUInteger i = 0; i < count; i++) {
        UILabel * signatureLabel = [self signatureLabelAtIndex:i];
        CGRect signatureFrame = signatureLabel.frame;
        signatureFrame.origin.x = width;
        signatureLabel.frame = signatureFrame;
        width += CGRectGetWidth(signatureFrame) + MIDDLE_PADDING;
        
        UIView * parameterView = [self parameterViewAtIndex:i];
        if (point.x >= width && point.x <= width + newParameterWidth) {
            if (parameterView)
                [parameterView removeFromSuperview];
            newParameterView.tag = PARAMETER_BASE_INDEX + i;
            CGRect parameterFrame = newParameterView.frame;
            parameterFrame.origin.x = width;
            parameterFrame.origin.y = PARAMETER_VERTICAL_PADDING;
            newParameterView.frame = parameterFrame;
            width += newParameterWidth + MIDDLE_PADDING;
            [self addSubview:newParameterView];
            added = YES;
        }
        else {
            CGFloat parameterWidth = DEFAULT_VARIABLE_WIDTH;
            if (parameterView) {
                CGRect parameterFrame = parameterView.frame;
                parameterFrame.origin.x = width;
                parameterView.frame = parameterFrame;
                parameterWidth = CGRectGetWidth(parameterFrame);
                parameterView.hidden = NO;
            }
            width += parameterWidth + MIDDLE_PADDING;
        }
    }
    
    CGFloat periodWidth = [@"." sizeWithFont:SSStatementFont()].width;
    width += periodWidth + RIGHT_PADDING;
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    
    return added;
}

- (void)unprepare {
    CGFloat width = LEFT_PADDING;
    NSUInteger count = [self.statement.command.signature count];
    for (NSUInteger i = 0; i < count; i++) {
        UILabel * signatureLabel = [self signatureLabelAtIndex:i];
        CGRect signatureFrame = signatureLabel.frame;
        signatureFrame.origin.x = width;
        signatureLabel.frame = signatureFrame;
        width += CGRectGetWidth(signatureFrame) + MIDDLE_PADDING;
        
        UIView * parameterView = [self parameterViewAtIndex:i];
        CGFloat parameterWidth = DEFAULT_VARIABLE_WIDTH;
        if (parameterView) {
            CGRect parameterFrame = parameterView.frame;
            parameterFrame.origin.x = width;
            parameterView.frame = parameterFrame;
            parameterWidth = CGRectGetWidth(parameterFrame);
            parameterView.hidden = NO;
        }
        width += parameterWidth + MIDDLE_PADDING;
    }
    
    CGFloat periodWidth = [@"." sizeWithFont:SSStatementFont()].width;
    width += periodWidth + RIGHT_PADDING;
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

@end
