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
    
    CGSize size = [variable sizeWithFont:[UIFont fontWithName:@"DoctorSoosLight" size:24.0]];
    size.width += 20;
    size.height = 47;
    
    CGRect frame = CGRectZero;
    frame.size = size;
    self = [super initWithFrame:CGRectIntegral(frame)];
    if (self) {
        _variable = variable;
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *backgroundImg = [[UIImage imageNamed:@"variable_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        UIImageView *backgroundImgView = [[UIImageView alloc] initWithImage:backgroundImg];
        backgroundImgView.frame = self.bounds;
        
        [self addSubview:backgroundImgView];
        [self sendSubviewToBack:backgroundImgView];    
        
        UIFont * font = [UIFont fontWithName:@"DoctorSoosLight" size:24.0];        
        CGSize size = [variable sizeWithFont:font];
        CGRect frame = CGRectIntegral(CGRectMake(10, 11, size.width, size.height));                
        UILabel *theVariable = [[UILabel alloc] initWithFrame:frame];
        theVariable.font = font;
        theVariable.backgroundColor = [UIColor clearColor];
        theVariable.textColor = [UIColor whiteColor];
        theVariable.text = variable;
        [self addSubview:theVariable];        
    }
    return self;
}

//- (void)drawRect:(CGRect)rect {
//    NSString * variable = self.variable;
//    UIFont * font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:24.0];
//    CGSize size = [variable sizeWithFont:font];
//    CGRect frame = CGRectIntegral(CGRectMake(10, 5, size.width, size.height));
//    frame.origin.y -= 1;
//    [[UIColor blackColor] set];
//    [variable drawInRect:frame withFont:font];
//    frame.origin.y += 1;
//    [[UIColor whiteColor] set];
//    [variable drawInRect:frame withFont:font];
//}

@end
