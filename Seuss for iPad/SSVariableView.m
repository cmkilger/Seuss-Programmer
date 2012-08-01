//
//  SSVariableView.m
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSVariableView.h"
#import "SSVariable.h"

@interface SSVariableView ()

@property (readwrite) SSVariable * variable;

@end

@implementation SSVariableView

@synthesize variable = _variable;

- (id)initWithVariable:(SSVariable *)variable {
//    for (NSString * familyName in [UIFont familyNames])
//        NSLog(@"%@: %@", familyName, [UIFont fontNamesForFamilyName:familyName]);
    
    UIFont * font = [UIFont fontWithName:@"DoctorSoosLight" size:28.0];
    
    CGSize size = [variable.name sizeWithFont:font];
    size.width += 20;
    size.height = 47;
    
    CGRect frame = CGRectZero;
    frame.size = size;
    self = [super initWithFrame:CGRectIntegral(frame)];
    if (self) {
        _variable = variable;
        self.backgroundColor = [UIColor clearColor];
        
        UIImage * backgroundImg = [[UIImage imageNamed:@"variable_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        UIImageView * backgroundImgView = [[UIImageView alloc] initWithImage:backgroundImg];
        backgroundImgView.frame = self.bounds;
        
        [self addSubview:backgroundImgView];
        [self sendSubviewToBack:backgroundImgView];
        
        CGSize size = [variable.name sizeWithFont:font];
        CGRect frame = CGRectIntegral(CGRectMake(10, 8, size.width, size.height));
        UILabel * variableLabel = [[UILabel alloc] initWithFrame:frame];
        variableLabel.font = font;
        variableLabel.backgroundColor = [UIColor clearColor];
        variableLabel.textColor = [UIColor whiteColor];
        variableLabel.text = variable.name;
        [self addSubview:variableLabel];
    }
    return self;
}

@end
