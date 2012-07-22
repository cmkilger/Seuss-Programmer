//
//  SSStatementView.m
//  Suess for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSStatementView.h"
#import "SSVariableView.h"

#define DEFAULT_VARIABLE_WIDTH 50.0
#define LEFT_PADDING 10.0
#define MIDDLE_PADDING 10.0
#define RIGHT_PADDING 10.0

#define FONT [UIFont fontWithName:@"DoctorSoosLight" size:24.0]

@interface SSStatementView ()

@property (readwrite) NSString * statement;
@property (strong) SSVariableView * variableView;

@end

@implementation SSStatementView

@synthesize statement = _statement;
@synthesize variableView = _variableView;

- (id)initWithStatement:(NSString *)statement {
    for (NSString * familyName in [UIFont familyNames])
        NSLog(@"%@: %@", familyName, [UIFont fontNamesForFamilyName:familyName]);
        
    CGSize size = [statement sizeWithFont:FONT];
    size.width += LEFT_PADDING + MIDDLE_PADDING + DEFAULT_VARIABLE_WIDTH + RIGHT_PADDING;
    size.height += 10;
    
    CGRect frame = CGRectZero;
    frame.size = size;
    
    self = [super initWithFrame:CGRectIntegral(frame)];
    if (self) {
        _statement = statement;
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *backgroundImg = nil;
        
        if ([statement isEqualToString:@"Write"]) 
        {
            backgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue_sm_btn.png"]];
        }
        else if ([statement isEqualToString:@"Read"]) {
            backgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green_btn_sm.png"]];
        }
        
        [self addSubview:backgroundImg];
        [self sendSubviewToBack:backgroundImg];    
        
        UIFont * font = FONT;        
        CGSize size = [statement sizeWithFont:font];
        CGRect frame = CGRectIntegral(CGRectMake(15, 20, size.width, size.height));                
        UILabel *theStatement = [[UILabel alloc] initWithFrame:frame];
        theStatement.font = font;
        theStatement.backgroundColor = [UIColor clearColor];
        theStatement.textColor = [UIColor whiteColor];
        theStatement.text = statement;
        [self addSubview:theStatement];
    }
    return self;
}

- (void)prepareForVariableView:(SSVariableView *)variableView atPoint:(CGPoint)point {
    [self.variableView removeFromSuperview];
    CGFloat variableWidth = CGRectGetWidth(variableView.bounds);
    CGRect statementFrame = self.frame;
    CGFloat statementWidth = [self.statement sizeWithFont:FONT].width;
    statementFrame.size.width = LEFT_PADDING + statementWidth + MIDDLE_PADDING + variableWidth + RIGHT_PADDING;
    self.frame = statementFrame;
}

- (void)addVariableView:(SSVariableView *)variableView atPoint:(CGPoint)point {
    [self addVariableView:variableView atIndex:0];
}

- (void)unprepare {
    [self addSubview:self.variableView];
    CGFloat variableWidth = (self.variableView) ? self.variableView.frame.size.width : DEFAULT_VARIABLE_WIDTH;
    CGRect statementFrame = self.frame;
    CGFloat statementWidth = [self.statement sizeWithFont:FONT].width;
    statementFrame.size.width = LEFT_PADDING + statementWidth + MIDDLE_PADDING + variableWidth + RIGHT_PADDING;
    self.frame = statementFrame; 
}

- (void)addVariableView:(SSVariableView *)variableView atIndex:(NSUInteger)index {
    [self.variableView removeFromSuperview];
    self.variableView = variableView;
    [self prepareForVariableView:variableView atPoint:CGPointZero];
    CGFloat statementWidth = [self.statement sizeWithFont:FONT].width;
    CGRect variableFrame = variableView.frame;
    variableFrame.origin.x = LEFT_PADDING + statementWidth + MIDDLE_PADDING;
    variableFrame.origin.y = 3;
    variableView.frame = variableFrame;
    [self addSubview:variableView];
}

@end
