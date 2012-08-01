//
//  SSStringView.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/31/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSStringView : UIView

@property (readonly) NSString * string;

- (id)initWithString:(NSString *)string;

@end
