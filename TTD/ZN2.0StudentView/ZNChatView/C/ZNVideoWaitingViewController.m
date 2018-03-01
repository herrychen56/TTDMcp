//
//  ZNVideoWaitingViewController.m
//  TTD
//
//  Created by quakoo on 2017/12/18.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "ZNVideoWaitingViewController.h"
#import <OpenTok/OpenTok.h>//TOKBOX
#import "NSData+Base64.h"
#import "ZNReceVideChaatViewController.h"
#import "UIView+MJAlertView.h"
//#import <MGBSHud/MGBSHUD.h>
#import "MBManager.h"
#import "MyAVAudioPlayer.h"

#import "FloatingWindow.h"
//#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGH [UIScreen mainScreen].bounds.size.height
#define UIIMGNAMED(img_name) [UIImage imageNamed:img_name]
// Replace with your OpenTok API key46024232
static NSString* kApiKey = @"46010342";
// Replace with your generated session ID  会话ID  2_MX40NjAyNDIzMn5-MTUxMzU3Njg2OTk4Mn41cE55OGZ2MlBIY1N1WXF0aTZ5ZU1SNFB-fg
static NSString* kSessionId = @"2_MX40NjAxMDMzMn5-MTUxNjI4OTgyNDk4M35DUlQ2QU1td3k5bjRzQytjWGd6eUhKM1l-UH4";
// Replace with your generated token 令牌
static NSString* kToken = @"T1==cGFydG5lcl9pZD00NjAxMDMzMiZzaWc9NWU4ZTNkYjM2NjljYzAzYTQyMTE3ZWM0ZWVjN2FhYTRkZTZhOTg3MjpzZXNzaW9uX2lkPTJfTVg0ME5qQXhNRE16TW41LU1UVXhOakk0T1RneU5EazRNMzVEVWxRMlFVMXRkM2s1YmpSelF5dGpXR2Q2ZVVoS00xbC1VSDQmY3JlYXRlX3RpbWU9MTUxNjI4OTg5MiZub25jZT0wLjk2Nzk1MTk2OTEzNDUwMDImcm9sZT1wdWJsaXNoZXImZXhwaXJlX3RpbWU9MTUxODg4MTg5MSZjb25uZWN0aW9uX2RhdGE9JTdCJTIydXNlck5hbWUlMjIlM0ElMjJVc2VyJTIyJTdEJmluaXRpYWxfbGF5b3V0X2NsYXNzX2xpc3Q9";




@interface ZNVideoWaitingViewController ()<OTSessionDelegate,OTPublisherDelegate,OTSubscriberDelegate>
@property (nonatomic) OTSession * session;//连接到会话
@property (nonatomic) OTPublisher * publisher;//发送流到会话
@property (nonatomic) OTSubscriber * subscriber;//订阅其他用户流
@property (nonatomic,assign) BOOL issub;
@property (nonatomic) OTPublisherSettings * publisherSettings;

@property(strong ,nonatomic) FloatingWindow *floatWindow;

@end

@implementation ZNVideoWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SharedAppDelegate.isvideo = YES;
    // Do any additional setup after loading the view from its nib.
    
    if (SharedAppDelegate.znvideochat == YES) {
        
    }
    
    
    NSLog(@"接收到对方的姓名=%@",SharedAppDelegate.otherPersonArr);
    if(SharedAppDelegate.otherPersonArr.count>=1)
    {
        self.outherName=SharedAppDelegate.otherPersonArr[1];
    }
    //禁止黑屏
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    
    self.floatWindow = [[FloatingWindow alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT/2-25, 50, 50) imageName:@"av_call"];
    [self.floatWindow makeKeyAndVisible];
    self.floatWindow.hidden = YES;
    //监听是否触发home键挂起程序.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    NSLog(@"接收到对方的姓名=%@",self.outherName);
    [self.backbutton addTarget:self action:@selector(disselfview) forControlEvents:UIControlEventTouchUpInside];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Theotherpartyrefusesto:) name:@"Theotherpartyrefusesto" object:nil];
    
    //收到挂断视频的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GDVideoChat) name:@"HangupVideoChat" object:nil];
    
    [self cretaeUI];
     [self openToxBox];

}
#pragma mark  -floatdelegate
-(void)assistiveTocuhs {
    
    
    self.floatWindow.isCannotTouch = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[MyAVAudioPlayer sharedAVAudioPlayer].player stop];
}
#pragma mark - 挂断通知
-(void)GDVideoChat {
     [[MyAVAudioPlayer sharedAVAudioPlayer]playMP3:@"videoGD"];
     [[MyAVAudioPlayer sharedAVAudioPlayer].player stop];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MyAVAudioPlayer sharedAVAudioPlayer].player stop];
            self.floatWindow.hidden = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
            [_session disconnect];
            //    deleage.isvideochat =[NSNumber numberWithInt:0];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"disconnectVideo" object:nil userInfo:nil];
            SharedAppDelegate.isvideo = NO;
          
           
        });
    });
    
}

#pragma mark - 触发home 键
- (void)applicationWillResignActive:(NSNotification *)notification
{
    NSLog(@"触发home按下");
    if (SharedAppDelegate.isvideo == YES) {
        
        self.floatWindow.isCannotTouch = NO;
        __weak typeof (self) weakSelf = self;
        self.floatWindow.floatDelegate = weakSelf;
        [self.floatWindow startWithTime:30 presentview:self.view inRect:CGRectMake(SCREEN_WIDTH/2-25,SCREEN_HEIGHT/2-25,50, 50)];//缩放位置
        [self dismissViewControllerAnimated:NO completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"disconnectVideo" object:nil userInfo:nil];
            
        }];
    }else{
        NSLog(@"没有视频中，无法缩放视频");
    }
    
}

#pragma mark - 返回上页
-(void)disselfview {

    self.floatWindow.isCannotTouch = NO;
    __weak typeof (self) weakSelf = self;
    self.floatWindow.floatDelegate = weakSelf;
    
    [self.floatWindow startWithTime:30 presentview:self.view inRect:CGRectMake(SCREEN_WIDTH/2-25,SCREEN_HEIGHT/2-25,50, 50)];//缩放位置
    
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"disconnectVideo" object:nil userInfo:nil];
        
    }];
}
#pragma mark -挂断视频
-(void)gdvideobutton {
    self.floatWindow.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    [_session disconnect];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"disconnectVideo" object:nil userInfo:nil];
    SharedAppDelegate.isvideo = NO;
    [self delVideoMessage];
}



#pragma mark - 收到对方拒绝视频聊天通知
-(void)Theotherpartyrefusesto:(NSNotification *)notif {
    NSLog(@"收到对方拒绝视频聊天通知");
    [LEEAlert alert].config
    .LeeTitle(@"Message")
    .LeeContent(@"The other person hangs up your video request ！")
    .LeeAction(@"confirm", ^{
        
    })
    .LeeShow();
}
-(void)cretaeUI {
    self.waitinglab.hidden = NO;
    //底部按钮
    [self.MKFButton addTarget:self action:@selector(oneButton:) forControlEvents:UIControlEventTouchUpInside];
    self.MKFButton.tag =100;
    [self.LXButton addTarget:self action:@selector(twoButton:) forControlEvents:UIControlEventTouchUpInside];
    self.LXButton.tag = 150;
    [self.SYButton addTarget:self action:@selector(threeButton:) forControlEvents:UIControlEventTouchUpInside];
    self.SYButton.tag = 200;
    [self.GDButton addTarget:self action:@selector(gdvideobutton) forControlEvents:UIControlEventTouchUpInside];
    //翻转摄像头
    [self.FZButton addTarget:self action:@selector(fziconVideoView:) forControlEvents:UIControlEventTouchUpInside];
    self.FZButton.tag=300;
    
    _publisherSettings = [[OTPublisherSettings alloc]init];
    _publisherSettings.name =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    self.waitinglab.text =[NSString stringWithFormat:@"%@",self.outherName];
    
}
#pragma mark 翻转摄像头
-(void)fziconVideoView:(UIButton *)button {
    UIButton * but = button;
    if (but.tag == 300) {
        _publisher.cameraPosition =AVCaptureDevicePositionBack;
        but.tag =301;
    }else if (but.tag == 301) {
        _publisher.cameraPosition =AVCaptureDevicePositionFront;
        but.tag = 300;
    }
}
#pragma mark 底部按钮点击事件
-(void)oneButton:(UIButton *)sender {
    NSLog(@"底部按钮1-话筒");
    UIButton * button = sender;
    if (button.tag == 100) {
        _publisher.publishAudio = NO;
        [button setImage:[UIImage imageNamed:@"1-2.png"] forState:UIControlStateNormal];
        [MBManager showAlertWithCustomImage:@"1-2.png" title:@"Audio unmuted"];
        NSLog(@"静音");
        button.tag =101;
    }else if (button.tag == 101) {
        _publisher.publishAudio = YES;
        NSLog(@"打开静音");
        [button setImage:[UIImage imageNamed:@"1-1.png"] forState:UIControlStateNormal];
        [MBManager showAlertWithCustomImage:@"1-1.png" title:@"Audio muted"];
        button.tag=100;
    }
    
}
-(void)twoButton:(UIButton *)sender {
    UIButton * but = sender;
    if (but.tag == 150) {
        [but setImage:[UIImage imageNamed:@"2-2.png"] forState:UIControlStateNormal];
        [MBManager showAlertWithCustomImage:@"2-2.png" title:@"Video Off"];
        _publisher.publishVideo = NO;
        but.tag =151;
    }else if (but.tag == 151){
        [but setImage:[UIImage imageNamed:@"2-1.png"] forState:UIControlStateNormal];
        [MBManager showAlertWithCustomImage:@"2-1.png" title:@"Video On"];
        _publisher.publishVideo =  YES;
        but.tag=150;
    }
    NSLog(@"底部按钮2-录像");
}
-(void)threeButton:(UIButton *)sender {
    UIButton * button = sender;
    NSLog(@"底部按钮3-音量");
    if (button.tag ==200) {
        self.subscriber.subscribeToAudio = NO;
        [button setImage:[UIImage imageNamed:@"3-2.png"] forState:UIControlStateNormal];
        [MBManager showAlertWithCustomImage:@"3-2.png" title:@"Speaker Off"];
        button.tag = 201;
        NSLog(@"200");
    }else if (button.tag == 201) {
        self.subscriber.subscribeToAudio = YES;
        [button setImage:[UIImage imageNamed:@"3-1.png"] forState:UIControlStateNormal];
        [MBManager showAlertWithCustomImage:@"3-1.png" title:@"Speaker On"];
        NSLog(@"201");
        button.tag = 200;
    }
    
}
#pragma mark - 发送挂断请求
-(void)delVideoMessage {
    NSString * sessionID =[[NSString alloc]init];
    if (SharedAppDelegate.tokSessionId.length<1) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
       sessionID = [NSString stringWithFormat:@"%@%f",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"],interval];
    }else{
        sessionID = SharedAppDelegate.tokSessionId;
    }
    
    
    NSString * bodystr =[NSString stringWithFormat:@"delVideo//%@//%@",sessionID,self.outherName];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString * bodyStr=[NSString stringWithFormat:@"%@*%@",dateString,bodystr];
    NSMutableString *soundString = [[NSMutableString alloc]initWithString:@"[/9]"];
//     NSString *dateString = [formatter stringFromDate:[NSDate date]];
    [soundString appendString:bodyStr];
    NSLog(@"发送的音频数据===%@",soundString);
    //发送消息
    //XMPPFramework主要是通过KissXML来生成XML文件
    //生成<body>文档    twopersonvideo//%@//%@     NSString * bodystr=  [NSString stringWithFormat:@"twopersonvideo//%@//%@",sessionID,personStr];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:soundString];
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:self.outherName];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    //组合
    [mes addChild:body];
    NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [mes addChild:received];
    [[XMPPServer xmppStream] sendElement:mes];
}
#pragma mark - 连接到会话
-(void)openToxBox {
    
    NSString * tokboxkey=[[NSString alloc]init];
    NSString * tokboxsecert = [[NSString alloc]init];
    
    tokboxsecert = [NSString stringWithFormat:@"%@",TOKBOXSECERT];
    tokboxkey = [NSString stringWithFormat:@"%@",TOKBOXAPIKEY];
    if (self.IsCalled==YES) {
        
        if(SharedAppDelegate.otherPersonArr.count>=2)
        {
            NSLog(@"CalledTokbox:%@",[SharedAppDelegate.otherPersonArr objectAtIndex:2]);            
            [self getTokBoxToken:[SharedAppDelegate.otherPersonArr objectAtIndex:2] TokboxApikey:tokboxkey TokboxSession:tokboxsecert];
        }
    }else
    {
        [self getTokBoxToken:self.outToboxSession TokboxApikey:tokboxkey TokboxSession:tokboxsecert];
    }
}
//sessiond 成功后获取token
-(void)getTokBoxToken:(NSString *)tokboxsession TokboxApikey:(NSString * )key TokboxSession:(NSString * )session{
    //  NSString * name=  [NSString stringWithFormat:@"%@",SharedAppDelegate.currentUserInfo.userFullName];
    //获取tokbox token
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            [NSString stringWithFormat:@"%@",TOKBOXAPIKEY], @"apikey",
                            [NSString stringWithFormat:@"%@",TOKBOXSECERT], @"secret",
                            [NSString stringWithFormat:@"%@",tokboxsession],@"session",
                            SharedAppDelegate.currentUserInfo.userFullName,@"fulname",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_TokboxTokenByMobile parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         ZNgetTokBoxToken * znmettings = [ZNgetTokBoxToken responseWithDDXMLDocument:XMLDocument];
         NSString * tokboxToken = znmettings.getTokBoxToken;
         //         NSLog(@"json =tokboxsession 成功 == %@",tokboxToken);
         tokboxToken = [tokboxToken stringByReplacingOccurrencesOfString:@"\"" withString:@""];
         //         NSLog(@"处理后：%@",tokboxToken);
         
         
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             
             _session = [[OTSession alloc]initWithApiKey:TOKBOXAPIKEY sessionId:tokboxsession delegate:self];
             NSError * error;
             [_session connectWithToken:tokboxToken error:&error];
             if (error) {
                 NSLog(@"错误=%@",error);
             }
             
             SharedAppDelegate.znvideochat = YES;
             
         });
         
         
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"失败===%@",error);
     }];
    [operation start];
    
}
#pragma mark -Session连接代理
//当客户端连接到OpenTok会话时，[OTSessionDelegate sessionDidConnect:] 消息被发送。
-(void)sessionDidConnect:(OTSession *)session {
    NSLog(@"客户端连接到OpenTok会话成功！！%@",session.sessionId);
    //发送流到会话
    NSLog(@"发送流的name ==%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]);
    _publisher = [[OTPublisher alloc]initWithDelegate:self settings:_publisherSettings];
    OTError * error = nil;
    [_session publish:_publisher error:&error];
    if (error) {
        NSLog(@"无法发布链接=== (%@)", error.localizedDescription);
        return;
    }
    
    [_publisher.view setFrame:self.SmallHeadView.frame];
    [self.view addSubview:_publisher.view];
    self.issub = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.issub == NO) {
                //对方没有连接
                NSLog(@"对方没有连接");
//              [UIView addMJNotifierWithText:@"The other is busy!" dismissAutomatically:YES];
            }
        });
    });
    
    //为自己头像添加点击事件
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chageviewframe:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [_publisher.view addGestureRecognizer:tapGestureRecognizer];
}
//点击自己头像，与对方进行切换
-(void)chageviewframe:(UITapGestureRecognizer*)tap{
    if (_publisher.view.frame.size.height >SCREEN_WIDTH) {
        [_subscriber.view setFrame:[UIScreen mainScreen].bounds];
        [_publisher.view setFrame:self.SmallHeadView.frame];
        [self.view insertSubview:_publisher.view atIndex:0];
    }else{
        [_subscriber.view setFrame:self.SmallHeadView.frame];
        [_publisher.view setFrame:[UIScreen mainScreen].bounds];
        [self.view insertSubview:_publisher.view atIndex:0];
    }
    
   
}

-(void)SendVideoRequests{
    NSString * bodystr =@"sendVideo";
    NSMutableString *soundString = [[NSMutableString alloc]initWithString:@"[/9]"];
    [soundString appendString:bodystr];
    NSLog(@"发送的音频数据===%@",soundString);
    //发送消息
    //生成<body>文档
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:soundString];
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:self.outherName];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    //组合
    [mes addChild:body];
    NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [mes addChild:received];
    [[XMPPServer xmppStream] sendElement:mes];
    
    
}

//当客户端从OpenTok会话断开时， [OTSessionDelegate sessionDidDisconnect:]消息被发送
-(void)sessionDidDisconnect:(OTSession *)session {
    NSLog(@"客户端连接到OpenTok sessitheclient与OpenTok会话断开连接。");
}
//如果客户端无法连接到OpenTok会话， [OTSessionDelegate session:didFailWithError:]则会发送消息。
-(void)session:(OTSession *)session didFailWithError:(OTError *)error{
    NSLog(@"客户端未能连接到OpenTok会话错误详情 == %@",error);
}
//当另一个客户端向OpenTok会话发布流时，会 [OTSessionDelegate session:streamCreated:]发送消息
-(void)session:(OTSession *)session streamCreated:(OTStream *)stream {
   
    NSLog(@"在会话中创建了一条流");
    NSLog(@"订阅流========%@",stream.name);
 
  
    NSArray * outher=[self.outherName componentsSeparatedByString:@"@"];

    
    NSString * outhername = [NSString stringWithFormat:@"%@",outher[0]];
    NSString *outhername1 = [NSString stringWithFormat:@"%@",stream.name];
    
    if (![outhername1 isEqualToString:stream.name]){
        NSLog(@"不是订阅的人");
    }
    
    if ([outhername1 isEqualToString:stream.name])
    {
        _subscriber = [[OTSubscriber alloc] initWithStream:stream
                                                  delegate:self];
        OTError *error = nil;
        [_session subscribe:_subscriber error:&error];
        if (error)
        {
            NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
            return;
        }
        NSLog(@"订阅流name===%@ ",stream.name);
         [_subscriber.view setFrame:[UIScreen mainScreen].bounds];
        self.waitinglab.hidden = YES;
//        [self.view addSubview:_subscriber.view];
        [self.view insertSubview:_subscriber.view atIndex:0];
         self.issub = YES;
        //为自己头像添加点击事件
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chageviewframsse:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [_subscriber.view addGestureRecognizer:tapGestureRecognizer];
        
    }else {
        return;
    }
}
//点击自己头像，与对方进行切换
-(void)chageviewframsse:(UITapGestureRecognizer*)tap{
    if (_publisher.view.frame.size.height >SCREEN_WIDTH) {
        [_publisher.view setFrame:self.SmallHeadView.frame];
        [_subscriber.view setFrame:[UIScreen mainScreen].bounds];
        [self.view insertSubview:_subscriber.view atIndex:0];
    }else{
        [_publisher.view setFrame:[UIScreen mainScreen].bounds];
        [_subscriber.view setFrame:self.SmallHeadView.frame];
        [self.view insertSubview:_subscriber.view atIndex:0];
    }
    
    
   
}


//当另一个客户端停止发布流到OpenTok会话时， [OTSessionDelegate session:streamDestroyed:]消息被发送
-(void)session:(OTSession *)session streamDestroyed:(OTStream *)stream{
    NSLog(@"在会议中有一条流被毁.....");
     NSString *outhername1 = [NSString stringWithFormat:@"%@",stream.name];
    if ([stream.name isEqualToString:outhername1]) {
        //对方挂断
        [[MyAVAudioPlayer sharedAVAudioPlayer]playMP3:@"videoGD"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.floatWindow.hidden = YES;
                [self dismissViewControllerAnimated:YES completion:nil];
                [_session disconnect];
                //    deleage.isvideochat =[NSNumber numberWithInt:0];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"disconnectVideo" object:nil userInfo:nil];
                SharedAppDelegate.isvideo = NO;
              
                
            });
        });
    }
  
}

#pragma mark 发送流代理
-(void)publisher:(OTPublisherKit *)publisher didFailWithError:(OTError *)error {
    NSLog(@"发送流数据失败==%@",error);
}


# pragma mark - 订阅流
- (void)subscriberDidConnectToStream:(OTSubscriberKit *)subscriber {
//    NSLog(@"The subscirber: %@ did connect to the stream", subscriber);
    NSLog(@"subscirber:%@确实连接到流",subscriber);
}
         
- (void)subscriber:(OTSubscriberKit*)subscriber didFailWithError:(OTError*)error  {
    NSLog(@"subscriber %@ didFailWithError %@",subscriber.stream.streamId,error);
    NSLog(@"订阅者=%@ 订阅失败=%@",subscriber.stream.streamId,error);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
