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

@interface SSViewController : UIViewController <FilePickerDelegate> {
    SSPopOverViewController *_popOverViewController;
    UIPopoverController *_documentPickerPopover;
}

@property (weak, nonatomic) IBOutlet SSCanvasView *canvasView;
@property (nonatomic, retain) SSPopOverViewController *popOverViewController;
@property (nonatomic, retain) UIPopoverController *documentPickerPopover;

- (IBAction)runButtonClicked:(id)sender;

- (IBAction)buttonForPopOverClicked:(id)sender;

@end
