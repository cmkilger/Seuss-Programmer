//
//  SSCommandView.m
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/30/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSCommandView.h"
#import "SSVariableView.h"
#import "SSCommand.h"
#import "SSCommand+Additions.h"
#import "SSString.h"
#import "SSParameter.h"
#import "SSVariable.h"

#define DEFAULT_HEIGHT 60.0

#define DEFAULT_VARIABLE_WIDTH 50.0
#define LEFT_PADDING 15.0
#define MIDDLE_PADDING 10.0
#define RIGHT_PADDING 10.0

#define SIGNATURE_BASE_INDEX 1000
#define VARIABLE_BASE_INDEX 2000

#define SSStatementFont() [UIFont fontWithName:@"DoctorSoosLight" size:28.0]

@interface SSCommandView ()

@property (strong, readwrite) SSCommand * command;

- (UILabel *)signatureLabelAtIndex:(NSUInteger)index;

@end

@implementation SSCommandView

@synthesize command = _command;

- (id)initWithCommand:(SSCommand *)command {
    // Sort signature
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray * signature = [command.signature sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    // Calculate width
    UIFont * font = SSStatementFont(); 
    CGFloat width = LEFT_PADDING;
    for (SSString * string in signature)
        width += [string.value sizeWithFont:font].width;
    width += RIGHT_PADDING + LEFT_PADDING + MIDDLE_PADDING * (2 * [signature count] - 1) + DEFAULT_VARIABLE_WIDTH * [signature count];
    
    // Create frame
    CGRect frame = CGRectZero;
    frame.size.width = width;
    frame.size.height = DEFAULT_HEIGHT;
    
    // Init
    self = [super initWithFrame:CGRectIntegral(frame)];
    if (self) {
        self.command = command;
        self.backgroundColor = [UIColor clearColor];
        
        // Select background image
        UIImage * backgroundImage = nil;
        if ([command.signatureKey caseInsensitiveCompare:@"Write"] == NSOrderedSame)
            backgroundImage = [UIImage imageNamed:@"blue_sm_btn.png"];
        else if ([command.signatureKey caseInsensitiveCompare:@"Read"] == NSOrderedSame)
            backgroundImage = [UIImage imageNamed:@"green_btn_sm.png"];
        backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 40)];
        UIImageView * backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        backgroundImageView.frame = self.bounds;
        [self addSubview:backgroundImageView];
        
        // Add labels for signature
        CGFloat x = LEFT_PADDING;
        NSUInteger index = 0;
        for (SSString * string in signature) {
            NSString * value = string.value;
            UILabel * label = [self signatureLabelAtIndex:index];
            CGFloat width = ceilf([value sizeWithFont:font].width);
            label.frame = CGRectMake(x, 0, width, DEFAULT_HEIGHT);
            label.text = value;
            [self addSubview:label];
            x += width + MIDDLE_PADDING;
            index++;
        }
    }
    return self;
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

@end
