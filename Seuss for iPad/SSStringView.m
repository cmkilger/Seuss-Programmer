//
//  SSStringView.m
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/31/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSStringView.h"

#define SSStringViewFont() [UIFont fontWithName:@"DoctorSoosLight" size:28.0]

@interface SSStringView ()

@property (readwrite) NSString * string;

@end

@implementation SSStringView

@synthesize string = _string;

- (id)initWithString:(NSString *)string {
//    for (NSString * familyName in [UIFont familyNames])
//        NSLog(@"%@: %@", familyName, [UIFont fontNamesForFamilyName:familyName]);
    
    NSString * displayString = [self displayStringForString:string];
    
    UIFont * font = SSStringViewFont(); 
    CGSize size = [displayString sizeWithFont:font];
    CGRect frame = CGRectMake(0, 0, size.width+20, 47);
    self = [super initWithFrame:CGRectIntegral(frame)];
    if (self) {
        _string = string;
        self.backgroundColor = [UIColor clearColor];
        
        UIImage * backgroundImage = [[UIImage imageNamed:@"string_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        UIImageView * backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        backgroundImageView.frame = self.bounds;
        
        [self addSubview:backgroundImageView];
        [self sendSubviewToBack:backgroundImageView];
        
        CGRect frame = CGRectIntegral(CGRectMake(10, 8, size.width, size.height));
        UILabel * stringLabel = [[UILabel alloc] initWithFrame:frame];
        stringLabel.font = font;
        stringLabel.backgroundColor = [UIColor clearColor];
        stringLabel.textColor = [UIColor whiteColor];
        stringLabel.text = displayString;
        [self addSubview:stringLabel];
    }
    return self;
}

- (NSString *)displayStringForString:(NSString *)string {
    NSMutableString * displayString = [[NSMutableString alloc] initWithString:string];
    [displayString replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:0 range:NSMakeRange(0, [displayString length])];
    [displayString replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:0 range:NSMakeRange(0, [displayString length])];
    [displayString replaceOccurrencesOfString:@"\n" withString:@"\\n" options:0 range:NSMakeRange(0, [displayString length])];
    [displayString replaceOccurrencesOfString:@"\t" withString:@"\\t" options:0 range:NSMakeRange(0, [displayString length])];
    return [NSString stringWithFormat:@"\u201c%@\u201d", string];
}

@end
