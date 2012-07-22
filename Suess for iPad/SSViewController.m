//
//  SSViewController.m
//  Suess for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSViewController.h"
#import "SSCanvasView.h"
#import "SSConsoleViewController.h"

@interface SSViewController (){
    NSString *contentOfFileSelected;
}

@property (strong) NSString * currentFilePath;

@end

@implementation SSViewController

@synthesize popOverViewController = _popOverViewController;
@synthesize documentPickerPopover = _documentPickerPopover;
@synthesize currentFilePath = _currentFilePath;

@synthesize canvasView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.canvasView addStatement:@"Write"];
    [self.canvasView addStatement:@"Read"];
    [self.canvasView addVariable:@"new line"];
}

- (void)fileSelected:(NSString *)fileName{
    self.currentFilePath = fileName;
    contentOfFileSelected = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    [self.documentPickerPopover dismissPopoverAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidUnload {
    [self setCanvasView:nil];
    [super viewDidUnload];
}

- (IBAction)runButtonClicked:(id)sender {
    SSConsoleViewController * console = [[SSConsoleViewController alloc] initFilePath:self.currentFilePath];
    [self presentModalViewController:console animated:YES];
}

- (IBAction)buttonForPopOverClicked:(id)sender {
    if (self.popOverViewController == nil) {
        self.popOverViewController = [[SSPopOverViewController alloc] initWithStyle:UITableViewStylePlain];
        self.popOverViewController.delegate = self;
        
        self.documentPickerPopover = [[UIPopoverController alloc] initWithContentViewController:self.popOverViewController];
    }
    
    [self.documentPickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
@end
