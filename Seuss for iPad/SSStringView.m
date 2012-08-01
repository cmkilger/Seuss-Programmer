//
//  SSStringView.m
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/31/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSStringView.h"

@interface SSStringView ()

@property (readwrite) NSString * string;

@end

@implementation SSStringView

@synthesize string = _string;

- (id)initWithString:(NSString *)string {
//    for (NSString * familyName in [UIFont familyNames])
//        NSLog(@"%@: %@", familyName, [UIFont fontNamesForFamilyName:familyName]);
    
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    string = [NSString stringWithFormat:@"\"%@\"", string];
    
    CGSize size = [string sizeWithFont:[UIFont fontWithName:@"DoctorSoosLight" size:28.0]];
    size.width += 20;
    size.height = 47;
    
    CGRect frame = CGRectZero;
    frame.size = size;
    self = [super initWithFrame:CGRectIntegral(frame)];
    if (self) {
        _string = string;
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *backgroundImg = [[UIImage imageNamed:@"string_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        UIImageView *backgroundImgView = [[UIImageView alloc] initWithImage:backgroundImg];
        backgroundImgView.frame = self.bounds;
        
        [self addSubview:backgroundImgView];
        [self sendSubviewToBack:backgroundImgView];
        
        UIFont * font = [UIFont fontWithName:@"DoctorSoosLight" size:28.0];
        CGSize size = [string sizeWithFont:font];
        CGRect frame = CGRectIntegral(CGRectMake(10, 8, size.width, size.height));
        UILabel *theVariable = [[UILabel alloc] initWithFrame:frame];
        theVariable.font = font;
        theVariable.backgroundColor = [UIColor clearColor];
        theVariable.textColor = [UIColor whiteColor];
        theVariable.text = string;
        [self addSubview:theVariable];
    }
    return self;
}

@end
