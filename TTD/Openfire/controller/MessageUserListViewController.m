//
//  MessageUserListViewController.m
//  TTD
//
//  Created by andy on 13-10-11.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "MessageUserListViewController.h"
#import "MessageUserListViewControllerCell.h"
//#import "MessageChatViewController.h"

#import "ChatViewController.h"
#import "AddBuddyViewCtl.h"
#import "XMPPHelper.h"
#import "Statics.h"
#import "WCMessageObject.h"
#import "JSBadgeView.h"
#import "Photo.h"

#import "BCTabBarController.h"


#import "ZNChatMessageViewController.h"//ZN 聊天页面
#import "JMDropMenu.h"
#import "ZNListViewController.h"//znlist页面
#import "ZNGroupChatViewController.h"//群聊
#import "NewParentSettingViewController.h"
#import "ZNChatNewsViewController.h"

#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width

@interface MessageUserListViewController ()<JMDropMenuDelegate>
{
    int MessageStateCount;
    //在线用户
    //NSMutableArray *onlineUsers;
    //离线用户
    //NSMutableArray *offlineUsers;
    //NSString *chatUserName;
    //NSString *icoImage=@"message.png";
}
//Search by Andy
// consultant manager student

@property(nonatomic, retain) NSMutableArray *collationGroup;
@property(nonatomic, copy) NSMutableArray *famousPersons;
@property(nonatomic, copy) NSMutableArray *filteredPersons;
@property(nonatomic, copy) NSMutableArray *sections;
@property(nonatomic, strong) UILabel * flotageLabel;
@property(nonatomic, strong, readwrite) UISearchBar *searchBar;
@property(nonatomic, strong, readwrite) UITableView *tableView;
@property(nonatomic, strong) UISearchDisplayController *strongSearchDisplayController; // UIViewController doesn't retain the search display controller if it's created programmatically: http://openradar.appspot.com/10254897

//Search End

@property(nonatomic,retain) NSMutableArray *roster;
@property(nonatomic,retain) NSMutableArray *onlineUsers;
@property(nonatomic,retain) NSMutableArray *offlineUsers;
@property(nonatomic,retain) NSMutableArray *messages;
@property(nonatomic,retain) NSMutableArray *userMessageInfo;
//ZNnewchat
@property (nonatomic,strong)NSString * newstr;
@property (nonatomic,strong)NSMutableArray * newarr;
//zn 临时新增
@property (nonatomic,strong) XMPPvCardTemp *vcard;
@property (nonatomic,strong) UIImage * iamge;
@property (nonatomic,strong) UIButton *lefttView;



@end

@implementation MessageUserListViewController
@synthesize roster;
@synthesize onlineUsers;
@synthesize offlineUsers;
@synthesize userMessageInfo;
@synthesize signOut;
//@synthesize tableView=_tableView;
@synthesize messages = _messages;
-(NSString *)iconImageName {
    return @"defaultUSerImage";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [self getchatNews];
    }
    return self;
}
-(void)viewDidLayoutSubviews
{
//    [self getchatNews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
         }
}
-(void)navAdd:(UIBarButtonItem *)item {
    //临时注销
  
        dispatch_async(dispatch_get_main_queue(), ^{
              [JMDropMenu showDropMenuFrame:CGRectMake(self.view.frame.size.width - 115, 64, 110, 85) ArrowOffset:88.f TitleArr:[NSArray arrayWithObjects:@"Group Chat",@"Group Video", nil] ImageArr:[NSArray arrayWithObjects:@"1",@"2", nil]  Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeTitle RowHeight:40.f Delegate:self];
        });
   
  
//    [JMDropMenu showDropMenuFrame:CGRectMake(self.view.frame.size.width - 115, 64, 110, 45) ArrowOffset:88.f TitleArr:[NSArray arrayWithObjects:@"Group Video", nil] ImageArr:[NSArray arrayWithObjects:@"1", nil]  Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeTitle RowHeight:40.f Delegate:self];
    
    NSLog(@"点击添加多人视频按钮");
//    ZNListViewController * znlis=[[ZNListViewController alloc]init];
//    [self.navigationController pushViewController:znlis animated:YES];
}
#pragma mark - JMDropMenu Delegate
- (void)didSelectRowAtIndex:(NSInteger)index Title:(NSString *)title Image:(NSString *)image {
    NSLog(@"右上角点击的是----%zd,  title---%@, image---%@", index, title, image);

    switch (index) {
        case 0:
            //创建群组聊天
        {

            ZNListViewController * znlis=[[ZNListViewController alloc]init];
            znlis.Roomtype = @1;
            [self.navigationController pushViewController:znlis animated:YES];
        }
            break;
        case 1:
            //创建多人视频聊天
        {
            ZNListViewController * znlis=[[ZNListViewController alloc]init];
            znlis.Roomtype = @2;
            [self.navigationController pushViewController:znlis animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)createNavBarImage {
    //读取xmppvcard 设置头像
    self.vcard=[XMPPHelper getmyvcard];
    if (SharedAppDelegate.imageStr.length>0) {
        UIImage * pp = [Photo string2Image:SharedAppDelegate.imageStr];
        _iamge = pp;
    }else{
        _iamge = [UIImage imageNamed:@"defaultUSerImage"];
    }
    _lefttView = [[UIButton alloc] init];
    [_lefttView setImage:_iamge forState:UIControlStateNormal];
    [_lefttView addTarget:self action:@selector(leftimg) forControlEvents:UIControlEventTouchUpInside];
    _lefttView.layer.cornerRadius = 20;
    _lefttView.layer.masksToBounds = YES;
     [self.navigationController.view addSubview:_lefttView];
    if (UI_Is_iPhoneX) {
        _lefttView.frame = CGRectMake(20, 40, 40, 40);
//        [_lefttView remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.navigationController.view.mas_left).offset(20);//局左
//            make.top.equalTo(self.navigationController.view.mas_top).offset(40);//居上
//            make.width.mas_equalTo(40);//宽
//            make.height.mas_equalTo(40);//高
//        }];
    }else{
        _lefttView.frame = CGRectMake(20, 20, 40, 40);
      
        
    }
 
    
    
    
    
   
}
-(void)leftimg {
    NSLog(@"点击了导航右侧按钮");
    NewParentSettingViewController * newpar = [[NewParentSettingViewController alloc]init];
    [self presentViewController:newpar animated:YES completion:nil];

}

-(void)chatleftimage {
    self.vcard=[XMPPHelper getmyvcard];
    if (SharedAppDelegate.imageStr.length>0) {
        UIImage * pp = [Photo string2Image:SharedAppDelegate.imageStr];
        _iamge = pp;
    }else{
        _iamge = [UIImage imageNamed:@"defaultUSerImage"];
    }
    [_lefttView setImage:_iamge forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    self.tabBarController.tabBar.hidden = NO;
    [super viewDidLoad];
    _newarr =[[NSMutableArray alloc]init];
    //接收刷新页面通知 TABRELOAD
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TABRELOAD) name:@"TABRELOAD" object:nil];
    //ZN 新加导航按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navAdd:)];
    
    //zn 10-11  临时添加
//    [self createNavBarImage];
      [self performSelector:@selector(chatleftimage) withObject:nil afterDelay:3.0];
     _lefttView.hidden = NO;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Addd.png"] style:UIBarButtonItemStyleDone target:self action:@selector(navAdd:)];
    self.navigationItem.rightBarButtonItem.tag = 1011;
    
MessageStateCount=0;
    self.navigationItem.titleView = nil;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"Messages";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
     [self.newbut addTarget:self action:@selector(topbutchatnew) forControlEvents:UIControlEventTouchUpInside];
//    [self getchatNews];
    [self createUI];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // 可以用该语句查看当前线程
    NSLog(@"当前线程--%@", [NSThread currentThread]);
   /*隐藏新闻
    // 此处获取新闻消息
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        while (TRUE) {
            
            // 每隔5秒执行一次（当前线程阻塞5秒）
            [NSThread sleepForTimeInterval:1800];
            
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            // 这里写你要反复处理的代码，如网络请求
            NSLog(@"***没30分钟输出一次这段文字***");
            [self getchatNews];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        };
    });
    
    */

    
}
/*
-(void)getchatNews {
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_ChatNews parameters:nil];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         ZNgetChatNews * znallet = [ZNgetChatNews responseWithDDXMLDocument:XMLDocument];
         NSString * json = znallet.chatnews;
         NSDictionary  * jsondic = [SharedAppDelegate dictionaryWithJsonString:json];
         for (NSArray * arr in jsondic) {
             [_newarr addObject:arr];
             
         }
         for (int i=0; i<_newarr.count; i++) {
             NSDictionary * dic = _newarr[i];
             self.newtitlab.text = [dic objectForKey:@"Title"];
         }
        
       
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"getchatnews失败===%@",error);
     }];
    [operation start];
}
*/
-(void)topbutchatnew{
    ZNChatNewsViewController * news =[[ZNChatNewsViewController alloc]init];
    news.datasout =self.newarr;
    [self.navigationController pushViewController:news animated:YES];
}

-(void)createUI{
    //ZN新增新闻
//    UIView * topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
//    topview.backgroundColor=[UIColor redColor];
//    UIImageView * imageV= [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 60)];
//    imageV.image=[UIImage imageNamed:@"Icon-120"];
//    imageV.layer.masksToBounds = YES;
//    imageV.layer.cornerRadius  = 30;
//    [topview addSubview:imageV];
//    UILabel * titlelab = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH-110, 30)];
//    titlelab.text=@"ThinkTankLearningNews";
//    [topview addSubview:titlelab];
//    UILabel * contentlab = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, SCREEN_WIDTH-110, 30)];
//    [contentlab setTextColor:[UIColor lightGrayColor]];
//    contentlab.text = self.newstr;
//    [topview addSubview:contentlab];
//    UIButton * topbut = [UIButton buttonWithType:UIButtonTypeCustom];
//    topbut.frame =CGRectMake(0, 0, SCREEN_WIDTH, 79);
   
//    [topview addSubview:topbut];
  
    
//    self.tableView.frame = CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT-150);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
    [self.tableView setEditing:NO animated:YES];
//    self.tableView.tableHeaderView = topview;
//    self.tableView.tableHeaderView.frame=CGRectMake(0, 0, SCREEN_HEIGHT, 80);
    // Do any additional setup after loading the view from its nib.
    self.roster=[NSMutableArray array];
    self.onlineUsers = [NSMutableArray array];
    self.offlineUsers = [NSMutableArray array];
    self.userMessageInfo=[NSMutableArray array];
    //设定在线用户委托
    [XMPPServer sharedServer].chatDelegate = self;
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));
    
    
    
    //Search End
    self.userMessageInfo=[WCMessageObject fetchAllUserMessageInfo:[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
    //    NSLog(@"=====数据源=== %@",self.userMessageInfo);
    for (WCMessageObject *wco in self.userMessageInfo ){
        //        NSLog(@"%@ --- ",wco.group);
        
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     _lefttView.hidden = NO;
     self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self reloadDataList];
    
}
-(void)TABRELOAD{
    [self reloadDataList];
}
-(void)queryRoster {
    /*
     <iq type="get"
     　　from="xiaoming@example.com"
     　　to="example.com"
     　　id="1234567">
     　　<query xmlns="jabber:iq:roster"/>
     <iq />
     */
    //NSLog(@"------queryRoster------");
    NSXMLElement *queryElement = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = [XMPPServer xmppStream].myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:myJID.domain];
    [iq addAttributeWithName:@"id" stringValue:@""];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:queryElement];
    [[XMPPServer xmppStream] sendElement:iq];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //即使没有显示在window上，也不会自动的将self.view释放
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidLoad
    if ([self.view window] == nil){// 是否是正在使用的视图
        // Add code to preserve data stored in the views that might be
        // needed later.
        
        // Add code to clean up other strong references to the view in
        // the view hierarchy.
        //self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"tableViewSection:%lu",(unsigned long)self.roster.count);
    //return self.roster.count;
    if (tableView == self.tableView) {
        if (self.showSectionIndexes) {
            return [[self.sections objectAtIndex:section] count];
        }else if(self.showGroup)
        {
            return [[self.sections objectAtIndex:section] count];
        }else {
            return self.famousPersons.count;
        }
    } else {
        return self.filteredPersons.count;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return 1;
    if (tableView == self.tableView) {
        if (self.showSectionIndexes) {
            return self.sections.count;
        }else if (self.showGroup) {
//            NSLog(@"====self.sections.count: %lu",(unsigned long)self.sections.count);
//            NSLog(@"self.showGruop====%@",self.sections);
            return self.sections.count;
        }else {
            return 1;
        }
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hiddenHUD];
    static NSString* identifier = @"MessageUserListViewControllerCell";
    MessageUserListViewControllerCell* cell = (MessageUserListViewControllerCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray* array = [[UINib nibWithNibName:@"MessageUserListViewControllerCell" bundle:nil] instantiateWithOwner:self options:nil];
        cell = [array objectAtIndex:0];
        
    }
    WCMessageObject *wuserobject;
    if (tableView == self.tableView) {
        if (self.showSectionIndexes) {
            wuserobject=[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }else if (self.showGroup) {
            wuserobject=[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
        else {
            wuserobject=[self.famousPersons objectAtIndex:indexPath.row];
        }
    } else {
        wuserobject=[self.filteredPersons objectAtIndex:indexPath.row];
    }
    cell.UserName.text=wuserobject.userId;
    if ((NSNull *)wuserobject.userNickname!=[NSNull null]) {
        if(wuserobject.userNickname.length>1)
        {
            cell.UserName.text=wuserobject.userNickname;
        }
    }
    if ((NSNull *)wuserobject.userHead!=[NSNull null]) {
        if(wuserobject.userHead.length>50)
        {
            [cell.UserPhoto setImage:[Photo string2Image:wuserobject.userHead]];
        }
        else {
            [cell.UserPhoto setImage:[UIImage imageNamed:@"defaultUSerImage.png"]];
        }
    }
    else {
        [cell.UserPhoto setImage:[UIImage imageNamed:@"defaultUSerImage.png"]];
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setDateFormat:@"HH:mm a"];
    if ((NSNull *)wuserobject.messageContent!=[NSNull null]) {
        if ((NSNull *)wuserobject.messageType!=[NSNull null]) {
            if([wuserobject.messageType intValue]==kWCMessageTypePlain) {
                cell.Messageinfo.text=wuserobject.messageContent;
                cell.Messageinfo.hidden=NO;
                cell.MessageFace.hidden=YES;
            }
            else if ([wuserobject.messageType intValue]==kWCMessageTypeImage) {
                cell.Messageinfo.text=@"[Image]";
                cell.Messageinfo.hidden=NO;
                cell.MessageFace.hidden=YES;
            }
            else if ([wuserobject.messageType intValue]==kWCMessageTypeVoice) {
                cell.Messageinfo.text=@"[Voice]";
                cell.Messageinfo.hidden=NO;
                cell.MessageFace.hidden=YES;
            }
            else if ([wuserobject.messageType intValue]==kWCMessageTypeFace) {
                cell.Messageinfo.text=@"";
                cell.Messageinfo.hidden=YES;
                cell.MessageFace.hidden=NO;
                cell.MessageFace.image=[UIImage imageNamed:wuserobject.messageContent];
            }else {
                cell.Messageinfo.text=@"";
                cell.Messageinfo.hidden=NO;
                cell.MessageFace.hidden=YES;
            }
        }
        if ((NSNull *)wuserobject.messageDate!=[NSNull null]) {
            NSString *time =[dateFormatter stringFromDate:wuserobject.messageDate];
            cell.MessageinfoTime.text=time;
        }
        
        cell.BadgeView.hidden=NO;
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:cell.BadgeView alignment:JSBadgeViewAlignmentCenterLeft];
        badgeView.badgeText = NULL;
        
        
        if ((NSNull *)wuserobject.messageCount!=[NSNull null]) {
            MessageStateCount=[wuserobject.messageCount intValue];
        }
        if (MessageStateCount>0) {
            JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:cell.BadgeView alignment:JSBadgeViewAlignmentCenterLeft];
               badgeView.badgeText = [NSString  stringWithFormat:@"  "];
            
//            badgeView.badgeText = [NSString  stringWithFormat:@"%d", MessageStateCount];
            cell.BadgeView.hidden=NO;
            [UIApplication sharedApplication].applicationIconBadgeNumber=MessageStateCount;
        }else {
            JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:cell.BadgeView alignment:JSBadgeViewAlignmentCenterLeft];
            badgeView.badgeText = [NSString  stringWithFormat:@"  "];
            cell.BadgeView.hidden=YES;
        }
    }else {
        cell.Messageinfo.text=NULL;
        cell.MessageinfoTime.text=NULL;
        cell.MessageFace.hidden=YES;
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:cell.BadgeView alignment:JSBadgeViewAlignmentCenterLeft];
        badgeView.badgeText = [NSString  stringWithFormat:@"  "];
        cell.BadgeView.hidden=YES;
    }
    UIImageView *UserPhoto2=[[UIImageView alloc] init];
    UserPhoto2.layer.masksToBounds = YES;
    UserPhoto2.layer.cornerRadius = 6.0;
    UserPhoto2.layer.borderWidth = 1.0;
    UserPhoto2.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.UserPhoto.layer.shadowColor=[UIColor grayColor].CGColor;
    cell.UserPhoto.layer.shadowOffset=CGSizeMake(0, 0);
    cell.UserPhoto.layer.shadowOpacity=0.5;
    cell.UserPhoto.layer.shadowRadius=5;
    [cell.UserPhoto addSubview:UserPhoto2];
    //群聊头像
    if ([wuserobject.group isEqualToString:@"Group Chat"]) {
        cell.UserPhoto.image = [UIImage imageNamed:@"profile_group_266.12254901961px_1185672_easyicon.net.png"];
    }
    
    
    return cell;
}

#pragma mark - CELL 跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //start a Chat self.roster
    //chatUserName = (NSString *)[self.roster objectAtIndex:indexPath.row];
    if (tableView.isEditing) {
        return;
    }
    WCMessageObject *wco;
    
    if (tableView == self.tableView) {
        if (self.showSectionIndexes) {
            wco=[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
        }else if(self.showGroup)
        {
            wco=[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
        }
        else {
            wco=[self.famousPersons objectAtIndex:indexPath.row];
         
        }
    } else {
        wco=[self.filteredPersons objectAtIndex:indexPath.row];
       
    }
  ZNChatMessageViewController * znchat = [[ZNChatMessageViewController alloc]init];
    NSString *chatUserName=[wco.userId stringByAppendingFormat:@"@%@",OpenFireHostName];
    znchat.chatWithUser = chatUserName;
    if ((NSNull *)wco.userNickname!=[NSNull null]) {
        znchat.userNickname=wco.userNickname;
        if ([wco.userNickname isEqualToString:@"" ]) {
            znchat.userNickname=chatUserName;
        }
    }
    if ((NSNull *)wco.userHead!=[NSNull null]) {
        if(wco.userHead.length>50)
        {
            znchat.ToUserPhoto=wco.userHead;
        }
    }
    [znchat setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:chatViewCtl animated:YES];
    
    wco.messageCount =NULL;
     _lefttView.hidden = YES;
    
    if ([wco.group isEqualToString:@"Group Chat"]) {
        znchat.Isgroup = YES;
        ZNGroupChatViewController * zngroup = [[ZNGroupChatViewController alloc]init];
        if ((NSNull *)zngroup.userNickname!=[NSNull null]) {
            zngroup.userNickname = wco.userNickname;
            if ([wco.userNickname isEqualToString:@""]) {
                zngroup.userNickname = chatUserName;
            }
        }
        if ((NSNull *)wco.userHead!=[NSNull null]) {
            if (wco.userHead.length>50) {
                znchat.ToUserPhoto = wco.userHead;
            }
        }
        wco.messageCount = NULL;
        [self.navigationController pushViewController:zngroup animated:YES];
        MessageStateCount = 0;
    }else{
        [self.navigationController pushViewController:znchat animated:YES];
        MessageStateCount = 0;
    }
    
    
    
    
    NSLog(@"点击cell进行跳转 =%@",wco.messageCount);
}


//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//
//
//}

#pragma mark - KKChatDelegate
//在线好友
- (void)newBuddyOnline:(NSString *)buddyName {
    NSLog(@"在线好友姓名==%@",buddyName);
    if (![self.onlineUsers containsObject:buddyName]) {
        [self.onlineUsers addObject:buddyName];
        [self.offlineUsers removeObject:buddyName];
        [self.tableView reloadData];
    }
}

//好友下线
- (void)buddyWentOffline:(NSString *)buddyName {
      NSLog(@"xia⤵️线好友姓名==%@",buddyName);
    if (![self.offlineUsers containsObject:buddyName]) {
        [self.onlineUsers removeObject:buddyName];
        [self.offlineUsers addObject:buddyName];
        [self.tableView reloadData];
    }
}
- (void)rosterLiset:(NSMutableArray *)byddyName {
    if([self.roster isEqual:byddyName]){
        self.roster=NULL;
        self.roster=byddyName;
        [self initWithSectionIndexes:NO];
        NSLog(@"rosterLiset");
        [self.tableView reloadData];
    }
}
- (void)messageContentNotice {
   dispatch_async(dispatch_get_main_queue(), ^{
        self.roster=[WCMessageObject fetchAllUserMessageInfo:SharedAppDelegate.username];
        [self initWithSectionIndexes:NO];
        [self.tableView reloadData];
        [self UITableViewScrollTop];
    });
    
    
}
- (IBAction)btnSignOut:(id)sender {
    
    [self loginoutsave];
    [SharedAppDelegate showLogin:NO animated:YES];
    [SharedAppDelegate clearAllCache];
}
- (void) reloadDataList {
    self.roster=[WCMessageObject fetchAllUserMessageInfo:SharedAppDelegate.username];
    //获取总数据
    //self.roster=[WCUserObject fetchAllFromUsername:SharedAppDelegate.username];
    if(self.roster.count<=0) {
        //[self showHUD];
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT/2-50, SCREEN_WIDTH, 50)];
        [lab setTextColor:[UIColor lightGrayColor]];
        lab.text = @"No Data";
        [self.view addSubview:lab];
    }else{
        [self hiddenHUD];
    [self initWithSectionIndexes:NO];
    [self.tableView reloadData];
    [self UITableViewScrollTop];
    }
}

-(void)tableview:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"tableviewtouchesBegan");
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded");
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled");
}
//收到消息后如果多个群组自动跳转到新消息群组为顶端
-(void) UITableViewScrollTop {
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (void)loginoutsave {
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            @"ios",@"source",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:User_LoginOut parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
         UserLoginOutResponse* res = [UserLoginOutResponse userLoginOutResponseWithDDXMLDocument:XMLDocument];
         if (!res.userLoginOutMessage) {
             NSLog(@"退出日志写入失败");
         } else {
             if ([res.userLoginOutMessage isEqualToString:@"true"]) {
                 NSLog(@"退出日志写入成功");
             }else {
                 NSLog(@"退出日志写入失败");
             }
         }
         
     }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
         NSLog(@"result, error:%@",error);
     }];
    [operation start];
}

//Scroll

- (id)initWithSectionIndexes:(BOOL)showSectionIndexes {
    if ((self = [super initWithNibName:nil bundle:nil])) {
//        self.title = @"Search Bar";
        
        _showSectionIndexes = showSectionIndexes;
        
        _famousPersons = self.roster;
        
        // consultant manager student
        _showGroup=NO;
        if([SharedAppDelegate.role isEqualToString:TTDROLE_CONSULTANT]) {
            self.collationGroup =[NSMutableArray arrayWithObjects:@"Recent Chat",@"Group Chat",@"Manager",@"Consultant",@"Student",@"Parent", nil];
            _showGroup=YES;
            _showSectionIndexes=NO;
            showSectionIndexes=NO;
        }
        if([SharedAppDelegate.role isEqualToString:TTDROLE_MANAGER]) {
            self.collationGroup=[NSMutableArray arrayWithObjects:@"Recent Chat",@"Group Chat",@"Manager",@"Consultant",@"Student",@"Parent", nil];
            _showGroup=YES;
            _showSectionIndexes=NO;
            showSectionIndexes=NO;
        }
        if([SharedAppDelegate.role isEqualToString:TTDROLE_PARENT]) {
            self.collationGroup=[NSMutableArray arrayWithObjects:@"Recent Chat",@"Group Chat",@"Manager",@"Consultant", nil];
            _showGroup=YES;
            _showSectionIndexes=NO;
            showSectionIndexes=NO;
        }
        if([SharedAppDelegate.role isEqualToString:TTDROLE_STUDENT]) {
            self.collationGroup=[NSMutableArray arrayWithObjects:@"Recent Chat",@"Group Chat",@"Manager",@"Consultant", nil];
            _showGroup=YES;
            _showSectionIndexes=NO;
            showSectionIndexes=NO;
        }
        
        if (showSectionIndexes) {
            UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
            //NSLog(@"collation:%@",collation.sectionTitles);
            
            NSMutableArray *unsortedSections = [[NSMutableArray alloc] initWithCapacity:[[collation sectionTitles] count]];
            for (NSUInteger i = 0; i < [[collation sectionTitles] count]; i++) {
                [unsortedSections addObject:[NSMutableArray array]];
            }
            //在查询下面增加最近联系人
            [unsortedSections addObject:[NSMutableArray array]];
            int TopCount=1;
//            NSLog(@"======RecentContactNumber:%d",SharedAppDelegate.RecentContactNumber);
            for (WCMessageObject *wco in self.famousPersons ) {
                if(TopCount >= SharedAppDelegate.RecentContactNumber) {
                    if ((NSNull *)wco.userNickname!=[NSNull null]) {
                        NSInteger index = [collation sectionForObject:wco.userNickname collationStringSelector:@selector(description)];
//                        [[unsortedSections objectAtIndex:index+1] addObject:wco];
                    }
                }else {
                    [[unsortedSections objectAtIndex:0] addObject:wco];
                }
                TopCount++;
            }
            NSMutableArray *sortedSections = [[NSMutableArray alloc] initWithCapacity:unsortedSections.count];
            for (NSMutableArray *section in unsortedSections) {
                //NSLog(@"section:%@",section);
                [sortedSections addObject:[collation sortedArrayFromArray:section collationStringSelector:@selector(description)]];
            }
            self.sections = sortedSections;
            /*
             //显示当前选中的字母
             self.flotageLabel = [[UILabel alloc] initWithFrame:(CGRect){(Screen_width - 64 ) / 2,(Screen_height - 64) / 2,64,64}];
             self.flotageLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"flotageBackgroud"]];
             self.flotageLabel.hidden = YES;
             self.flotageLabel.textAlignment = NSTextAlignmentCenter;
             self.flotageLabel.textColor = [UIColor whiteColor];
             [self.view addSubview:self.flotageLabel];
             */
        }
        if(self.showGroup) {
            NSMutableArray *unsortedSections = [[NSMutableArray alloc] init];
            for (NSUInteger i = 0; i < [self.collationGroup count]; i++) {
                [unsortedSections addObject:[NSMutableArray array]];
            }
            for (WCMessageObject *wco in self.famousPersons ) {
//                NSLog(@"======famousPersons:%@",self.famousPersons);
//                NSLog(@"======SharedAppDelegate.role:%@",SharedAppDelegate.role);
//                NSLog(@"======collationGroup:%@",self.collationGroup);
//                NSLog(@"======wco.group:%@",wco.group);
                if ((NSNull *)wco.group!=[NSNull null]) {
                    NSInteger index = [self.collationGroup  indexOfObject:wco.group ];
                    @try {
                        if ((NSNull *)wco.messageContent!=[NSNull null ]) {
                            if(wco.messageContent.length>0) {
                                [[unsortedSections objectAtIndex:0] addObject:wco];
                            }else {
                                [[unsortedSections objectAtIndex:index] addObject:wco];
                            }
                        }else {
                            [[unsortedSections objectAtIndex:index] addObject:wco];
                        }
                    }
                    @catch (NSException *exception) {
                        continue;
                    }
                    @finally {
                    }
                }
                
            }
            
            for( NSUInteger i=0;i<[ self.collationGroup count];i++) {
                if ([ self.collationGroup count]<i) {
                    break;
                }else {
                    if ([[unsortedSections objectAtIndex:i] count]<1) {
                        [unsortedSections removeObjectAtIndex:i];
                        [_collationGroup  removeObjectAtIndex:i];
                        i=i-1;
                    }
                }
            }
            /*
             NSMutableArray *sortedSections = [[NSMutableArray alloc] initWithCapacity:unsortedSections.count];
             for (NSMutableArray *section in unsortedSections) {
             [sortedSections addObject:[self.collationGroup sortedArrayUsingFunction:sortName context:nil]];
             }
             self.sections = sortedSections;
             */
            self.sections = unsortedSections;
        }
    }
    
    return self;
}
NSInteger sortName(id st,id str, void *ch) {
    if([st integerValue] <[str integerValue])
    {
        return NSOrderedDescending;
    }else if ([st integerValue]>[str integerValue])
    {
        return NSOrderedAscending;
    }else
    {
        return NSOrderedSame;
    }
}

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated {
    [self.tableView scrollRectToVisible:self.searchBar.frame animated:animated];
    //NSAssert(YES, @"This method should be handled by a subclass!");
}

#pragma mark - TableView Delegate and DataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.tableView && self.showSectionIndexes) {
        //return [[NSArray arrayWithObjects:UITableViewIndexSearch,@"@",nil] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]  ];
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
    else {
        return nil;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView && self.showSectionIndexes) {
        if ([[self.sections objectAtIndex:section] count] > 0) {
            if(section==0)
            {
                return @"   Recently";
            }else
            {
                return [NSString stringWithFormat:@"   %@",[[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section-1]];
            }
            //return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
        } else {
            return nil;
        }
    }
    else if (tableView == self.tableView && self.showGroup)
    {
        NSLog(@"======objectAtIndex:section: %lu",(unsigned long)section);
        return [NSString stringWithFormat:@"   %@",[self.collationGroup objectAtIndex:section]];
    }
    else {
        return nil;
    }
}
#pragma mark - 表格头文字颜色
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 22)];
    titleLabel.textColor=[UIColor grayColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text=[self.collationGroup objectAtIndex:section];
    [myView addSubview:titleLabel];
    return myView;
}



-(void)tableView:(UITableView *)tableView touchesBegin:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSLog(@"======Title:%@,%ld",title,(long)index);
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [self scrollTableViewToSearchBarAnimated:NO];
        return NSNotFound;
    } else {
        
        //self.flotageLabel.text=title;
        //self.flotageLabel.hidden=NO;
        
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index]-1;
        //return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index]-1;
        // -1 because we add the search symbol
        // -2 add @
    }
}

#pragma mark - Search Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    //NSLog(@"famousPersons:%@",self.famousPersons);
    self.filteredPersons = self.famousPersons;
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    self.filteredPersons = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    self.filteredPersons = self.famousPersons;
    self.filteredPersons = [self.filteredPersons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userNickname contains[cd] %@", searchString]];
    return YES;
}
-(void) searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        tableView.frame=CGRectMake(0, CGRectGetHeight(self.searchBar.bounds) + HEIGHT(10), Screen_width,Screen_height-CGRectGetHeight(self.searchBar.bounds));
        [tableView setContentInset:UIEdgeInsetsZero];
        [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    }else {
        
    }
    //NSLog(@"tableViewX:%f",tableView.frame.origin.y);
    //NSLog(@"tableViewY:%f",tableView.frame.origin.x);
    //NSLog(@"tableViewHeight:%f",tableView.frame.size.height);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //scrollView.scrollEnabled=NO;
    /* if (scrollView.contentOffset.y < 44) {
     self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetHeight(self.searchBar.bounds) - MAX(scrollView.contentOffset.y, 0), 0, 0, 0);
     } else {
     self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
     }
     CGRect searchBarFrame = self.searchBar.frame;
     searchBarFrame.origin.y = MIN(scrollView.contentOffset.y, 0);
     self.searchBar.frame = searchBarFrame;
     */
    /*CGRect tableFrame=self.tableView.frame;
     tableFrame.origin.y=30;
     self.tableView.frame=tableFrame;*/
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
// Returns interface orientation masks.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
-(BOOL)shouldAutorotat {
    return NO;
}
@end
