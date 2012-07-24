//
//  SSPopOverViewController.m
//  Seuss for iPad
//
//  Created by Renu Punjabi on 7/21/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSPopOverViewController.h"

@interface SSPopOverViewController ()

@property (retain) NSArray * documentFiles;

@end

@implementation SSPopOverViewController

@synthesize delegate = _delegate;
@synthesize documentFiles = _documentFiles;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSString * documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.documentFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documents error:nil];
    
    self.clearsSelectionOnViewWillAppear = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.documentFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString * document = [self.documentFiles objectAtIndex:indexPath.row];
    cell.textLabel.text = [[document lastPathComponent] stringByDeletingPathExtension];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate != nil) {
        NSString * document = [self.documentFiles objectAtIndex:indexPath.row];
        NSString * documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        [self.delegate fileSelected:[documents stringByAppendingPathComponent:document]];
    }
}

@end
