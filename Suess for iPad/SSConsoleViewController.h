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
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

- (id)initFilePath:(NSString *)file;
- (IBAction)doneButtonClicked:(id)sender;

@end
