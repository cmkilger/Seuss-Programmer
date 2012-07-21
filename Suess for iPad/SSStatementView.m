//
//  SSStatementView.m
//  Suess for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSStatementView.h"

@interface SSStatementView ()

@property (readwrite) NSString * statement;

@end

@implementation SSStatementView

@synthesize statement = _statement;

- (id)initWithStatement:(NSString *)statement {
//    for (NSString * familyName in [UIFont familyNames])
//        NSLog(@"%@: %@", familyName, [UIFont fontNamesForFamilyName:familyName]);
    
    CGSize size = [statement sizeWithFont:[UIFont fontWithName:@"CourierNewPS-BoldMT" size:24.0]];
    size.width += 20;
    size.height += 10;
    
    CGRect frame = CGRectZero;
    frame.size = size;
    self = [super initWithFrame:CGRectIntegral(frame)];
    if (self) {
        _statement = statement;
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    NSString * statement = self.statement;
    UIFont * font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:24.0];
    CGSize size = [statement sizeWithFont:font];
    CGRect frame = CGRectIntegral(CGRectMake(10, 5, size.width, size.height));
    frame.origin.y -= 1;
    [[UIColor blackColor] set];
    [statement drawInRect:frame withFont:font];
    frame.origin.y += 1;
    [[UIColor whiteColor] set];
    [statement drawInRect:frame withFont:font];
}

@end
