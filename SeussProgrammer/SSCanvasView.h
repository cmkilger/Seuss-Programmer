//
//  SSCanvas.h
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSProgram;

@interface SSCanvasView : UIView

@property (strong) SSProgram * program;

- (void)loadFileAtPath:(NSString *)path;

@end
