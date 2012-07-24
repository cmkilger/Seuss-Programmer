//
//  SSVariableView.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSVariableView : UIView

@property (readonly) NSString * variable;

- (id)initWithVariable:(NSString *)variable;

@end
