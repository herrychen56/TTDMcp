//
//  MessageUserViewListController.m
//  TTD
//
//  Created by andy on 13-11-11.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "MessageUserViewListController.h"

#import "ChatViewController.h"
#import "AddBuddyViewCtl.h"
#import "XMPPHelper.h"

@interface MessageUserViewListController (){
    //    //在线用户
    //    NSMutableArray *onlineUsers;
    //    //离线用户
    //    NSMutableArray *offlineUsers;
    NSString *chatUserName;
}

@property(nonatomic,retain) NSMutableArray *onlineUsers;
@property(nonatomic,retain) NSMutableArray *offlineUsers;

@end
@implementation MessageUserViewListController

@synthesize onlineUsers;
@synthesize offlineUsers;

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
    self.onlineUsers = [NSMutableArray array];
    self.offlineUsers = [NSMutableArray array];
    //设定在线用户委托
    [XMPPServer sharedServer].chatDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
