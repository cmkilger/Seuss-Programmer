//
//  SSStatementView.m
//  Suess for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSStatementView.h"
#import "SSVariableView.h"

@interface SSStatementView ()

@property (readwrite) NSString * statement;
@property (readwrite) CGSize originalStatementSize;

@end

@implementation SSStatementView

@synthesize statement = _statement;
@synthesize originalStatementSize = _originalStatementSize;

- (id)initWithStatement:(NSString *)statement {
//    for (NSString * familyName in [UIFont familyNames])
//        NSLog(@"%@: %@", familyName, [UIFont fontNamesForFamilyName:familyName]);
    
    CGSize size = [statement sizeWithFont:[UIFont fontWithName:@"CourierNewPS-BoldMT" size:24.0]];
    size.width += 20;
    size.height += 10;
    
    CGRect frame = CGRectZero;
    frame.size = size;
    _originalStatementSize = frame.size;
    
    self = [super initWithFrame:CGRectIntegral(frame)];
    if (self) {
        _statement = statement;
        self.backgroundColor = [UIColor blueColor];

        UIFont * font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:24.0];        
        CGSize size = [statement sizeWithFont:font];
        CGRect frame = CGRectIntegral(CGRectMake(10, 5, size.width, size.height));                
        UILabel *theStatement = [[UILabel alloc] initWithFrame:frame];
        theStatement.font = font;
        theStatement.backgroundColor = [UIColor clearColor];
        theStatement.textColor = [UIColor whiteColor];
        theStatement.text = statement;
        [self addSubview:theStatement];
        
    }
    return self;
}

//- (void)drawRect:(CGRect)rect {
//    NSString * statement = self.statement;
//    UIFont * font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:24.0];
//    CGSize size = [statement sizeWithFont:font];
//    CGRect frame = CGRectIntegral(CGRectMake(10, 5, size.width, size.height));
//    frame.origin.y -= 1;
//    [[UIColor blackColor] set];
//    [statement drawInRect:frame withFont:font];
//    frame.origin.y += 1;
//    [[UIColor whiteColor] set];
//    [statement drawInRect:frame withFont:font];
//}

- (void)prepareForVariablView:(SSVariableView *)variableView atPoint:(CGPoint)point 
{
    CGFloat variableWidth = CGRectGetWidth(variableView.bounds);
    CGRect statementFrarme = self.frame;
    statementFrarme.size.width += variableWidth;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = statementFrarme;
    } completion:^(BOOL finished) {
        NSLog(@"Animation complete!");
    }];    
}

- (void)addVariableView:(SSVariableView *)variableView atPoint:(CGPoint)point {
    
}

- (void)unprepare {
    CGFloat originalWidth = self.originalStatementSize.width;    
    CGRect statementFrarme = self.frame;
    statementFrarme.size.width = originalWidth;
    
    [UIView animateWithDuration:0.1 animations:^{
        //self.transform = CGAffineTransformMakeScale(3.0, 3.0);
        self.frame = statementFrarme;
    } completion:^(BOOL finished) {
        NSLog(@"Animation complete!");
    }];     
}

@end
