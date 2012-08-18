//
//  SSConsoleViewController.m
//  Seuss for iPad
//
//  Created by Renu Punjabi on 7/21/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSConsoleViewController.h"
#import <Seuss/Seuss.h>

#define FONT [UIFont fontWithName:@"DoctorSoosLight" size:36.0]

typedef void(^SSReadCallback)(NSString *);

@interface SSConsoleViewController ()

@property (assign) SUProgram * program;
@property (strong) NSMutableString * text;
@property (copy) SSReadCallback readCallback;
@property (strong) NSString * textViewString;
@property (assign) NSUInteger editableLocation;

- (void)readStringWithCallback:(SSReadCallback)callback;
- (void)writeString:(NSString *)string;

@end

@implementation SSConsoleViewController

@synthesize program = _program;
@synthesize text = _text;
@synthesize readCallback = _readCallback;
@synthesize consoleTextView = _consoleTextView;
@synthesize navigationBar = _navigationBar;
@synthesize textViewString = _textViewString;
@synthesize editableLocation = _editableLocation;

void SSWriteString(SUString * string, void * data) {
    dispatch_sync(dispatch_get_main_queue(), ^{
        SSConsoleViewController * self = (__bridge SSConsoleViewController *)data;
        [self writeString:[NSString stringWithCString:SUStringGetCString(string) encoding:NSUTF8StringEncoding]];
    });
}

SUString * SSReadString(void * data) {
    __block NSString * string = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_sync(dispatch_get_main_queue(), ^{
        SSConsoleViewController * self = (__bridge SSConsoleViewController *)data;
        [self readStringWithCallback:^(NSString * input) {
            string = input;
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_release(semaphore);
    return SUStringCreate([string cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (id)initFilePath:(NSString *)file {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = [[file lastPathComponent] stringByDeletingPathExtension];
        self.text = [[NSMutableString alloc] init];
        
        SUString * fileStr = SUStringCreate([file cStringUsingEncoding:NSUTF8StringEncoding]);
        SUList * tokens = SUTokenizeFile(fileStr);
        SUList * errors = SUListCreate();
        SUProgram * program = SUProgramCreate(tokens, errors);
        SUProgramSetWriteCallback(program, SSWriteString, (__bridge void *)self);
        SUProgramSetReadCallback(program, SSReadString, (__bridge void *)self);
        SURelease(fileStr);
        SURelease(tokens);
        SURelease(errors);
                  
        self.program = program;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            SUProgramExecute(self.program);
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.consoleTextView endEditing:YES];
                self.consoleTextView.editable = NO;
            });
        });
    }
    return self;
}

- (void)dealloc {
    SURelease(self.program);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.consoleTextView.font = FONT;
    self.consoleTextView.text = self.text;
    self.navigationBar.topItem.title = self.title;
    // TODO:    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange) name:UIKeyboardDidShowNotification object:nil];
}

- (void)writeString:(NSString *)string {
    [self.text appendString:string];
    self.consoleTextView.text = self.text;
}

- (void)readStringWithCallback:(SSReadCallback)callback {
    self.readCallback = callback;
    self.consoleTextView.selectedRange = NSMakeRange([self.consoleTextView.text length], 0);
    self.editableLocation = [self.consoleTextView.text length];
    [self.consoleTextView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.readCallback && range.location >= self.editableLocation) {
        if ([text isEqualToString:@"\n"]) {
            NSString * input = [self.text substringFromIndex:self.editableLocation];
            self.readCallback(input);
            self.readCallback = nil;
        }
        self.text = [[self.text stringByReplacingCharactersInRange:range withString:text] mutableCopy];
        return YES;
    }
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidUnload {
    [self setConsoleTextView:nil];
    [self setConsoleTextView:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}

- (IBAction)doneButtonClicked:(id)sender {
    [self.consoleTextView resignFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
}

@end
