//
//  SSViewController.h
//  Suess for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSCanvasView;

@interface SSViewController : UIViewController

@property (weak, nonatomic) IBOutlet SSCanvasView *canvasView;

@end
