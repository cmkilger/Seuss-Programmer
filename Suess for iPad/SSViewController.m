//
//  SSViewController.m
//  Suess for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSViewController.h"
#import "SSCanvasView.h"

@interface SSViewController ()

@end

@implementation SSViewController

@synthesize canvasView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.canvasView addStatement:@"Write"];
    [self.canvasView addStatement:@"Read"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidUnload {
    [self setCanvasView:nil];
    [super viewDidUnload];
}

@end
