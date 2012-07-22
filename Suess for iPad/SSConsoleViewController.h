//
//  SSConsoleViewController.h
//  Suess for iPad
//
//  Created by Renu Punjabi on 7/21/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSConsoleViewController : UIViewController <UITextViewDelegate> 

@property (strong, nonatomic) IBOutlet UITextView *consoleTextView;
@property (strong, nonatomic) NSString *textViewString;
@property (assign, nonatomic) NSRange editableLocation;

@property (strong, nonatomic) NSString *writeString;
- (IBAction)doneButtonClicked:(id)sender;

@end
