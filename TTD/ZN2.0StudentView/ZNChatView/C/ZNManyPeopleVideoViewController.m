//
//  ZNManyPeopleVideoViewController.m
//  TTD
//
//  Created by 张楠 on 2017/12/23.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "ZNManyPeopleVideoViewController.h"
#import <OpenTok/OpenTok.h>//tokbox
//#import <MGBSHud/MGBSHUD.h>
#import "MBManager.h"
#import "FloatingWindow.h"
#import "AppDelegate.h"
#import "ZNListViewController.h"
#import "ZNVMListViewController.h"
#import "Photo.h"

#define UIIMGNAMED(img_name) [UIImage imageNamed:img_name]

// Replace with your OpenTok API key46024232
static NSString* kApiKey = @"46010332";
// Replace with your generated session ID  会话ID  2_MX40NjAyNDIzMn5-MTUxMzU3Njg2OTk4Mn41cE55OGZ2MlBIY1N1WXF0aTZ5ZU1SNFB-fg
static NSString* kSessionId = @"2_MX40NjAxMDMzMn5-MTUxNjI4OTgyNDk4M35DUlQ2QU1td3k5bjRzQytjWGd6eUhKM1l-UH4";
// Replace with your generated token 令牌
static NSString* kToken = @"T1==cGFydG5lcl9pZD00NjAxMDMzMiZzaWc9NWU4ZTNkYjM2NjljYzAzYTQyMTE3ZWM0ZWVjN2FhYTRkZTZhOTg3MjpzZXNzaW9uX2lkPTJfTVg0ME5qQXhNRE16TW41LU1UVXhOakk0T1RneU5EazRNMzVEVWxRMlFVMXRkM2s1YmpSelF5dGpXR2Q2ZVVoS00xbC1VSDQmY3JlYXRlX3RpbWU9MTUxNjI4OTg5MiZub25jZT0wLjk2Nzk1MTk2OTEzNDUwMDImcm9sZT1wdWJsaXNoZXImZXhwaXJlX3RpbWU9MTUxODg4MTg5MSZjb25uZWN0aW9uX2RhdGE9JTdCJTIydXNlck5hbWUlMjIlM0ElMjJVc2VyJTIyJTdEJmluaXRpYWxfbGF5b3V0X2NsYXNzX2xpc3Q9";



@interface ZNManyPeopleVideoViewController ()<OTSessionDelegate,OTPublisherDelegate,OTSubscriberDelegate,MBProgressHUDDelegate,FloatingWindowTouchDelegate>
{
    NSInteger k;
     NSInteger overnumber ;
    
    int j;
    NSMutableArray * VMArr;//动态添加需传递人数
}
@property (nonatomic) OTSession * session;//连接到会话
@property (nonatomic) OTPublisher * publisher;//发送流到会话
@property (nonatomic) OTSubscriber * subscriber;//订阅其他用户流
@property (nonatomic) OTSubscriber * subscriber2;//订阅其他用户流
@property (nonatomic) OTSubscriber * subscriber3;//订阅其他用户流
@property (nonatomic) OTSubscriber * subscriber4;//订阅其他用户流
@property (nonatomic) OTSubscriber * subscriber5;//订阅其他用户流
@property (nonatomic) OTSubscriber * subscriber6;//订阅其他用户流
@property (nonatomic) OTSubscriber * subscriber7;//订阅其他用户流
@property (nonatomic) OTSubscriber * subscriber8;//订阅其他用户流
@property (nonatomic,assign) BOOL issub;
@property (nonatomic) OTPublisherSettings * publisherSettings;
@property (nonatomic,strong) UIView * view1;
@property (nonatomic,strong) UIView * view2;
@property (nonatomic,strong) UIView * view3;
@property (nonatomic,strong) UIView * view4;
@property (nonatomic,strong) UIView * view5;
@property (nonatomic,strong) UIView * view6;
@property (nonatomic,strong) UIView * view7;
@property (nonatomic,strong) UIView * view8;
@property (nonatomic,strong) UIView * view9;
@property (nonatomic,strong) UILabel * wainglab;

@property (nonatomic,strong) NSMutableArray * othernamearr;//获取到的其他用户
@property (nonatomic,strong) NSMutableArray * chagearr;//格式化获取的数据后得到。
@property (nonatomic,strong) NSMutableArray * rectarr;//view 数组
@property (nonatomic,strong) NSMutableArray * newpersonarr;//动态添加后的人员；
@property (nonatomic,strong) UIView * VideoBackView;



@end

@implementation ZNManyPeopleVideoViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nichengarr= [[NSMutableArray alloc]init];
    
    //隐藏顶部第二个按钮
    self.gobackchat.hidden = YES;
    if (self.gobackchat.hidden == YES) {
        self.addperson.frame = self.gobackchat.frame;
    }
    _VideoBackView =[[UIView alloc]init];
    _VideoBackView.frame =CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT -200);
    
    
    NSLog(@"此房间的SessionID = %@",self.SessionID);
    //禁止黑屏
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    _rectarr = [[NSMutableArray alloc]init];
    _newpersonarr = [[NSMutableArray alloc]init];
    //返回按钮
    [self.backView addTarget:self action:@selector(backupview) forControlEvents:UIControlEventTouchUpInside];
    //相机翻转按钮
    [self.carmebutton addTarget:self action:@selector(urnthecamera:) forControlEvents:UIControlEventTouchUpInside];
    self.carmebutton.tag = 500;
    //麦克风按钮
    [self.MKFButton addTarget:self action:@selector(offmfc:) forControlEvents:UIControlEventTouchUpInside];
    self.MKFButton.tag = 600;
    //视频按钮
    [self.SPButton addTarget:self action:@selector(offvideo:) forControlEvents:UIControlEventTouchUpInside];
    self.SPButton.tag = 700;
    //音量按钮
    [self.SYButton addTarget:self action:@selector(offsy:) forControlEvents:UIControlEventTouchUpInside];
    self.SYButton.tag = 800;
    //挂断按钮
    [self.GDButton addTarget:self action:@selector(dismisstheVideo) forControlEvents:UIControlEventTouchUpInside];
    //返回聊天
    [self.gobackchat addTarget:self action:@selector(backupview) forControlEvents:UIControlEventTouchUpInside];
    //添加多人
    [self.addperson addTarget:self action:@selector(addPersonvideochat) forControlEvents:UIControlEventTouchUpInside];
    
    // 接收动态添加通知 increasePerson
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(increasePerson:) name:@"increasePerson" object:nil];
    //接收动态人员变更更新UI
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(increasePerson:) name:@"chageUI" object:nil];
    //收到对方拒绝接听通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Theotherpartyrefusesto:) name:@"Theotherpartyrefusesto" object:nil];
    
    
    self.floatWindow = [[FloatingWindow alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT/2-25, 50, 50) imageName:@"av_call"];
    [self.floatWindow makeKeyAndVisible];
    self.floatWindow.hidden = YES;
    VMArr = [[NSMutableArray alloc]init];
    
    SharedAppDelegate.isvideo = YES;
    _othernamearr = [[NSMutableArray alloc]init];
    _chagearr = [[NSMutableArray alloc]init];
    
    j =0;
    // Do any additional setup after loading the view from its nib.
      NSLog(@"修改动态后收到视频邀请的参会人数==%@",self.alluesrArr);
    NSLog(@"我发起的视频邀请人数==%@",self.mtarr);//发送邀请人数
    NSLog(@"上页传递的人数接收邀请人数==%@",self.getvideoarr);// 接收邀请人数 yes

    
    NSInteger numb =self.alluesrArr.count;//接收
    NSInteger person = self.mtarr.count;//发送
    
    if (numb < 2) {
        overnumber = person;
    }else{
        overnumber = numb;
    }
    [self createUI:overnumber];
    
    
    
    //连接tokbox服务器
    [self openToBBox];
 
   
    
}
#pragma mark - 动态添加通知
-(void)increasePerson:(NSNotification *)notif {
    
      NSDictionary * dic = notif.userInfo;
    NSMutableArray * personArr = [dic objectForKey:@"number"];
    _mtarr = [dic objectForKey:@"number"];
    //数组驱重
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [personArr count]; i++){
        
        if ([categoryArray containsObject:[personArr objectAtIndex:i]] == NO){
            
            [categoryArray addObject:[personArr objectAtIndex:i]];
            
        }
    }
    _newpersonarr = categoryArray;
    NSLog(@"动态添加后的参会人数==%@",categoryArray);

    
     NSInteger newperson =categoryArray.count;//接收
    _rectarr = [[NSMutableArray alloc]init];
    
    for (UIView * view in [self.VideoArea subviews]) {
        [view removeFromSuperview];
        
    }
    
 
    
    
    [self createUI:newperson];
    NSLog(@"最新人数===%lu",newperson);

    if (newperson ==2) {
        [_subscriber.view setFrame:self.view1.frame];
        [self.VideoArea addSubview:_subscriber.view];
        [_publisher.view setFrame:self.view2.frame];
        [self.VideoArea addSubview:_publisher.view];
    }
    if (newperson ==3) {
        [_subscriber.view setFrame:self.view1.frame];
        [self.VideoArea addSubview:_subscriber.view];
        [_subscriber2.view setFrame:self.view2.frame];
        [self.VideoArea addSubview:_subscriber2.view];
        [_publisher.view setFrame:self.view3.frame];
        [self.VideoArea addSubview:_publisher.view];
    }
    if (newperson ==4) {
        [_subscriber.view setFrame:self.view1.frame];
        [self.VideoArea addSubview:_subscriber.view];
        [_subscriber2.view setFrame:self.view2.frame];
        [self.VideoArea addSubview:_subscriber2.view];
        [_subscriber3.view setFrame:self.view3.frame];
        [self.VideoArea addSubview:_subscriber3.view];
        [_publisher.view setFrame:self.view4.frame];
        [self.VideoArea addSubview:_publisher.view];
    }
    if (newperson ==5) {
        [_subscriber.view setFrame:self.view1.frame];
        [self.VideoArea addSubview:_subscriber.view];
        [_subscriber2.view setFrame:self.view2.frame];
        [self.VideoArea addSubview:_subscriber2.view];
        [_subscriber3.view setFrame:self.view3.frame];
        [self.VideoArea addSubview:_subscriber3.view];
        [_subscriber4.view setFrame:self.view4.frame];
        [self.VideoArea addSubview:_subscriber4.view];
        [_publisher.view setFrame:self.view5.frame];
        [self.VideoArea addSubview:_publisher.view];
    }
    if (newperson ==6) {
        [_subscriber.view setFrame:self.view1.frame];
        [self.VideoArea addSubview:_subscriber.view];
        [_subscriber2.view setFrame:self.view2.frame];
        [self.VideoArea addSubview:_subscriber2.view];
        [_subscriber3.view setFrame:self.view3.frame];
        [self.VideoArea addSubview:_subscriber3.view];
        [_subscriber4.view setFrame:self.view4.frame];
        [self.VideoArea addSubview:_subscriber4.view];
        [_subscriber5.view setFrame:self.view5.frame];
        [self.VideoArea addSubview:_subscriber5.view];
        [_publisher.view setFrame:self.view6.frame];
        [self.VideoArea addSubview:_publisher.view];
    }
    if (newperson ==7) {
        [_subscriber.view setFrame:self.view1.frame];
        [self.VideoArea addSubview:_subscriber.view];
        [_subscriber2.view setFrame:self.view2.frame];
        [self.VideoArea addSubview:_subscriber2.view];
        [_subscriber3.view setFrame:self.view3.frame];
        [self.VideoArea addSubview:_subscriber3.view];
        [_subscriber4.view setFrame:self.view4.frame];
        [self.VideoArea addSubview:_subscriber4.view];
        [_subscriber5.view setFrame:self.view5.frame];
        [self.VideoArea addSubview:_subscriber5.view];
        [_subscriber6.view setFrame:self.view6.frame];
        [self.VideoArea addSubview:_subscriber6.view];
        [_publisher.view setFrame:self.view7.frame];
        [self.VideoArea addSubview:_publisher.view];
    }
    if (newperson >7 && newperson<=9) {
        [_subscriber.view setFrame:self.view1.frame];
        [self.VideoArea addSubview:_subscriber.view];
        [_subscriber2.view setFrame:self.view2.frame];
        [self.VideoArea addSubview:_subscriber2.view];
        [_subscriber3.view setFrame:self.view3.frame];
        [self.VideoArea addSubview:_subscriber3.view];
        [_subscriber4.view setFrame:self.view4.frame];
        [self.VideoArea addSubview:_subscriber4.view];
        [_subscriber5.view setFrame:self.view5.frame];
        [self.VideoArea addSubview:_subscriber5.view];
        [_subscriber6.view setFrame:self.view6.frame];
        [self.VideoArea addSubview:_subscriber6.view];
        [_subscriber7.view setFrame:self.view7.frame];
        [self.VideoArea addSubview:_subscriber7.view];
        [_subscriber8.view setFrame:self.view8.frame];
        [self.VideoArea addSubview:_subscriber8.view];
        [_publisher.view setFrame:self.view9.frame];
        [self.VideoArea addSubview:_publisher.view];
    }

}


#pragma mark -按钮点击事件
//添加多人
-(void)addPersonvideochat {
    if (_newpersonarr.count<1) {
        if (self.alluesrArr.count<1) {
            VMArr = self.mtarr;
        }else{
            VMArr = self.alluesrArr;
        }
    }else{
        VMArr = self.newpersonarr;
    }
    
    
    
    
    NSLog(@"房间人数 == %@",VMArr);
    ZNVMListViewController * znv=[[ZNVMListViewController alloc]init];
    znv.selectedArr  = VMArr;
    znv.sessionID = self.SessionID;
    [self presentViewController:znv animated:YES completion:nil];

}

//返回按钮
-(void)backupview {
    
    
   self.floatWindow.isCannotTouch = NO;
    __weak typeof (self) weakSelf = self;
    self.floatWindow.floatDelegate = weakSelf;
    
    [self.floatWindow startWithTime:30 presentview:self.view inRect:CGRectMake(SCREEN_WIDTH/2-25,SCREEN_HEIGHT/2-25,50, 50)];//缩放位置
    
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"disconnectVideo" object:nil userInfo:nil];
       
    }];
    
}
// floatdelegate
-(void)assistiveTocuhs {
    
    
    self.floatWindow.isCannotTouch = YES;
    
}
// 挂断
-(void)dismisstheVideo {
    
    self.floatWindow.hidden = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];

    [_session disconnect];
//    deleage.isvideochat =[NSNumber numberWithInt:0];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"disconnectVideo" object:nil userInfo:nil];
    SharedAppDelegate.isvideo = NO;
}
//相机翻转
-(void)urnthecamera:(UIButton *)button {
    
    UIButton * btn = button;
    if (btn.tag == 500) {
        _publisher.cameraPosition = AVCaptureDevicePositionBack;
        btn.tag = 501;
    }else if (btn.tag == 501) {
        _publisher.cameraPosition = AVCaptureDevicePositionFront;
        btn.tag = 500;
    }
}
//麦克风按钮
-(void)offmfc:(UIButton *)button {
   
    UIButton * but = button;
    if (but.tag == 600) {
        _publisher.publishAudio = NO;
        [but setImage:[UIImage imageNamed:@"1-1.png"] forState:UIControlStateNormal];

        [MBManager showAlertWithCustomImage:@"1-1.png" title:@"Audio unmuted" inView:self.view];
   
        but.tag = 601;
    }else if (but.tag == 601) {
        _publisher.publishAudio = YES;
        [but setImage:[UIImage imageNamed:@"1-2.png"] forState:UIControlStateNormal];
        [MBManager showAlertWithCustomImage:@"1-2.png" title:@"Audio muted" inView:self.view];
        but.tag = 600;
    }
}
//视频按钮
-(void)offvideo:(UIButton *)button {
    
    UIButton * sender = button;
    if (sender.tag == 700) {
        [sender setImage:[UIImage imageNamed:@"2-2.png"] forState:UIControlStateNormal];
        _publisher.publishVideo = NO;
 
        [MBManager showAlertWithCustomImage:@"2-2.png" title:@"Video Off" inView:self.view];
        sender.tag = 701;
    }else if (sender.tag == 701) {
        [sender setImage:[UIImage imageNamed:@"2-1.png"] forState:UIControlStateNormal];
        _publisher.publishVideo =  YES;
        
        [MBManager showAlertWithCustomImage:@"2-1.png" title:@"Video On" inView:self.view];
        sender.tag=700;
    }
}
//音量按钮
-(void)offsy:(UIButton *)button {
    
    UIButton * btn = button;
    if (btn.tag == 800) {
        self.subscriber.subscribeToAudio = NO;
        [btn setImage:[UIImage imageNamed:@"3-2.png"] forState:UIControlStateNormal];
     
        [MBManager showAlertWithCustomImage:@"3-2.png" title:@"Speaker Off" inView:self.view];
        btn.tag = 801;
    }else if (btn.tag == 801) {
        self.subscriber.subscribeToAudio = YES;
        [btn setImage:[UIImage imageNamed:@"3-1.png"] forState:UIControlStateNormal];

        [MBManager showAlertWithCustomImage:@"3-1.png" title:@"Speaker On" inView:self.view];
        btn.tag = 800;
    }
}

//4格
-(void)createUI:(NSUInteger )person {
   
    CGFloat W ;
    CGFloat H ;
    //每行列数
    NSInteger rank ;
    
    if (person ==2) {
        W =[UIScreen mainScreen].bounds.size.width;
        H = _VideoBackView.bounds.size.height/2;
        rank =1;
        k=2;
    }else if (person==3){
        W =[UIScreen mainScreen].bounds.size.width/2;
        H = _VideoBackView.bounds.size.height/2;
        rank =2;
        k=3;
    }else if (person ==4){
        W =[UIScreen mainScreen].bounds.size.width/2;
        H = _VideoBackView.bounds.size.height/2;
        rank =2;
        k=4;
    }else if (person ==5){
        W =[UIScreen mainScreen].bounds.size.width/2;
        H = _VideoBackView.bounds.size.height/3;
        rank =2;
        k=5;
    }else if (person ==6){
        W =[UIScreen mainScreen].bounds.size.width/2;
        H = _VideoBackView.bounds.size.height/3;
        rank =2;
        k=6;
    }else if (person ==7){
        W =[UIScreen mainScreen].bounds.size.width/3;
        H = _VideoBackView.bounds.size.height/3;
        rank =3;
        k=7;
    }else if (person>7 && person<=9){
        W =[UIScreen mainScreen].bounds.size.width/3;
        H = _VideoBackView.bounds.size.height/3;
        rank =3;
        k=9;
    }
    
    
    
    //每列间距
    CGFloat rankMargin = 0;
    //每行间距
    CGFloat rowMargin = 0;
//    NSMutableArray * rectarr=[[NSMutableArray alloc]init];
    for (int i = 0 ; i< k; i++) {
        //Item X轴
        CGFloat X = (i % rank) * (W + rankMargin);
        //Item Y轴
        NSUInteger Y = (i / rank) * (H +rowMargin);
        CGFloat top = 0;
        UIView *speedView = [[UIView alloc] init];
        UILabel * lab=[[UILabel alloc]init];
        speedView.backgroundColor = [UIColor blackColor];
        
        if (person ==3  && person<5) {
            if (i+1==3) {
                speedView.frame = CGRectMake(X, Y+top, W*2, H);
                lab.frame =CGRectMake(0, speedView.frame.size.height-30, W*2,25);
            }else{
                speedView.frame = CGRectMake(X, Y+top, W, H);
                lab.frame =CGRectMake(0, speedView.frame.size.height-30, W,25);
            }
        }else if (person >3 && person ==5){
            if (i+1 ==5) {
                speedView.frame = CGRectMake(0, H*2, W*2, H);
                lab.frame =CGRectMake(0, speedView.frame.size.height-30, W*2,25);
            }else{
                speedView.frame = CGRectMake(X, Y+top, W, H);
                lab.frame =CGRectMake(0, speedView.frame.size.height-30, W,25);
            }
        }else if (person >5 && person ==7){
            if (i+1==7) {
                speedView.frame = CGRectMake(X, Y+top, W*3, H);
                lab.frame =CGRectMake(0, speedView.frame.size.height-30, W*3,25);
            }else{
                speedView.frame = CGRectMake(X, Y+top, W, H);
                lab.frame =CGRectMake(0, speedView.frame.size.height-30, W,25);
            }
        }else{
            speedView.frame = CGRectMake(X, Y+top, W, H);
            lab.frame =CGRectMake(0, speedView.frame.size.height-30, W,25);
        }
        
       

        speedView.layer.borderWidth = 0.1;
        speedView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
      
        //默认等待头像
        UIImageView * userimageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, speedView.frame.size.width-20, speedView.frame.size.height-50)];
      
      
        
        
        if (_newpersonarr.count > self.mtarr.count) {
            NSString * str=_newpersonarr[i];
            NSArray * other = [str componentsSeparatedByString:@"@"];
            
            NSMutableArray * arry = [WCMessageObject fetchAllUserMessageInfo:SharedAppDelegate.username];;
            
            for (WCMessageObject * wcmes in arry) {
                if ([wcmes.userId isEqualToString:[NSString stringWithFormat:@"%@",other[0]]]) {
                    [self.nichengarr addObject:wcmes.userNickname];
                     [lab setText:[NSString stringWithFormat:@"%@",wcmes.userNickname]];
                     userimageV.image=[Photo string2Image:wcmes.userHead];
                }else{
                      userimageV.image =[UIImage imageNamed:@"defaultUSerImage"];
                }
            }
            
//            [lab setText:[NSString stringWithFormat:@"%@",self.nichengarr[i]]];
        }else{
            NSString * str=self.mtarr[i];
            NSArray * other = [str componentsSeparatedByString:@"@"];
            NSMutableArray * arry = [WCMessageObject fetchAllUserMessageInfo:SharedAppDelegate.username];;
            
            for (WCMessageObject * wcmes in arry) {
                if ([wcmes.userId isEqualToString:[NSString stringWithFormat:@"%@",other[0]]]) {
                    [self.nichengarr addObject:wcmes.username];
                     [lab setText:[NSString stringWithFormat:@"%@",wcmes.userNickname]];
                    userimageV.image=[Photo string2Image:wcmes.userHead];
                }else{
                      userimageV.image =[UIImage imageNamed:@"defaultUSerImage"];
                }
            }
            
           
        }
        
        
//        [lab setText:@" Waiting ……"];
//        [lab setText:[NSString stringWithFormat:@"WAITING =%d",i]];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setTextAlignment:NSTextAlignmentCenter];
        speedView.tag= 100+i;
        
        //lab文字动画
        CAGradientLayer *graLayer = [CAGradientLayer layer];
        graLayer.frame = lab.bounds;
        graLayer.colors = @[(__bridge id)[[UIColor greenColor] colorWithAlphaComponent:0.3].CGColor,
                            (__bridge id)[UIColor yellowColor].CGColor,
                            (__bridge id)[[UIColor yellowColor] colorWithAlphaComponent:0.3].CGColor];
        
        graLayer.startPoint = CGPointMake(0, 0);//设置渐变方向起点
        graLayer.endPoint = CGPointMake(1, 0);  //设置渐变方向终点
        graLayer.locations = @[@(0.0), @(0.0), @(0.1)]; //colors中各颜色对应的初始渐变点
        // 第二步：通过设置颜色渐变点(locations)动画，达到预期效果
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
        animation.duration = 3.0f;
        animation.toValue = @[@(0.9), @(1.0), @(1.0)];
        animation.removedOnCompletion = NO;
        animation.repeatCount = HUGE_VALF;
        animation.fillMode = kCAFillModeForwards;
        [graLayer addAnimation:animation forKey:@"xindong"];
        // 最后一步：也是关键一步，将graLayer设置成textLabel的遮罩
        lab.layer.mask = graLayer;
        
        [speedView addSubview:userimageV];
        
        [self.VideoArea addSubview:speedView];
        [speedView addSubview:lab];
        [_rectarr addObject:speedView];
    
    
    }
    NSLog(@"view 视图数组===%@",_rectarr);
    if (k==2) {
        self.view1 = _rectarr[0];
        self.view2 = _rectarr[1];
    }
    if (k ==3) {
        self.view1 = _rectarr[0];
        self.view2 = _rectarr[1];
        self.view3 = _rectarr[2];
    }
    
    if (k ==4) {
        self.view1 = _rectarr[0];
        self.view2 = _rectarr[1];
        self.view3 = _rectarr[2];
        self.view4 = _rectarr[3];
    }
    if (k==5) {
        self.view1 = _rectarr[0];
        self.view2 = _rectarr[1];
        self.view3 = _rectarr[2];
        self.view4 = _rectarr[3];
        self.view5 = _rectarr[4];
    }
    
    if (k==6) {
        self.view1 = _rectarr[0];
        self.view2 = _rectarr[1];
        self.view3 = _rectarr[2];
        self.view4 = _rectarr[3];
        self.view5 = _rectarr[4];
        self.view6 = _rectarr[5];
    }
    
    if (k == 7) {
        self.view1 = _rectarr[0];
        self.view2 = _rectarr[1];
        self.view3 = _rectarr[2];
        self.view4 = _rectarr[3];
        self.view5 = _rectarr[4];
        self.view6 = _rectarr[5];
        self.view7 = _rectarr[6];
    }
    
    if (k==9) {
        self.view1 = _rectarr[0];
        self.view2 = _rectarr[1];
        self.view3 = _rectarr[2];
        self.view4 = _rectarr[3];
        self.view5 = _rectarr[4];
        self.view6 = _rectarr[5];
        self.view7 = _rectarr[6];
        self.view8 = _rectarr[7];
        self.view9 = _rectarr[8];
    }
    
    //NSUserDefaults
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:k forKey:@"tokboxk"];
    [defaults synchronize];
    
//
    _publisherSettings = [[OTPublisherSettings alloc]init];
    _publisherSettings.name =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
}

#pragma mark -初始化视频
-(void)openToBBox {
    if (self.videoapiKey.length>1) {
        [self MettingVideo];
    }else{
        [self DRVIdeoChat];//单人
    }

}
//meeting视屏
-(void)MettingVideo{
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            [NSString stringWithFormat:@"%@",self.videoapiKey], @"apikey",
                            [NSString stringWithFormat:@"%@",self.videosecert], @"secret",
                            [NSString stringWithFormat:@"%@",self.videoSeesion],@"session",
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
             _session = [[OTSession alloc]initWithApiKey: TOKBOXAPIKEY sessionId:self.videoSeesion delegate:self];
             NSError * error;
             [_session connectWithToken:tokboxToken error:&error];
             if (error) {
                 NSLog(@"错误=%@",error);
             }
         });
         
         
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"失败===%@",error);
     }];
    [operation start];
}
//单人视频
-(void)DRVIdeoChat{
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
             // 更新界面
             //                 [self getTokBoxToken:tokboxSession];
             [self getTokBoxToken:tokboxSession TokboxApikey:tokboxkey TokboxSession:tokboxsecert];
         });
         
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"失败===%@",error);
     }];
    [operation start];
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
             _session = [[OTSession alloc]initWithApiKey: TOKBOXAPIKEY sessionId:tokboxsession delegate:self];
             NSError * error;
             [_session connectWithToken:tokboxToken error:&error];
             if (error) {
                 NSLog(@"错误=%@",error);
             }
         });
        
         
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"失败===%@",error);
     }];
    [operation start];

}




#pragma mark -Session连接代理
-(void)sessionDidConnect:(OTSession *)session {
    //发送流到回话
    NSLog(@"发送流的name ==%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]);
    _publisher = [[OTPublisher alloc]initWithDelegate:self settings:_publisherSettings];
    OTError * error = nil;
    [_session publish:_publisher error:&error];
    if (error) {
        NSLog(@"无法发布链接=== (%@)", error.localizedDescription);
        return;
    }

     SharedAppDelegate.znvideochat = YES;
    
    UIView * vvl=[_rectarr lastObject];
    
    [_publisher.view setFrame:vvl.frame];
    [self.VideoArea addSubview:_publisher.view];
    self.issub = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.issub == NO) {
                //对方没有连接
                NSLog(@"对方没有连接");

                 [MBManager showBriefAlert:@"The other is busy!"];
            }
        });
    });
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
    NSLog(@"在会话中创建了一条流==%@",stream.streamId);
    NSLog(@"收到服务器的流========%@",stream.name);//samathachen
  
    OTError *error = nil;
    NSMutableArray * streamArr = [[NSMutableArray alloc]init];
    if (self.alluesrArr.count<1) {
        streamArr =self.mtarr;
    }else{
        streamArr = self.alluesrArr;
    }
    for (int i=0; i<streamArr.count; i++) {
        NSString * str=streamArr[i];
        NSArray * other = [str componentsSeparatedByString:@"@"];
        if (![_chagearr containsObject:other[0]]) {
             [_chagearr addObject:other[0]];
        }
    }
    NSLog(@"动态添加更改后的参会人员数据=%@",_chagearr);
       BOOL isbool =[_chagearr containsObject:[NSString stringWithFormat:@"%@",stream.name]];
    NSInteger index = 0;
    if (isbool == YES) {
      index = [_chagearr indexOfObject:[NSString stringWithFormat:@"%@",stream.name]];
        NSLog(@"-1---%ld---",index);
    }
    
    
    
    
    switch (index) {
        case 0:
        {
            self.issub = YES;
                _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
                [_session subscribe:_subscriber error:&error];
                if (error)
                {
                    NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                    return;
                }
                UIView * vv = _rectarr[0];
                [_subscriber.view setFrame:vv.frame];
                [self.VideoArea addSubview:_subscriber.view];
        }
            break;
        case 1:
        {
            self.issub = YES;
                _subscriber2 = [[OTSubscriber alloc] initWithStream:stream delegate:self];
                [_session subscribe:_subscriber2 error:&error];
                if (error)
                {
                    NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                    return;
                }
                
                UIView * vv = _rectarr[1];
                [_subscriber2.view setFrame:vv.frame];
                [self.VideoArea addSubview:_subscriber2.view];
        }
            break;
        case 2:
        {
            self.issub = YES;
                _subscriber3 = [[OTSubscriber alloc] initWithStream:stream delegate:self];
                [_session subscribe:_subscriber3 error:&error];
                if (error)
                {
                    NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                    return;
                }
                
                UIView * vv = _rectarr[2];
                [_subscriber3.view setFrame:vv.frame];
                [self.VideoArea addSubview:_subscriber3.view];

        }
            break;
        case 3:
        {
            self.issub = YES;
                _subscriber4 = [[OTSubscriber alloc] initWithStream:stream delegate:self];
                [_session subscribe:_subscriber4 error:&error];
                if (error)
                {
                    NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                    return;
                }
                
                UIView * vv = _rectarr[3];
                [_subscriber4.view setFrame:vv.frame];
                [self.VideoArea addSubview:_subscriber4.view];
 
        }
            break;
        case 4:
        {
            self.issub = YES;
                _subscriber5 = [[OTSubscriber alloc] initWithStream:stream delegate:self];
                [_session subscribe:_subscriber5 error:&error];
                if (error)
                {
                    NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                    return;
                }
                
                UIView * vv = _rectarr[4];
                [_subscriber5.view setFrame:vv.frame];
                [self.VideoArea addSubview:_subscriber5.view];

        }
            break;
        case 5:
        {
            self.issub = YES;
                _subscriber6 = [[OTSubscriber alloc] initWithStream:stream delegate:self];
                [_session subscribe:_subscriber6 error:&error];
                if (error)
                {
                    NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                    return;
                }
                UIView * vv = _rectarr[5];
                [_subscriber6.view setFrame:vv.frame];
                [self.VideoArea addSubview:_subscriber6.view];

        }
            break;
        case 6:
        {
            self.issub = YES;
                _subscriber7 = [[OTSubscriber alloc] initWithStream:stream delegate:self];
                [_session subscribe:_subscriber7 error:&error];
                if (error)
                {
                    NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                    return;
                }
                UIView * vv = _rectarr[6];
                [_subscriber7.view setFrame:vv.frame];
                [self.VideoArea addSubview:_subscriber7.view];
        }
            break;
            
        case 7:
        {
            self.issub = YES;
                _subscriber8 = [[OTSubscriber alloc] initWithStream:stream delegate:self];
                [_session subscribe:_subscriber8 error:&error];
                if (error)
                {
                    NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                    return;
                }
                UIView * vv = _rectarr[7];
                [_subscriber8.view setFrame:vv.frame];
                [self.VideoArea addSubview:_subscriber8.view];
        }
            break;
            
        
        default:
            break;
    }
    
}

//当另一个客户端停止发布流到OpenTok会话时， [OTSessionDelegate session:streamDestroyed:]消息被发送
-(void)session:(OTSession *)session streamDestroyed:(OTStream *)stream{
    NSLog(@"在会议中有一条流被毁.....");
    NSString * roomname = stream.name;
    NSLog(@"在会议中有一条流被毁.....%@",roomname);
    
    OTError *error = nil;
    NSMutableArray * streamArr = [[NSMutableArray alloc]init];
    if (self.alluesrArr.count<1) {
        streamArr =self.mtarr;
    }else{
        streamArr = self.alluesrArr;
    }
    for (int i=0; i<streamArr.count; i++) {
        NSString * str=streamArr[i];
        NSArray * other = [str componentsSeparatedByString:@"@"];
        if (![_chagearr containsObject:other[0]]) {
            [_chagearr addObject:other[0]];
        }
    }
    NSLog(@"动态添加更改后的参会人员数据=%@",_chagearr);
    BOOL isbool =[_chagearr containsObject:[NSString stringWithFormat:@"%@",stream.name]];
    NSInteger index = 0;
    if (isbool == YES) {
        index = [_chagearr indexOfObject:[NSString stringWithFormat:@"%@",stream.name]];
        NSLog(@"-1---%ld---",index);
    }
    
    
    
    
    switch (index) {
        case 0:
        {
            [_subscriber.view removeFromSuperview];
            self.issub = YES;
            _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            [_session subscribe:_subscriber error:&error];
            if (error)
            {
                NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                return;
            }
            UIView * vv = _rectarr[0];
            [_subscriber.view setFrame:vv.frame];
            [self.VideoArea addSubview:_subscriber.view];
        }
            break;
        case 1:
        {
            [_subscriber2.view removeFromSuperview];
            self.issub = YES;
            _subscriber2 = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            [_session subscribe:_subscriber2 error:&error];
            if (error)
            {
                NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                return;
            }
            
            UIView * vv = _rectarr[1];
            [_subscriber2.view setFrame:vv.frame];
            [self.VideoArea addSubview:_subscriber2.view];
        }
            break;
        case 2:
        {
            [_subscriber3.view removeFromSuperview];
            self.issub = YES;
            _subscriber3 = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            [_session subscribe:_subscriber3 error:&error];
            if (error)
            {
                NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                return;
            }
            
            UIView * vv = _rectarr[2];
            [_subscriber3.view setFrame:vv.frame];
            [self.VideoArea addSubview:_subscriber3.view];
            
        }
            break;
        case 3:
        {
            [_subscriber4.view removeFromSuperview];
            self.issub = YES;
            _subscriber4 = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            [_session subscribe:_subscriber4 error:&error];
            if (error)
            {
                NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                return;
            }
            
            UIView * vv = _rectarr[3];
            [_subscriber4.view setFrame:vv.frame];
            [self.VideoArea addSubview:_subscriber4.view];
            
        }
            break;
        case 4:
        {
            [_subscriber5.view removeFromSuperview];
            self.issub = YES;
            _subscriber5 = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            [_session subscribe:_subscriber5 error:&error];
            if (error)
            {
                NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                return;
            }
            
            UIView * vv = _rectarr[4];
            [_subscriber5.view setFrame:vv.frame];
            [self.VideoArea addSubview:_subscriber5.view];
            
        }
            break;
        case 5:
        {
            [_subscriber6.view removeFromSuperview];
            self.issub = YES;
            _subscriber6 = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            [_session subscribe:_subscriber6 error:&error];
            if (error)
            {
                NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                return;
            }
            UIView * vv = _rectarr[5];
            [_subscriber6.view setFrame:vv.frame];
            [self.VideoArea addSubview:_subscriber6.view];
            
        }
            break;
        case 6:
        {
            [_subscriber7.view removeFromSuperview];
            self.issub = YES;
            _subscriber7 = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            [_session subscribe:_subscriber7 error:&error];
            if (error)
            {
                NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                return;
            }
            UIView * vv = _rectarr[6];
            [_subscriber7.view setFrame:vv.frame];
            [self.VideoArea addSubview:_subscriber7.view];
        }
            break;
            
        case 7:
        {
            [_subscriber8.view removeFromSuperview];
            self.issub = YES;
            _subscriber8 = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            [_session subscribe:_subscriber8 error:&error];
            if (error)
            {
                NSLog(@"无法Unable to subscribe (%@)", error.localizedDescription);
                return;
            }
            UIView * vv = _rectarr[7];
            [_subscriber8.view setFrame:vv.frame];
            [self.VideoArea addSubview:_subscriber8.view];
        }
            break;
            
            
        default:
            break;
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
-(NSMutableArray *)rectarr {
    if (_rectarr =nil) {
        _rectarr = [[NSMutableArray alloc]init];
    }
    return _rectarr;
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
