//
//  SSCanvas.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSCommand;
@class SSVariable;

@interface SSCanvasView : UIView

- (void)loadFileAtPath:(NSString *)path;

@end
