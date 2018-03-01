//
//  BuddyViewController.m
//  BaseProject
//
//  Created by Huan Cho on 13-8-3.
//  Copyright (c) 2013年 ch. All rights reserved.
//

#import "BuddyViewController.h"
#import "ChatViewController.h"
#import "AddBuddyViewCtl.h"
#import "XMPPHelper.h"

@interface BuddyViewController (){
    
//    //在线用户
//    NSMutableArray *onlineUsers;
//    //离线用户
//    NSMutableArray *offlineUsers;
    
    NSString *chatUserName;
}

@property(nonatomic,retain) NSMutableArray *onlineUsers;
@property(nonatomic,retain) NSMutableArray *offlineUsers;

@end

@implementation BuddyViewController

@synthesize onlineUsers;
@synthesize offlineUsers;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - life circle
-(void)loadView{
    [super loadView];
    
    //删除好友
    UIBarButtonItem *deleteBuddyItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(toDeleteButty)];
    [self.navigationItem setLeftBarButtonItem:deleteBuddyItem];
    //[deleteBuddyItem release];
    
    //添加好友
    UIBarButtonItem *addBuddyItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toAddButty)];
    [self.navigationItem setRightBarButtonItem:addBuddyItem];
    //[addBuddyItem release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.onlineUsers = [NSMutableArray array];
    self.offlineUsers = [NSMutableArray array];
    
    //设定在线用户委托
    [XMPPServer sharedServer].chatDelegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if (login) {
        if ([[XMPPServer sharedServer] connect]) {
            NSLog(@"show buddy list");
        }
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有设置账号" delegate:self cancelButtonTitle:@"设置" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    [self queryRoster];
}

-(void)queryRoster{
    /*
     <iq type="get"
     　　from="xiaoming@example.com"
     　　to="example.com"
     　　id="1234567">
     　　<query xmlns="jabber:iq:roster"/>
     <iq />
     */
    NSLog(@"------queryRoster------");  
    NSXMLElement *queryElement = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = [XMPPServer xmppStream].myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:myJID.domain];
    [iq addAttributeWithName:@"id" stringValue:@""];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:queryElement];
    
    NSLog(@"from:%@",myJID.description);
    NSLog(@"to:%@",myJID.domain);
    NSLog(@"iq:%@",iq);

    NSLog(@"组装后的xml:%@",iq.stringValue);
    [[XMPPServer xmppStream] sendElement:iq];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        //[self toChat];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return self.onlineUsers.count;
    }else if (section == 1){
        return self.offlineUsers.count;
    }
    return self.offlineUsers.count;
    //    return [onlineUsers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.section ==0) {
        cell.textLabel.text = [self.onlineUsers objectAtIndex:[indexPath row]];
    }else if (indexPath.section == 1){
        cell.textLabel.text = [self.offlineUsers objectAtIndex:[indexPath row]];
    }
    
    //头像
    XMPPJID *jid = [XMPPJID jidWithString:cell.textLabel.text];
    UIImage *photo = [XMPPHelper xmppUserPhotoForJID:jid];
    if (photo)
        cell.imageView.image = photo;
    else
        cell.imageView.image = [UIImage imageNamed:@"defaultPerson"];
    
    //文本
    //cell.textLabel.text = [onlineUsers objectAtIndex:[indexPath row]];
    //标记
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex ==0) {
        return @"在线人员";
    }else if (sectionIndex == 1){
        return @"离线人员";
    }
	return @"";
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //start a Chat
    chatUserName = (NSString *)[self.onlineUsers objectAtIndex:indexPath.row];
    
    ChatViewController *chatViewCtl = [[ChatViewController alloc] init];
    chatViewCtl.chatWithUser = chatUserName;
    [self.navigationController pushViewController:chatViewCtl animated:YES];
    //[chatViewCtl release];
}

//tableView的编辑模式中当提交一个编辑操作时候调用：比如删除，添加等
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        if (indexPath.section == 0) {
            [self.onlineUsers removeObjectAtIndex:indexPath.row];
        }else{
            [self.offlineUsers removeObjectAtIndex:indexPath.row];
        }
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        //解除服务器上好友关系
        XMPPJID *jid = [XMPPJID jidWithString:cell.textLabel.text];
        [[XMPPServer xmppRoster] removeUser:jid];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

//每次设置为编辑模式之前，都会访问这个方法：
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.tag;
}

//编辑模式的时候，拖动的时候会调用这个方法：
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    //TODO
}

#pragma mark - private 
//删除好友
-(void)toDeleteButty{
    self.tableView.tag = UITableViewCellEditingStyleDelete;//删除状态：以tag值来传递编辑状态
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}

//添加好友
-(void)toAddButty{
    AddBuddyViewCtl *addBuddyCtl = [[AddBuddyViewCtl alloc] init];
    [self.navigationController pushViewController:addBuddyCtl animated:YES];
    
    //[addBuddyCtl release];
}

#pragma mark - KKChatDelegate
//在线好友
-(void)newBuddyOnline:(NSString *)buddyName{
    if (![self.onlineUsers containsObject:buddyName]) {
        [self.onlineUsers addObject:buddyName];
        [self.offlineUsers removeObject:buddyName];
        [self.tableView reloadData];
    }
}

//好友下线
-(void)buddyWentOffline:(NSString *)buddyName{
    if (![self.offlineUsers containsObject:buddyName]) {
        [self.onlineUsers removeObject:buddyName];
        [self.offlineUsers addObject:buddyName];
        [self.tableView reloadData];
    }
}

@end

