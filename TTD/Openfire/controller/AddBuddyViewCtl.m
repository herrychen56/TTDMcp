//
//  AddBuddyViewCtl.m
//  BaseProject
//
//  Created by Huan Cho on 13-8-5.
//  Copyright (c) 2013年 ch. All rights reserved.
//

#import "AddBuddyViewCtl.h"

@interface AddBuddyViewCtl ()

@end

@implementation AddBuddyViewCtl

#pragma mark -life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    UIBarButtonItem *addBuddyItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(addButty)];
    [self.navigationItem setRightBarButtonItem:addBuddyItem];
    //[addBuddyItem release];
}

- (void)dealloc {
    //[_buddyNameField release];
    //[super dealloc];
}
- (void)viewDidUnload {
    [self setBuddyNameField:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
-(void)addButty{
    [[XMPPServer xmppRoster] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //XMPPHOST 就是服务器名，  主机名
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",self.buddyNameField.text,OpenFireHostName]];
    //[presence addAttributeWithName:@"subscription" stringValue:@"好友"];
    [[XMPPServer xmppRoster] subscribePresenceToUser:jid];
//    [XMPPHelper xmppRoster]
    
    [self.view endEditing:YES];
    
    /*
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加好友结果" message:@"SUCCESS!!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
     */
}

@end
