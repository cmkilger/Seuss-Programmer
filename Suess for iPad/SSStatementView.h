//
//  SSStatementView.h
//  Suess for iPad
//
//  Created by Cory Kilger on 7/20/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSStatementView : UIView

@property (readonly) NSString * statement;

- (id)initWithStatement:(NSString *)statement;

@end
