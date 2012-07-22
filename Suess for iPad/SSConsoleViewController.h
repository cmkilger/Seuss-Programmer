//
//  SSConsoleViewController.h
//  Suess for iPad
//
//  Created by Renu Punjabi on 7/21/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSConsoleViewController : UIViewController <UITextFieldDelegate>{
    
}

@property (strong, nonatomic) IBOutlet UITextView *consoleTextView;

@property (strong, nonatomic) NSString *writeString;
@property (strong, nonatomic) NSString *readFromFileString;
- (IBAction)doneButtonClicked:(id)sender;

@end
