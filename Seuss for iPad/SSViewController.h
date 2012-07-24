//
//  SSViewController.h
//  Suess for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPopOverViewController.h"

@class SSCanvasView;

@interface SSViewController : UIViewController <FilePickerDelegate>

@property (weak, nonatomic) IBOutlet SSCanvasView *canvasView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

- (IBAction)runButtonClicked:(id)sender;
- (IBAction)buttonForPopOverClicked:(id)sender;

@end
