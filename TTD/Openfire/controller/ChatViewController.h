//
//  ChatViewController.h
//  BaseProject
//
//  Created by Huan Cho on 13-8-3.
//  Copyright (c) 2013年 ch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMessageDelegate.h"

@interface ChatViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,  KKMessageDelegate>

@property(nonatomic, retain) NSString *chatWithUser;

@property (retain, nonatomic) IBOutlet UITableView *tView;
@property (retain, nonatomic) IBOutlet UITextField *messageTextField;

- (IBAction)sendButton:(id)sender;
//- (IBAction)closeButton:(id)sender;

@end