//
//  SSConsoleViewController.m
//  Suess for iPad
//
//  Created by Renu Punjabi on 7/21/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSConsoleViewController.h"

@interface SSConsoleViewController (){
}
-(NSArray *)readString;

@end

@implementation SSConsoleViewController
@synthesize consoleTextView;
@synthesize writeString, readFromFileString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self readString];
   }

-(NSArray *)readString
{
   // consoleTextView.text = fileContents;
    
    unsigned stringLength = [consoleTextView.text length];
    unsigned startIndex;
    unsigned lineEndIndex = 0;
    unsigned contentsEndIndex;
    NSRange range;
    NSMutableArray *lines = [NSMutableArray array];
    
    while (lineEndIndex < stringLength)
    {
        // Include only a single character in range.  Not sure whether
        // this will work with empty lines, but if not, try a length of 0.
        range = NSMakeRange(lineEndIndex, 1);
        [consoleTextView.text getLineStart:&startIndex end:&lineEndIndex contentsEnd:&contentsEndIndex forRange:range];
        
        // exclude line terminators...
        [lines addObject:[consoleTextView.text substringWithRange:NSMakeRange(startIndex, contentsEndIndex - startIndex)]];
    }
    return lines;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewDidUnload {
    [self setConsoleTextView:nil];
    [self setConsoleTextView:nil];
    [super viewDidUnload];
}

- (IBAction)doneButtonClicked:(id)sender {
//    [self.consoleTextView endEditing:YES];
    [self.consoleTextView resignFirstResponder];

}
@end
