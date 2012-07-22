//
//  SSConsoleViewController.m
//  Suess for iPad
//
//  Created by Renu Punjabi on 7/21/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSConsoleViewController.h"
#import <Suess/Suess.h>

void SSWriteString(SUString * string, void * data) {
    SSConsoleViewController * self = (__bridge SSConsoleViewController *) data;
    // TODO: [self write:[NSString stringWithCString:SUStringGetCString(string) encoding:NSUTF8StringEncoding]];
}

SUString * SSReadString(void * data) {
    SSConsoleViewController * self = (__bridge SSConsoleViewController *) data;
    // TODO: read
    return SUStringCreate("");
}

@interface SSConsoleViewController ()

-(void)readString:(NSString *)fileContents;

@end

@implementation SSConsoleViewController
@synthesize consoleTextView, textViewString, writeString, editableLocation;

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
    [self readString:textViewString];
   }

-(void)readString:(NSString *)fileContents
{
    consoleTextView.text = fileContents;
    
    unsigned stringLength = [consoleTextView.text length];
    unsigned startIndex;
    unsigned lineEndIndex = 0;
    unsigned contentsEndIndex;
    NSRange range;
//    NSMutableArray *lines = [NSMutableArray array];
    NSMutableArray *lines = [[NSMutableArray alloc] init];

    
    while (lineEndIndex < stringLength)
    {
        // Include only a single character in range.  Not sure whether
        // this will work with empty lines, but if not, try a length of 0.
        range = NSMakeRange(lineEndIndex, 1);
        [consoleTextView.text getLineStart:&startIndex end:&lineEndIndex contentsEnd:&contentsEndIndex forRange:range];
        
        // exclude line terminators...
        self.editableLocation = NSMakeRange(startIndex, contentsEndIndex - startIndex);
        [lines addObject:[consoleTextView.text substringWithRange:self.editableLocation]];
        
    }
    self.consoleTextView.delegate = self;
    [self.consoleTextView setSelectedRange:self.editableLocation];

   // self.consoleTextView.inputView = [[UIView alloc] initWithFrame:CGRectZero];

    //return lines;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location > self.editableLocation.length-1  ) {
        return YES;
    } else {
        //return (self.editableLocation.location >= range.location);
         return NO;
    }
    //[textField2 setText:[textField1.text stringByReplacingCharactersInRange:range withString:string]];
 
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
