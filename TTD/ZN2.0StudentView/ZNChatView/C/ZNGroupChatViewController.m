//
//  ZNGroupChatViewController.m
//  TTD
//
//  Created by quakoo on 2018/1/6.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "ZNGroupChatViewController.h"
#import "Message.h"
#import "MessageCell.h"
#import "MessageFrame.h"
//自定义键盘
#import "UIKeyboardBar.h"
#import "UIView+Methods.h"
//相机使用
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
//FMDB
#import "WCMessageObject.h"
#import "FMDatabase.h"
//Phont
#import "Photo.h"
//avi
#import "NSVoiceConverter.h"
#import "VoiceConverter.h"
#import <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioToolbox.h>
//ZN图片查看
#import "ZNImageV.h"
#import "NSData+Base64.h"

#import "ZNVideoWaitingViewController.h"//视频等待页面

#import "ZNLPImgViewController.h"//zn图片

#import "ZNManyPeopleVideoViewController.h"//多人视频页面

#import "Statics.h"
#import "KKChatDelegate.h"
#import "KKMessageDelegate.h"
#import "WCMessageObject.h"

#ifdef DEBUG
#define SLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define SLog(format, ...)
#endif
@interface ZNGroupChatViewController ()<UITableViewDataSource, UITableViewDelegate, UIKeyboardBarDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,MessCellDelegate,KKMessageDelegate,XMPPStreamDelegate,MessCellDelegate>

/** 信息记录数据 */
@property(nonatomic, strong) NSMutableArray *messages;

//代码聊天区
@property (nonatomic,strong) UITableView * table;
//地步键盘
@property (nonatomic) UIKeyboardBar *keyboardBar;

//相机相册
@property (nonatomic,strong) UIImagePickerController *imagePickerController;;
//记录语音长度
@property (nonatomic,strong)NSString * audiotime;

//我的头像
@property (nonatomic,strong) NSString * myicon;
//判断是否存储消息
@property (nonatomic,strong) NSString *  sendmessage;

@property (nonatomic,strong) NSMutableArray * groupchatApp;

@end

@implementation ZNGroupChatViewController

//创建结果
-(void)xmppRoomDidCreate:(XMPPRoom *)sender{
    
    NSLog(@"房间创建结果=== %@", sender.roomSubject);
}
//是否已经加入房间
-(void)xmppRoomDidJoin:(XMPPRoom *)sender{
    NSLog(@"加入房间成功xmppRoomDidJoin%@===  ==%@",sender.roomSubject,sender.myNickname);
}
// 收到禁止名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items{
    NSLog(@"收到聊天室禁止名单列表：%@",items);
}
// 收到好友名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items{
    NSLog(@"收到聊天室好友名单列表：%@",items);
}
// 收到主持人名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items{
    NSLog(@"收到聊天室主持人名单列表：%@",items);
}



//是否已经离开
-(void)xmppRoomDidLeave:(XMPPRoom *)sender{
    NSLog(@"是否已经离开xmppRoomDidLeave");
}
//新人加入群聊
- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID
{
    NSLog(@"新人加入群聊:");
}
//有人退出群聊
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID
{
    NSLog(@"有人退出群聊:" );
}



//有人在群里发言
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReceiveMessage" object:nil];
//     XMPPRoomCoreDataStorage *rosterstorage = [[XMPPRoomCoreDataStorage alloc] init];
    NSLog(@"有人在群里发言：%@ ", message);
//      NSArray * times =  [message elementsForXmlns:@"stamp"] ;
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
//    NSString * to = [[message attributeForName:@"to"]stringValue];
//    NSString *xmltype = [[message attributeForName:@"type"] stringValue];
//    NSString * time = [[message attributeForName:@"stamp"] stringValue];
   NSString * timeqq=[[NSString alloc]init];
    NSDate *localDate;
    XMPPElement *delay=(XMPPElement *)[message elementsForName:@"delay"];
    if(delay){  //如果有这个值 表示是一个离线消息
        //获得时间戳
        NSString *timeString=[[ (XMPPElement *)[message elementForName:@"delay"] attributeForName:@"stamp"] stringValue];
        //创建日期格式构造器
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        //按照T 把字符串分割成数组
        NSArray *arr=[timeString componentsSeparatedByString:@"T"];
        //获得日期字符串
        NSString *dateStr=[arr objectAtIndex:0];
        //获得时间字符串
        NSString *timeStr=[[[arr objectAtIndex:1] componentsSeparatedByString:@"."] objectAtIndex:0];
        //构建一个日期对象 这个对象的时区是0
        localDate=[formatter dateFromString:[NSString stringWithFormat:@"%@ %@",dateStr,timeStr]];
        timeqq =[NSString stringWithFormat:@"%@ %@+0000",dateStr,timeStr];
    
    }
    
    NSArray * timarr = [timeqq componentsSeparatedByString:@"+"];
    
//    NSDate *date=[NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//     [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];//系统所在时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *datesstr = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",timarr[0]]];
    
    NSTimeInterval a=[datesstr timeIntervalSince1970]+8 * 60 * 60; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    
    NSString * newtimestr = [[NSString alloc]init];
    if (timeString.length>6) {
        newtimestr = timeString;
    }else{
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        newtimestr = [NSString stringWithFormat:@"%f", a];
    }
    
    
    
    
    
    
    NSLog(@"localdate=====%@",datesstr);//2015-11-20 00:37:40 +0000
    
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    
    dateFormatter.dateFormat=@"yyyy-MM-dd hh:mm:ss";//指定转date得日期格式化形式
    
    NSLog(@"时间===%@",[dateFormatter stringFromDate:localDate]);//2015-11-20 08:24:04
    
    int type=0;//用于保存内容类型
    if (msg.length>4&&[[msg substringToIndex:4]isEqualToString:@"[/1]"])
    {
        type=kWCMessageTypeImage;
        msg=[msg substringFromIndex:4];
    }
    //判断是否为发送语音
    else if (msg.length>4&&[[msg substringToIndex:4]isEqualToString:@"[/2]"])
    {
        type=kWCMessageTypeVoice;
        msg=[msg substringFromIndex:4];
    }
    else if(msg.length>4&&[[msg substringToIndex:4]isEqualToString:@"[/3]"])
    {
        type=kWCMessageTypeFace;
        msg=[msg substringFromIndex:4];
    }
        NSArray *strs=[from componentsSeparatedByString:@"@"];
        NSArray * tostr = [from componentsSeparatedByString:@"/"];
    
    NSMutableArray *mdictArray = [[NSMutableArray alloc]init];
   
    NSString * touserphoto = [[NSString alloc]init];
    if (self.ToUserPhoto.length>1) {
        touserphoto = self.ToUserPhoto;
    }else{
        NSMutableArray * arry = [WCMessageObject fetchAllUserMessageInfo:SharedAppDelegate.username];;
        
        for (WCMessageObject * wcmes in arry) {
            if ([wcmes.userId isEqualToString:[NSString stringWithFormat:@"%@",tostr[1]]]) {
                touserphoto =wcmes.userHead;
            }
        }
    }
    //14045@test-u-1.thinktank.com/IOS
    
    NSString * statestr =[[NSString alloc]init];
    NSString * userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    if ([tostr[1] isEqualToString:userid]) {
        statestr =@"0";
    }else{
        statestr =@"1";
    }
   
    NSDictionary * messagedic=@{@"from":strs[0],@"to":tostr[1],@"content":msg,@"username":[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"],@"time":newtimestr,@"type":[NSNumber numberWithInt:type],@"state":statestr,@"myicon":_myicon,@"outhericon":touserphoto,@"messageId":@"1"};
    
            Message *messagess =[Message messageWithDictionary:messagedic];
            MessageFrame *lastMessageFrame = [mdictArray lastObject];
            if (lastMessageFrame && [messagess.time isEqualToString:lastMessageFrame.message.time])
            {
                messagess.hideTime = YES;
            }
            // 判断是否发送时间与上一条信息的发送时间相同，若是则不用显示了
            MessageFrame *messageFrame = [[MessageFrame alloc] init];
            messageFrame.message = messagess;
            [_groupchatApp addObject:messageFrame];
    
    
//    _groupchatApp = mdictArray;

    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_groupchatApp.count -1 inSection:0];
    NSLog(@"========indexpath===%@    message.cou====%lu",lastIndexPath,(unsigned long)_groupchatApp.count);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self reloadTable];
        });
    });
    
    
   
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _messages = [[NSMutableArray alloc]init];
    _groupchatApp = [[NSMutableArray alloc]init];
//    XMPPRoomCoreDataStorage *rosterstorage = [XMPPRoomCoreDataStorage sharedInstance];
    [XMPPServer sharedServer].room = [[XMPPRoom alloc] initWithRoomStorage:SharedAppDelegate.rosterstorage jid:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@conference.%@",_userNickname,OpenFireHostName]] dispatchQueue:dispatch_get_main_queue()];
    //        [rosterstorage release];
    [[XMPPServer sharedServer].room activate:[XMPPServer sharedServer].xmppStream];
    [[XMPPServer sharedServer].room joinRoomUsingNickname:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]] history:nil];
    [[XMPPServer sharedServer].room configureRoomUsingOptions:nil];
    [[XMPPServer sharedServer].room addDelegate:self delegateQueue:dispatch_queue_create("com.ttd.roomqueue", NULL)];
    
    
    
    [self CreateTab];
    self.view.backgroundColor =BACKGROUD_COLOR;
    //右侧按钮
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"call.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightbut)];
    
    
    _sendmessage=[[NSString alloc]init];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    //    [XMPPServer sharedServer].messageDelegate = self;
    
    UIScrollView * scorv=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    if (UI_Is_iPhoneX) {
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60);
    }else{
        self.view.frame = scorv.frame;
    }
    
    
    NSLog(@"上页传递过来的数据==%@ \n%@ \n%@ ",self.chatWithUser,self.userNickname,self.ToUserPhoto);
    _myicon=[[NSUserDefaults standardUserDefaults] valueForKey:USER_PHOTO];
    //    NSLog(@"我的头像==%@",_myicon);
    UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 20, SCREEN_WIDTH/2-60, 30)];
    
    [lab setText:self.userNickname];
    [lab setTextColor:[UIColor whiteColor]];
    [lab setTextAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = lab;
    
    
    self.tabBarController.tabBar.hidden = YES;
    _keyboardBar = [[UIKeyboardBar alloc]init];
    
    [_keyboardBar setFrame:CGRectMake(0,self.view.frame.size.height-110, SCREEN_WIDTH, 50)];
    _keyboardBar.expressionBundleName = @"FaceExpression";
    _keyboardBar.barDelegate = self;
    _keyboardBar.KeyboardMoreImages = @[@"ToolVieMoreKeyboardCamera@2x",@"ToolVieMoreKeyboardPhotos@2x",@"ToolVieMoreViedo@2"];
    _keyboardBar.KeyboardMoreTitles = @[@"Camera",@"Photo"];
    _keyboardBar.keyboardTypes = @[@(UIKeyboardChatTypeKeyboard),@(UIKeyboardChatTypeVoice),@(UIKeyboardChatTypeMore)];
    
    [self.view addSubview:_keyboardBar];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self reloadTable];
    
}
#pragma mark -导航右侧按钮
-(void)rightbut{
   //self.ToUserPhoto
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString * sessionID = [NSString stringWithFormat:@"%@%f",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"],interval];
    
    //    NSArray *strs=[_chatWithUser componentsSeparatedByString:@"@"];
    //    NSString * otherName =strs[0];
    ZNManyPeopleVideoViewController * znmanyvideo = [[ZNManyPeopleVideoViewController alloc]init];
    znmanyvideo.mtarr =   [ NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@@%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"],OpenFireHostName],self.chatWithUser, nil];
    
    znmanyvideo.SessionID = sessionID;
    [self presentViewController:znmanyvideo animated:YES completion:nil];
    // 创建房间唯一标示
    
    //    NSArray * personArr =  [NSArray arrayWithObjects:self.chatWithUser,[NSString stringWithFormat:@"%@@test-u-1.thinktank.com",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]], nil];
    NSString * personStr = [NSString stringWithFormat:@"%@||%@",self.chatWithUser,[NSString stringWithFormat:@"%@@%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"],OpenFireHostName]];
    NSString * bodystr =[NSString stringWithFormat:@"sendVideo//%@//%@",sessionID,personStr];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString * bodyStr=[NSString stringWithFormat:@"%@*%@",dateString,bodystr];
    NSMutableString *soundString = [[NSMutableString alloc]initWithString:@"[/9]"];
    [soundString appendString:bodyStr];
    //    NSLog(@"发送的音频数据===%@",soundString);
    //发送消息
    //XMPPFramework主要是通过KissXML来生成XML文件
    //生成<body>文档
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:soundString];
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:self.chatWithUser];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    //组合
    [mes addChild:body];
    NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [mes addChild:received];
    [[XMPPServer xmppStream] sendElement:mes];
    NSLog(@"发起视频请求==%@  接收者==%@",soundString,self.chatWithUser);
    
    
    
}

-(void)receiveNotif:(NSNotification *)notif {
//    [self reloadTable];
}
-(void)receiveMessageNotif:(NSNotification *)notif {
//    [self reloadTable];
}


-(void)CreateTab {
    _audiotime=[[NSString alloc]init];
    
    //发送回执通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotif:) name:@"senmessage" object:nil];
//    //收到消息通知 ReceiveMessage
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageNotif:) name:@"ReceiveMessage" object:nil];
    
    NSArray *strs=[_chatWithUser componentsSeparatedByString:@"@"];
    //更新小红点数据==下发代码为主
    [WCMessageObject UpdataMessageState:strs[0] UserName:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
//    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    self.table=[[UITableView alloc]init];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.backgroundColor = BACKGROUD_COLOR;
    //    self.table.backgroundColor = [UIColor whiteColor];
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-110);
    // 禁止选中cell
    [self.table setAllowsSelection:NO];
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messages.count -1 inSection:0];
    NSLog(@"indexpath===%@    message.cou====%lu",lastIndexPath,(unsigned long)self.messages.count);
    if (self.messages.count>1) {
        [self.view addSubview:self.table ];
        [self.table scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }else{
        [self.view addSubview:self.table];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidess:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.messages = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.table reloadData];
        
        if( self.messages.count<2){
            [self.table reloadData];
        }else{
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
            [self.table scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    });
    
}

- (void)keyboardShow:(NSNotification *)notification{
    NSLog(@"打开键盘");
    UIScrollView * scorv=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.frame = scorv.frame;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    self.table.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-height-50);
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
    if (self.messages.count>1) {
        
        [self.table scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        [_keyboardBar setFrame:CGRectMake(0, self.table.frame.size.height, self.view.frame.size.width, 50)];
    }
}
-(void)keyboardHidess:(NSNotification *)notification {
    NSLog(@"关闭键盘");

    [_keyboardBar setFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    
    [UIView animateWithDuration:0.3f animations:^{
        [_keyboardBar setFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
        self.table.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark -- 键盘协议 UIKeyboardBarDelegate --
- (void)keyboardBar:(UIKeyboardBar *)keyboard didChangeFrame:(CGRect)frame{
    UIScrollView * scorv=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.frame = scorv.frame;
    if (keyboard.type == 3) {
        NSLog(@"点击的是表情🏷");
        [UIView animateWithDuration:0.3f animations:^{
            [keyboard setFrame:CGRectMake(0, SCREEN_HEIGHT-260, SCREEN_WIDTH, 50)];
            [keyboard.faceView setFrame:CGRectMake(0, SCREEN_HEIGHT-210, SCREEN_WIDTH, 210)];
            [self.table setFrame:CGRectMake(0, 0, MainScreenSizeWidth, SCREEN_HEIGHT-259)];
        } completion:^(BOOL finished) {
        }];
    }else if (keyboard.type ==5){
        NSLog(@"点击是更多☁️☁️");
        [UIView animateWithDuration:0.3f animations:^{
            
            [keyboard setFrame:CGRectMake(0, SCREEN_HEIGHT-260, SCREEN_WIDTH, 50)];
            [keyboard.moreView setFrame:CGRectMake(0, SCREEN_HEIGHT-210, SCREEN_WIDTH, 210)];
            [self.table setFrame:CGRectMake(0, 0, MainScreenSizeWidth, SCREEN_HEIGHT-259)];
            
        }completion:^(BOOL finished) {
        }];
        
    }else if (keyboard.type ==4){
        NSLog(@"点击的是语音🌧🌧🌧🌧");
        [UIView animateWithDuration:0.3f animations:^{
            
            [keyboard setFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
            self.table.frame=CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-50);
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (keyboard.type ==2){
        NSLog(@"回复默认⌨️⌨️⌨️");
        //NSUserDefaults
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * strhid =[defaults objectForKey:@"keyhid"];
        NSLog(@"键盘高度 ===%@",strhid);
        
        [UIView animateWithDuration:0.3f animations:^{
            
            [keyboard setFrame:CGRectMake(0, SCREEN_HEIGHT-[strhid intValue] -50, SCREEN_WIDTH, 50)];
            self.table.frame=CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-60-[strhid intValue]);
            
        } completion:^(BOOL finished) {
        }];
    }else if (keyboard.type ==1){
        NSLog(@"默认状态默认状态");
    }
    
}
#pragma mark 键盘更多操作 0-相机；1-相册；
- (void)keyboardBar:(UIKeyboardBar *)keyboard moreHandleAtItemIndex:(NSInteger)index{
    NSLog(@"--------- \n选择更多操作 index = %ld",(long)index);
    //创建_imagePickerController对象
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = NO;//图像是否可以剪裁
    
    
    if (index == 0) {
        NSLog(@"点击了相机");
        [self selectImageFromCamera];
    }else{
        NSLog(@"点击了相册");
        [self selectImageFromAlbum];
    }
    
}
#pragma mark -发送消息类型
- (void)keyboardBar:(UIKeyboardBar *)keyboard sendContent:(NSString *)message{
    NSLog(@"--------- \n发送文本 message = %@",message);
    [self sendMessageWithContent:message andType:MessageTypeMe andmodeType:MessageTextType];
    
}
#pragma mark - 录音地址，长度
- (void)keyboardBar:(UIKeyboardBar *)keyboard sendVoiceWithFilePath:(NSString *)path seconds:(NSTimeInterval)seconds{
    NSLog(@"--------- \n发送录制语音 path = %@,语音时长 = %lf",path,seconds);
    _audiotime =[NSString stringWithFormat:@"%f",seconds];
    NSInteger avtime = [_audiotime integerValue];
    NSLog(@"audiotime====%@",_audiotime);
    
    //发送音频文件
    [self sendAVIPath:path andAvitime:avtime];
}
#pragma mark -为导航返回按钮
-(void)backgo
{
    NSLog(@"点击了返回按钮");
}
#pragma mark -空白处回收键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - dataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.messages.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [MessageCell cellWithTableView:self.table];
    cell.messageFrame = self.messages[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - tableView代理方法
/** 动态设置每个cell的高度 */
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageFrame *messageFrame = self.messages[indexPath.row];
    return messageFrame.cellHeight;
}

#pragma mark - scrollView 代理方法
/** 点击拖曳聊天区的时候，缩回键盘 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 1.缩回键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


#pragma mark -发送文本消息
- (void) sendMessageWithContent:(NSString *) text andType:(MessageType) type andmodeType:(MessagepicType) modetype{
    //messageaudiotimes' VARCHAR ,'messagesendType' INTEGER )";
    NSString * namestr = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSXMLElement * body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:text] ;
    NSXMLElement * mes = [NSXMLElement elementWithName:@"message"];
    [mes addAttributeWithName:@"type" stringValue:@"groupchat"];
    [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@conference.%@",self.userNickname,OpenFireHostName]];
    [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    [mes addAttributeWithName:@"sendType" stringValue:@"0"];
    [mes addAttributeWithName:@"audiotimes" stringValue:@"0"];
    NSString * siID = [XMPPStream generateUUID];
    [mes addAttributeWithName:@"id" stringValue:siID];
    [mes addChild:body];
    NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [mes addChild:received];
    [[XMPPServer xmppStream] sendElement:mes];
}
#pragma mark -发送图片消息
-(void)sendIMage:(UIImage *)img {
    NSString *imgstr = [Photo image2String:img];
    if (imgstr.length > 0) {
        NSMutableString *imagestring = [[NSMutableString alloc]initWithString:@"[/1]"];
        [imagestring appendString:imgstr];
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:imagestring];
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"groupchat"];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@conference.%@",self.userNickname,OpenFireHostName]];
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
        [mes addAttributeWithName:@"sendType" stringValue:@"0"];
        [mes addAttributeWithName:@"audiotimes" stringValue:@"0"];
        NSString * siID = [XMPPStream generateUUID];
        [mes addAttributeWithName:@"id" stringValue:siID];
        //组合
        [mes addChild:body];
        NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        [mes addChild:received];
        [[XMPPServer xmppStream] sendElement:mes];
        
    }
    
}

#pragma mark -发送yinpin消息
-(void)sendAVIPath:(NSString *)pathfiled andAvitime:(NSInteger )time {
    
    NSString *wavFilePath = [[pathfiled stringByDeletingPathExtension]
                             stringByAppendingPathExtension:@"wav"];
    
    [NSVoiceConverter amrToWav:pathfiled wavSavePath:wavFilePath];
    NSLog(@"转换后的格式===%@",wavFilePath);
    
    NSString * filename =[wavFilePath lastPathComponent];
    NSLog(@"转换后的文件名===%@",filename);
    
    if(time>=1) {
        NSData *data = [NSData dataWithContentsOfFile:wavFilePath];

        NSString* base64 = [data base64EncodedString];
        NSMutableString *soundString = [[NSMutableString alloc]initWithString:@"[/2]"];
        [soundString appendString:base64];
        NSLog(@"发送的音频数据===%@",soundString);
        //发送消息
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:soundString];
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"groupchat"];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@conference.%@",self.userNickname]];
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
        NSString * siID = [XMPPStream generateUUID];
        [mes addAttributeWithName:@"id" stringValue:siID];
        //组合
        [mes addChild:body];
        NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        [mes addChild:received];
        [[XMPPServer xmppStream] sendElement:mes];
        
    }
    
}

#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    _imagePickerController.videoMaximumDuration = 15;
    
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}
#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}
#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
}
#pragma mark 适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage * img=[[UIImage alloc]init];
        img = info[UIImagePickerControllerOriginalImage];
        //压缩图片
        NSData *fileData = UIImageJPEGRepresentation(img, 0.5);
        UIImage * newimg = [UIImage imageWithData:fileData];
        
        //发送图片消息
        [self sendIMage:newimg];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    NSLog(@"图片保存后的回调==img=%@",image);
    
}
#pragma mark -  刷新并滑滚底部
-(void)reloadTable {
//    self.messages = nil;
    self.messages = self.groupchatApp;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.table reloadData];
//                [_keyboardBar.moreView removeFromSuperview];
//                [_keyboardBar setFrame:CGRectMake(0,self.view.frame.size.height-50, SCREEN_WIDTH, 50)];
//                self.table.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50);
        if (self.messages.count<1) {
            
        }else{
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
            [self.table scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
//
        
    });
}
#pragma mark - cell 代理事件
-(void)Clickimage:(UIImage *)image {
    NSLog(@"cell 代理事件==%@",self.messages);
    
}

-(void)CllickImageIndex:(NSNumber *)ind {
    NSLog(@"点击的是第%@个cell",ind);
    
//    ZNLPImgViewController * znlp = [[ZNLPImgViewController alloc]init];
//    znlp.indextstr = [NSString stringWithFormat:@"%@",ind];
//    [self presentViewController:znlp animated:NO completion:nil];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    ZNLPImgViewController * znlp = [[ZNLPImgViewController alloc]init];
    znlp.indextstr = [NSString stringWithFormat:@"%@",ind];
    [self presentViewController:znlp animated:NO completion:nil];
    
}
-(void)scrolllview {
    UIView * view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor blackColor];
    
}

-(void)playAVi:(NSString *)AVIStr {
    NSLog(@"AVI 代理方法===%@",AVIStr);
}

#pragma mark - 接收广播
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"zn离开聊天页面");
    MessageCell *cell = [[MessageCell alloc]init];
    [cell.player stop];
    
}
-(void)dealloc {
    NSLog(@"离开聊天页面");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"senmessage" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ReceiveMessage" object:nil];
    
}

#pragma mark - 数据加载
/** 延迟加载plist文件数据 */
//- (NSMutableArray *)messages {
//    if (nil == _messages) {
//
//        _messages = [[NSMutableArray alloc]init];
////        FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
////
////        NSArray *strs=[_chatWithUser componentsSeparatedByString:@"@"];
////
////        NSString *queryString=[NSString stringWithFormat:@" select * from wcMessage  order by  messageFrom=? desc "];
////
////        if (![db open]) {
////            NSLog(@"数据打开失败");
////            return _messages;
////        }
////
////        FMResultSet * rs =[db executeQuery:queryString,strs[0]];
////
////        NSMutableArray *mdictArray = [[NSMutableArray alloc]init];
////        NSString * state = [[NSString alloc]init];;
////
////
////        while ([rs next]) {
////            NSString *  messageFrome = [rs objectForColumnName:@"messageFrom"];
////            NSString * messageTo = [rs objectForColumnName:@"messageTo"];
////            NSString * messageContent = [rs objectForColumnName:@"messageContent"];
////            NSString * username = [rs objectForColumnName:@"username"];
////            NSNumber * messageDate = [rs objectForColumnName:@"messageDate"];
////            NSNumber * messageType = [rs objectForColumnName:@"messageType"];
////            NSString * messageState = [rs objectForColumnName:@"messageState"];
////            NSString * messageId = [rs objectForColumnName:@"messageId"];
////
////
////            if ([messageFrome isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]]) {
////                state = @"0";
////            }else{
////                state =@"1";
////            }
////
////            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
////
////            NSString* str = [numberFormatter stringFromNumber:messageDate];
////            NSArray *temp=[str componentsSeparatedByString:@"."];
////            NSString * touserphoto = [[NSString alloc]init];
////            if (self.ToUserPhoto.length>1) {
////                touserphoto = self.ToUserPhoto;
////            }else{
////                touserphoto = @"";
////            }
////
////            if (messageContent.length>1) {
////                NSDictionary * messagedic=@{@"form":messageFrome,@"to":messageTo,@"content":messageContent,@"username":username,@"time":[temp firstObject],@"type":messageType,@"state":state,@"myicon":_myicon,@"outhericon":touserphoto,@"messageId":messageId};
////
////
////                Message *message =[Message messageWithDictionary:messagedic];
////                MessageFrame *lastMessageFrame = [mdictArray lastObject];
////                if (lastMessageFrame && [message.time isEqualToString:lastMessageFrame.message.time])
////                {
////                    message.hideTime = YES;
////                }
////                // 判断是否发送时间与上一条信息的发送时间相同，若是则不用显示了
////                MessageFrame *messageFrame = [[MessageFrame alloc] init];
////                messageFrame.message = message;
////                [mdictArray addObject:messageFrame];
////            }
////
////        }
////        _messages = mdictArray;
//    }
//    return _messages;
//}

@end
