//
//  SSPopOverViewController.h
//  Suess for iPad
//
//  Created by Renu Punjabi on 7/21/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilePickerDelegate

- (void)fileSelected:(NSString *)fileName;

@end

@interface SSPopOverViewController : UITableViewController

@property (nonatomic) id<FilePickerDelegate> delegate;

@end
