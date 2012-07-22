//
//  SSCanvas.h
//  Suess for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSCanvasView : UIView

- (void)loadFileAtPath:(NSString *)path;
- (void)addStatement:(NSString *)statement;
- (void)addVariable:(NSString *)statement;

@end
