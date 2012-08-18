//
//  SSConsoleViewController.h
//  Seuss for iPad
//
//  Created by Renu Punjabi on 7/21/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Seuss/Seuss.h>

@class SSProgram;

@interface SSConsoleViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *consoleTextView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

- (id)initWithData:(NSData *)data name:(NSString *)name;
- (id)initWithFilePath:(NSString *)file;
- (id)initWithProgram:(SSProgram *)program;
- (IBAction)doneButtonClicked:(id)sender;

@end
