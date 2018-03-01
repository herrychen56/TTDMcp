//
//  ZNChatMessageViewController.m
//  TTD
//
//  Created by quakoo on 2017/12/8.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "ZNChatMessageViewController.h"
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

@interface ZNChatMessageViewController ()<UITableViewDataSource, UITableViewDelegate, UIKeyboardBarDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,MessCellDelegate,KKMessageDelegate,XMPPStreamDelegate,MessCellDelegate>
{
    int stactheight;
    CGRect tabRect;//正常tab
    CGRect tabRectTwo;//键盘其他功能弹出后tab
    CGRect keybarRect;//正常键盘
    CGRect KeyMoreRect;//多功能键盘
    
}
/** 聊天区tableView */
//@property (weak, nonatomic) IBOutlet UITableView *tableView;

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

@end

@implementation ZNChatMessageViewController

#pragma mark --更新状态栏
   //监听状态栏的改变
-(void)statusBarChange{
    //    [self CreateTab];
    
    
    
    stactheight = 1;
    [self oneCreateTab];
}
//修改数据库后更新页面
-(void)chatreload{
//    self.messages = nil;
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 更新界面
//            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
//            if (self.messages.count>3) {
////                [self.table scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//            }else{
//                [self.table reloadData];
//            }
//        });
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatreload) name:@"chattabreload" object:nil];
    UIScrollView * scorv=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    if (UI_Is_iPhoneX) {
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60);
    }else{
        self.view.frame = scorv.frame;
    }
 
    //监听状态栏的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(statusBarChange) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
    NSString * str = [NSString stringWithFormat:@"%@", SharedAppDelegate.rectstatus];
    int  stactin = [str intValue];
    if (stactin<=20) {
         stactheight = 0;
    }else{
        stactheight = 1;
    }
    
    
    if (self.Isgroup == YES) {
        NSLog(@"群组聊天~~~~~~");
        
        XMPPRoomCoreDataStorage *rosterstorage = [[XMPPRoomCoreDataStorage alloc] init];
        [XMPPServer sharedServer].room = [[XMPPRoom alloc] initWithRoomStorage:rosterstorage jid:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@conference.%@",_userNickname,OpenFireHostName]] dispatchQueue:dispatch_get_main_queue()];
//        [rosterstorage release];
        [[XMPPServer sharedServer].room activate:[XMPPServer sharedServer].xmppStream];
        [[XMPPServer sharedServer].room joinRoomUsingNickname:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]] history:nil];
        [[XMPPServer sharedServer].room configureRoomUsingOptions:nil];
        [[XMPPServer sharedServer].room addDelegate:self delegateQueue:dispatch_queue_create("com.ttd.roomqueue", NULL)];
        
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
    
    _audiotime=[[NSString alloc]init];
    
    
    self.view.backgroundColor =BACKGROUD_COLOR;
    
    //右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"call.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightbut)];
    
    
    _sendmessage=[[NSString alloc]init];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    _keyboardBar = [[UIKeyboardBar alloc]init];
    [self.view addSubview:_keyboardBar];
    self.table=[[UITableView alloc]init];
    //      [self.view addSubview:_keyboardBar];

    [self oneCreateTab];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    NSArray *strs=[_chatWithUser componentsSeparatedByString:@"@"];
    //更新小红点数据==下发代码为主
    [WCMessageObject UpdataMessageState:strs[0] UserName:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    
    self.table.backgroundColor = BACKGROUD_COLOR;
    self.table.backgroundColor = [UIColor whiteColor];
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 禁止选中cell
    [self.table setAllowsSelection:NO];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidess:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //发送回执通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotif:) name:@"senmessage" object:nil];
    
  
    
    //收到消息通知 ReceiveMessage
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageNotif:) name:@"ReceiveMessage" object:nil];
    
}

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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReceiveMessage" object:nil];
    
    NSLog(@"有人在群里发言：%@ ", message);
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *xmltype = [[message attributeForName:@"type"] stringValue];
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
    
    //创建message对象 保存纪录 andy
    WCMessageObject *msges=[WCMessageObject messageWithType:type];
    NSArray *strs=[from componentsSeparatedByString:@"@"];
    [msges setMessageDate:[NSDate date]];
    [msges setMessageFrom:strs[0]];
    [msges setMessageContent:msg];
    [msges setMessageTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]];
    //[msges setMessageType:[NSNumber numberWithInt:kWCMessageTypePlain]];
    [msges setMessageType:[NSNumber numberWithInt:type]];
    [msges setUsername:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    [msges setMessageState:@"1"];
    [msges setUserHead:nil];
    //            [msges setMessageaudioTimes:@1];
    [WCMessageObject save:msges];
    //NSLog(@"mag is :%@",msg);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (msg !=nil) {
        [dict setObject:msg forKey:@"msg"];
        [dict setObject:from forKey:@"sender"];
        //消息接收到的时间
        [dict setObject:[Statics getCurrentTime] forKey:@"time"];
        //消息委托
        [_messageDelegate newMessageReceived:dict];
        NSLog(@"=========收到来自%@消息：%@ type ==%d",from,msg,type);
        [_chatDelegate messageContentNotice];
    
    
    
}
}

#pragma mark -导航右侧按钮 -- 视频聊天
-(void)rightbut{
    
    NSLog(@"点击导航右侧按钮%@",_chatWithUser); //self.ToUserPhoto
    
    NSString * tokboxkey=[[NSString alloc]init];
    NSString * tokboxsecert = [[NSString alloc]init];
    
    tokboxsecert = [NSString stringWithFormat:@"%@",TOKBOXSECERT];
    tokboxkey = [NSString stringWithFormat:@"%@",TOKBOXAPIKEY];
    
    
    //获取tokbox session
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            [NSString stringWithFormat:@"%@",tokboxkey], @"apikey",
                            [NSString stringWithFormat:@"%@",tokboxsecert], @"secret",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_TkboxSessionByMobile parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         ZNgetTokBoxSession * znmettings = [ZNgetTokBoxSession responseWithDDXMLDocument:XMLDocument];
         NSString * json = znmettings.tokgetTokboxSessionByMobile;
         
         NSDictionary * tokboxjson = [SharedAppDelegate dictionaryWithJsonString:json];
         NSString * tokboxSession =[tokboxjson objectForKey:@"Id"];
         NSLog(@"tokboxsession 成功 == %@",tokboxSession);
         dispatch_async(dispatch_get_main_queue(), ^{
             
             NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
             NSString * sessionID = [NSString stringWithFormat:@"%@%f",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"],interval];
             
             NSArray *strs=[_chatWithUser componentsSeparatedByString:@"@"];
             NSString * otherName =strs[0];
             
             // 创建房间唯一标示
             NSString * personStr = [NSString stringWithFormat:@"%@||%@||%@",self.chatWithUser,[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]],tokboxSession];
             //    NSString * bodystr =[NSString stringWithFormat:@"sendVideo//%@//%@",sessionID,personStr];
             NSString * bodystr=  [NSString stringWithFormat:@"twopersonvideo//%@//%@",sessionID,personStr];
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
             if (self.Isgroup == YES) {
                 //消息类型
                 [mes addAttributeWithName:@"type" stringValue:@"groupchat"];
                 //发送给谁
                 [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@",self.chatWithUser]];
             }else{
                 //消息类型
                 [mes addAttributeWithName:@"type" stringValue:@"chat"];
                 //发送给谁
                 [mes addAttributeWithName:@"to" stringValue:_chatWithUser];
             }
             
             //由谁发送
             [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
             //组合
             [mes addChild:body];
             NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
             [mes addChild:received];
             [[XMPPServer xmppStream] sendElement:mes];
             NSLog(@"发起视频请求==%@  接收者==%@",soundString,self.chatWithUser);
             
             ZNVideoWaitingViewController * TwoPersonVideoChat = [[ZNVideoWaitingViewController alloc]init];
             TwoPersonVideoChat.outherName =otherName;
             TwoPersonVideoChat.outToboxSession=tokboxSession;
             [self presentViewController:TwoPersonVideoChat animated:YES completion:nil];
             
         });
         
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         NSLog(@"失败===%@",error);
     }];
    [operation start];
}
-(void)receiveNotif:(NSNotification *)notif {
    NSLog(@"===receiveNotif==");
    [self reloadTable];
}
-(void)receiveMessageNotif:(NSNotification *)notif {
      NSLog(@"===receiveMessageNotif==");
    [self reloadTable];
}
-(void)oneCreateTab {
    
    NSLog(@"状态栏高度==%@",SharedAppDelegate.rectstatus);
   
    _keyboardBar.expressionBundleName = @"FaceExpression";
    _keyboardBar.barDelegate = self;
    if (stactheight ==1) {
        if (![SharedAppDelegate.rectstatus isEqualToString:@"20"]) {
             [_keyboardBar setFrame:CGRectMake(0,self.view.frame.size.height-130, SCREEN_WIDTH, 50)];
        }else{
             [_keyboardBar setFrame:CGRectMake(0,self.view.frame.size.height-110, SCREEN_WIDTH, 50)];
        }
    }else{
          [_keyboardBar setFrame:CGRectMake(0,self.view.frame.size.height-110, SCREEN_WIDTH, 50)];
    }
    
  
    _keyboardBar.KeyboardMoreImages = @[@"ToolVieMoreKeyboardCamera@2x",@"ToolVieMoreKeyboardPhotos@2x",@"ToolVieMoreViedo@2"];
    _keyboardBar.KeyboardMoreTitles = @[@"Camera",@"Photo"];
    _keyboardBar.keyboardTypes = @[@(UIKeyboardChatTypeKeyboard),@(UIKeyboardChatTypeVoice),@(UIKeyboardChatTypeMore)];

    
    
    self.table.dataSource = self;
    self.table.delegate = self;
    if (stactheight ==1) {
        self.table.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-130);
    }else{
    self.table.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-110);
    }
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messages.count -1 inSection:0];
    NSLog(@"indexpath===%@    message.cou====%lu",lastIndexPath,(unsigned long)self.messages.count);
    if (self.messages.count>1) {
        
        [self.table scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        [self.view addSubview:self.table];
    }else{
        [self.view addSubview:self.table];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"lailaialialai~~~~~~");
     //[self oneCreateTab];
     [self reloadTable];
//    self.messages = nil;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.table reloadData];
//
//         NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
//        if (self.messages.count>1) {
//            [self.table scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//        }else{
//
//        }
//
////        if( self.messages.count<2){
////            [self.table reloadData];
////        }else{
////            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
////            [self.table scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
////        }
//
//    });
    
}

- (void)keyboardShow:(NSNotification *)notification{
    NSLog(@"打开键盘");
    UIScrollView * scorv=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.frame = scorv.frame;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
//    _keyboardBar.type =2;
     if (stactheight ==1) {
         self.table.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-height-50-20);
         [_keyboardBar setFrame:CGRectMake(0, self.table.frame.size.height, self.view.frame.size.width, 50)];
     }else{
         self.table.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-height-50);
         [_keyboardBar setFrame:CGRectMake(0, self.table.frame.size.height, self.view.frame.size.width, 50)];
     }
    
    
   
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
    if (self.messages.count>1) {

        [self.table scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        [_keyboardBar setFrame:CGRectMake(0, self.view.frame.size.height-height-50, self.view.frame.size.width, 50)];
    }
}
-(void)keyboardHidess:(NSNotification *)notification {
    NSLog(@"关闭键盘");
    
//    [_keyboardBar setFrame:CGRectMake(0,self.view.frame.size.height-110, SCREEN_WIDTH, 50)];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        if (stactheight ==1) {
            [_keyboardBar setFrame:CGRectMake(0,self.view.frame.size.height-50-20, SCREEN_WIDTH, 50)];
            self.table.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50-20);;
        }else{
            [_keyboardBar setFrame:CGRectMake(0,self.view.frame.size.height-50, SCREEN_WIDTH, 50)];
            self.table.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50);;
        }
        
      
    } completion:^(BOOL finished) {
    }];
}

#pragma mark -- 键盘协议 UIKeyboardBarDelegate --
- (void)keyboardBar:(UIKeyboardBar *)keyboard didChangeFrame:(CGRect)frame{
    UIScrollView * scorv=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.frame = scorv.frame;
    NSLog(@"keyboard: %d",keyboard.type);
    if (keyboard.type == 3) {
        NSLog(@"点击的是表情🏷");
        [UIView animateWithDuration:0.3f animations:^{
            
            if (stactheight ==1) {
                
            }else{
                [keyboard setFrame:CGRectMake(0, SCREEN_HEIGHT-260, SCREEN_WIDTH, 50)];
                [keyboard.faceView setFrame:CGRectMake(0, SCREEN_HEIGHT-210, SCREEN_WIDTH, 210)];
                [self.table setFrame:CGRectMake(0, 0, MainScreenSizeWidth, SCREEN_HEIGHT-260)];
            }
            
           
        } completion:^(BOOL finished) {
        }];
    }else if (keyboard.type ==5){
        NSLog(@"点击是更多☁️☁️ frame==%f",frame.size.height);
        [UIView animateWithDuration:0.3f animations:^{
            
            if (stactheight ==1) {
                [keyboard setFrame:CGRectMake(0, SCREEN_HEIGHT-260-20, SCREEN_WIDTH, 50)];
                [keyboard.moreView setFrame:CGRectMake(0, SCREEN_HEIGHT-210-20, SCREEN_WIDTH, 210)];
                [self.table setFrame:CGRectMake(0, 0, MainScreenSizeWidth, SCREEN_HEIGHT-260)];
                
            }else{
                // Andy 2018/02/09 Image Keyboard HeiGht
                [keyboard setFrame:CGRectMake(0, SCREEN_HEIGHT-260-60, SCREEN_WIDTH, 50)];
                [keyboard.moreView setFrame:CGRectMake(0, SCREEN_HEIGHT-210-60, SCREEN_WIDTH, 270)];
                [self.table setFrame:CGRectMake(0, 0, MainScreenSizeWidth, SCREEN_HEIGHT-260-60)];
                
            }
         
            
            
        }completion:^(BOOL finished) {
        }];
        
    }else if (keyboard.type ==4){
        NSLog(@"点击的是语音🌧🌧🌧🌧");
        [UIView animateWithDuration:0.3f animations:^{
            if (stactheight ==1) {
                [keyboard setFrame:CGRectMake(0, SCREEN_HEIGHT-50-20, SCREEN_WIDTH, 50)];
                self.table.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50-20);
            }else{
                [keyboard setFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
                self.table.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50);
            }
            
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
            if (stactheight ==1) {
                [keyboard setFrame:CGRectMake(0, self.view.frame.size.height -[strhid intValue]-50-20, SCREEN_WIDTH, 50)];
                self.table.frame=CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height -[strhid intValue]-50-50-20);
            }else {
                [keyboard setFrame:CGRectMake(0, self.view.frame.size.height -[strhid intValue]-50, SCREEN_WIDTH, 50)];
                self.table.frame=CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height -[strhid intValue]-50);
            }
//
        
        } completion:^(BOOL finished) {
        }];
    }else if (keyboard.type ==1){
        NSLog(@"默认状态默认状态");
    }else if (keyboard.type ==0){        
        //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
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

#pragma mark - 数据加载
/** 延迟加载plist文件数据 */
- (NSMutableArray *)messages {
    if (nil == _messages) {
        
        _messages = [[NSMutableArray alloc]init];
        FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
        
        NSArray *strs=[_chatWithUser componentsSeparatedByString:@"@"];
        
        NSString *queryString=[NSString stringWithFormat:@"select * from (select * from wcMessage where (messageFrom=? or messageTo=?) and username=? order by messageDate desc limit 1000) as wc order by messageDate asc"];
        
        if (![db open]) {
            NSLog(@"数据打开失败");
            return _messages;
        }
        
        //        NSLog(@"对方=%@  my=%@    arr=%@",_chatWithUser,[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"],strs[0]);
        
        FMResultSet * rs =[db executeQuery:queryString,strs[0],strs[0],[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
        
        NSMutableArray *mdictArray = [[NSMutableArray alloc]init];
        NSString * state = [[NSString alloc]init];;
        
        
        while ([rs next]) {
            NSString *  messageFrome = [rs objectForColumnName:@"messageFrom"];
            NSString * messageTo = [rs objectForColumnName:@"messageTo"];
            NSString * messageContent = [rs objectForColumnName:@"messageContent"];
            NSString * username = [rs objectForColumnName:@"username"];
            NSNumber * messageDate = [rs objectForColumnName:@"messageDate"];
            NSNumber * messageType = [rs objectForColumnName:@"messageType"];
            NSString * messageState = [rs objectForColumnName:@"messageState"];
            NSString * messageId = [rs objectForColumnName:@"messageId"];
            NSNumber * messagesendType = [rs objectForColumnName:@"messagesendType"];
            
            
            if ([messageFrome isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]]) {
                state = @"0";
            }else{
                state =@"1";
            }
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            
            NSString* str = [numberFormatter stringFromNumber:messageDate];
            NSArray *temp=[str componentsSeparatedByString:@"."];
            NSString * touserphoto = [[NSString alloc]init];
            if (self.ToUserPhoto.length>1) {
                touserphoto = self.ToUserPhoto;
            }else{
                touserphoto = @" ";
            }
            
            if (messageContent.length>0) {
                NSDictionary * messagedic=@{@"form":messageFrome,@"to":messageTo,@"content":messageContent,@"username":username,@"time":[temp firstObject],@"type":messageType,@"state":state,@"myicon":_myicon,@"outhericon":touserphoto,@"messageId":messageId,@"messagesendType":messagesendType};
                
                
                Message *message =[Message messageWithDictionary:messagedic];
                MessageFrame *lastMessageFrame = [mdictArray lastObject];
                
                if (lastMessageFrame && [message.time isEqualToString:lastMessageFrame.message.time])
                {
                    message.hideTime = YES;
                }
                // 判断是否发送时间与上一条信息的发送时间相同，若是则不用显示了
                MessageFrame *messageFrame = [[MessageFrame alloc] init];
                messageFrame.message = message;
                [mdictArray addObject:messageFrame];
            }
            
            
            
        }
        _messages = mdictArray;
        
    }
    return _messages;
}

#pragma mark - dataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.messages.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [MessageCell cellWithTableView:self.table];
    cell.backgroundColor = [UIColor whiteColor];
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
//    NSDate *date= [NSDate date];
    NSString * str =[NSString stringWithFormat:@"%lu", (unsigned long)self.messages.count+1];
    //messageaudiotimes' VARCHAR ,'messagesendType' INTEGER )";
        NSXMLElement * body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:text];
        NSXMLElement * mes = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"chat"];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:_chatWithUser];
        [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
        [mes addAttributeWithName:@"sendType" stringValue:@"0"];
        [mes addAttributeWithName:@"audiotimes" stringValue:@"0"];
        NSString * siID = [XMPPStream generateUUID];
        [mes addAttributeWithName:@"id" stringValue:siID];
    [mes addAttributeWithName:@"messageid" stringValue:str];
        [mes addChild:body];
        NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        [mes addChild:received];
        [[XMPPServer xmppStream] sendElement:mes];
    //存库
    WCMessageObject *messageObject=[[WCMessageObject alloc] init];
    messageObject.messageContent=text;
    messageObject.messageFrom=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    messageObject.messageTo=_chatWithUser;
    messageObject.messagesendType =@1;
//    messageObject.messageDate = date;
    [[XMPPServer sharedServer] sendMessage:messageObject];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"senmessage" object:nil];
    
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}
#pragma mark -发送图片消息
-(void)sendIMage:(UIImage *)img {
    NSString *imgstr = [Photo image2String:img];
    if (imgstr.length > 0) {
        NSMutableString *imagestring = [[NSMutableString alloc]initWithString:@"[/1]"];
        [imagestring appendString:imgstr];
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:imagestring];
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
            //消息类型
            [mes addAttributeWithName:@"type" stringValue:@"chat"];
            //发送给谁
            [mes addAttributeWithName:@"to" stringValue:_chatWithUser];
        
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
        
        
        [mes addAttributeWithName:@"sendType" stringValue:@"0"];
        [mes addAttributeWithName:@"audiotimes" stringValue:@"0"];
        
        //组合
        [mes addChild:body];
        NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        [mes addChild:received];
        [[XMPPServer xmppStream] sendElement:mes];
        
        //存库
        WCMessageObject *messageObject=[[WCMessageObject alloc] init];
        messageObject.messageContent=imagestring;
        messageObject.messageFrom=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
        messageObject.messageTo=_chatWithUser;
        messageObject.messagesendType =@2;
        //    messageObject.messageDate = date;
        [[XMPPServer sharedServer] sendMessage:messageObject];
        
        
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
        //        NSString *base64 = [data base64 EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
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
        
        if (self.Isgroup == YES) {
            //消息类型
            [mes addAttributeWithName:@"type" stringValue:@"groupchat"];
            //发送给谁
            [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@",self.chatWithUser]];
        }else{
            //消息类型
            [mes addAttributeWithName:@"type" stringValue:@"chat"];
            //发送给谁
            [mes addAttributeWithName:@"to" stringValue:_chatWithUser];
        }
        
      
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
        [mes addAttributeWithName:@"sendType" stringValue:@"0"];
        [mes addAttributeWithName:@"audiotimes" stringValue:[NSString stringWithFormat:@"%ld",(long)time]];
        
        //组合
        [mes addChild:body];
        NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        [mes addChild:received];
        [[XMPPServer xmppStream] sendElement:mes];
        
        
        //存库
        WCMessageObject *messageObject=[[WCMessageObject alloc] init];
        messageObject.messageContent=soundString;
        messageObject.messageFrom=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
        messageObject.messageTo=_chatWithUser;
        messageObject.messagesendType =@3;
        //    messageObject.messageDate = date;
        [[XMPPServer sharedServer] sendMessage:messageObject];
        
        
    }
    
}

#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    _imagePickerController.videoMaximumDuration = 15;
    
    //    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
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
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.table reloadData];
////        [_keyboardBar.moreView removeFromSuperview];
////        [_keyboardBar setFrame:CGRectMake(0,self.view.frame.size.height-50, SCREEN_WIDTH, 50)];
////        self.table.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50);
//        if (self.messages.count<1) {
//
//        }else{
//            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
//            [self.table scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//        }
//
//
//    });
    self.messages = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.table reloadData];
        //[_keyboardBar.moreView removeFromSuperview];
        //[_keyboardBar setFrame:CGRectMake(0,self.view.frame.size.height-50, SCREEN_WIDTH, 50)];
        //self.table.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50);
        if (self.messages.count<1) {
            
        }else{
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
            [self.table scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        
        
    });
}
#pragma mark - cell 代理事件
-(void)Clickimage:(UIImage *)image {
    NSLog(@"cell 代理事件==%@",self.messages);
    
}


//发送失败
-(void)errorChageYes:(Message *)ind {
    NSLog(@"点击的是第%@个cell",ind);
    NSXMLElement * body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:ind.text];
    NSXMLElement * mes = [NSXMLElement elementWithName:@"message"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:_chatWithUser];
    [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    [mes addAttributeWithName:@"sendType" stringValue:@"0"];
    [mes addAttributeWithName:@"audiotimes" stringValue:@"0"];
    NSString * siID = [XMPPStream generateUUID];
    [mes addAttributeWithName:@"id" stringValue:siID];
    [mes addAttributeWithName:@"messageid" stringValue:[NSString stringWithFormat:@"%@",ind.messageId]];
    [mes addChild:body];
    NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [mes addChild:received];
    [[XMPPServer xmppStream] sendElement:mes];
}

-(void)CllickImageIndex:(NSNumber *)ind {
    NSLog(@"点击的是第%@个cell",ind);
    
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
    //更新小红点数据==下发代码为主
    NSArray *strs=[_chatWithUser componentsSeparatedByString:@"@"];
    [WCMessageObject UpdataMessageState:strs[0] UserName:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
}
-(void)dealloc {
    NSLog(@"离开聊天页面");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"senmessage" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ReceiveMessage" object:nil];
    
}
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // 添加一个删除按钮
//    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        NSLog(@"点击了删除");
//        // 1. 更新数据
//        //NSMutableArray *arrModel = self.datas[indexPath.section];
//        //[arrModel removeObjectAtIndex:indexPath.row];
//        // 2. 更新UI
////[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }];
//    
//    // 删除一个置顶按钮
//    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        NSLog(@"点击了置顶");
//        
//        // 1. 更新数据
//        //[self.dataSource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
//        
//        // 2. 更新UI
//        //NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
//        //[tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
//    }];
//    topRowAction.backgroundColor = [UIColor blueColor];
//    
//    // 添加一个更多按钮
//    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        NSLog(@"点击了更多");
//        
//        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
//    }];
//    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    
//    // 将设置好的按钮放到数组中返回
//    return @[deleteRowAction, topRowAction, moreRowAction];
//    
//}
@end

