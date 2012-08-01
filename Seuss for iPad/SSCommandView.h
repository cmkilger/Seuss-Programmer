//
//  SSCommandView.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/30/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSVariableView;
@class SSCommand;

@interface SSCommandView : UIView

@property (strong, readonly) SSCommand * command;

- (id)initWithCommand:(SSCommand *)command;

@end
