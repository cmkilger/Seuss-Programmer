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

@interface SSViewController ()

@property (strong) NSString * currentFilePath;
@property (retain) SSPopOverViewController * popOverViewController;
@property (retain) UIPopoverController * documentPickerPopover;

- (void)loadFileAtPath:(NSString *)path;

@end

@implementation SSViewController

@synthesize popOverViewController = _popOverViewController;
@synthesize documentPickerPopover = _documentPickerPopover;
@synthesize currentFilePath = _currentFilePath;
@synthesize canvasView = _canvasView;
@synthesize navigationBar = _navigationBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"Hello World.suess" ofType:nil];
    if (path)
        [self loadFileAtPath:path];
}

- (void)loadFileAtPath:(NSString *)path {
    self.currentFilePath = path;
    [self.canvasView loadFileAtPath:path];
    self.navigationBar.topItem.title = [[path lastPathComponent] stringByDeletingPathExtension];
}

- (void)fileSelected:(NSString *)fileName{
    [self.documentPickerPopover dismissPopoverAnimated:YES];
    [self loadFileAtPath:fileName];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidUnload {
    [self setCanvasView:nil];
    [self setNavigationBar:nil];
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
