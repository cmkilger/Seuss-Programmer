//
//  SSVariableView.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSVariable;

@interface SSVariableView : UIView

@property (readonly) SSVariable * variable;

- (id)initWithVariable:(SSVariable *)variable;

@end
