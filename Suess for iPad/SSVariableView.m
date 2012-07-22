//
//  SSVariableView.m
//  Suess for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSVariableView.h"

@interface SSVariableView ()

@property (readwrite) NSString * variable;

@end

@implementation SSVariableView

@synthesize variable = _variable;

- (id)initWithVariable:(NSString *)variable {
    //    for (NSString * familyName in [UIFont familyNames])
    //        NSLog(@"%@: %@", familyName, [UIFont fontNamesForFamilyName:familyName]);
    
    CGSize size = [variable sizeWithFont:[UIFont fontWithName:@"CourierNewPS-BoldMT" size:24.0]];
    size.width += 20;
    size.height += 5;
    
    CGRect frame = CGRectZero;
    frame.size = size;
    self = [super initWithFrame:CGRectIntegral(frame)];
    if (self) {
        _variable = variable;
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    NSString * variable = self.variable;
    UIFont * font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:24.0];
    CGSize size = [variable sizeWithFont:font];
    CGRect frame = CGRectIntegral(CGRectMake(10, 5, size.width, size.height));
    frame.origin.y -= 1;
    [[UIColor blackColor] set];
    [variable drawInRect:frame withFont:font];
    frame.origin.y += 1;
    [[UIColor whiteColor] set];
    [variable drawInRect:frame withFont:font];
}

@end
