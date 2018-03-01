//
//  AppDelegate.m
//  TTD
//
//  Created by  on 12/7/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "BCTabBarController.h"
#import "HomeViewController.h"
//#import "GHConsole.h"

#import "MessageUserListViewController.h"
//#import "MessageChatViewController.h"
#import "Statics.h"
#import "ParentSettingViewController.h"
#import "StudentRequestViewController.h"
#import "StudentInfoViewController0.h"
#import "JSBadgeView.h"

#import "StudentListViewController.h"
//ZN 新建页面
#import "Reachability.h"
#import "NewParentSettingViewController.h"//ZN 新建个人页面
#import "StudentMainViewController.h"//ZN 新建学生首页
#import "ProgressreportViewController.h"//ZN 新建Progress
#import "MessagesViewController.h" //ZN新建MEssage
#import "AcdemicViewController.h" //ZN 新建Acdemic
#import "MettingsViewController.h"//ZN 新建Metting
#import "ZNReceVideChaatViewController.h"//ZN 新建视频请求页面
#import "NSData+Base64.h"
#import "UIView+MJAlertView.h"//警示框
#import "ZNListViewController.h"//多选列表
#import "ManagerHomeViewController.h"//顾问经理首页
#import "ZNNewParentViewController.h"//geren  2-3new

@implementation AppDelegate
@synthesize devicetoken;
@synthesize xmppServer;
@synthesize window = _window;
@synthesize tabbarController, homeViewController, createViewController, viewTimeSheetViewContrlller,viewStudents,viewStudentDetail,messageUserListViewController,messageChatViewController,settingViewController,viewContractController;
@synthesize navigationController;

@synthesize studentRequestViewController;
@synthesize studentInfoViewController;
 
- (void)showLogin:(BOOL)should animated:(BOOL)animated {
    LoginViewController* controller = [[LoginViewController alloc] init];
    controller.shouldCheckAutologin = should;
    /*[self.window.rootViewController presentModalViewController:controller animated:animated];
     */
    //herry
//    [self.window.rootViewController dismissModalViewControllerAnimated:NO];
    [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)reloadAllControllers {
    for (UIViewController* controller in self.tabbarController.viewControllers) {
        [controller resetViews];
    }
}

- (void)clearAllCache {
    for (UIViewController* controller in self.tabbarController.viewControllers) {
        [controller clearCache];
        
    }
    [xmppServer disconnect];
}

- (void)resetAll {
    self.tabbarController = nil;
    self.homeViewController = nil;
    self.studentRequestViewController = nil;
    self.settingViewController = nil;
    self.viewStudents = nil;
    self.viewStudentDetail = nil;
    self.viewContractController = nil;
    self.messageChatViewController = nil;
    self.messageUserListViewController = nil;
    self.studentInfoViewController = nil;
    self.documentsViewController = nil;
    self.academicViewController = nil;
    
    self.studentInfoViewController = nil;
    self.studentListViewController = nil;
}

- (UITabBarController *)tabbarController {
    if (!tabbarController) {
        [MBManager showLoading];
        
        self.tabbarController = [[UITabBarController alloc] init];
//        [self.tabbarController.tabBar setTintColor:[UIColor whiteColor]];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.tabbarController.tabBar insertSubview:backView atIndex:0];
        self.tabbarController.tabBar.opaque = NO;
        
    
        NSMutableArray *array = [NSMutableArray new];
        if ([self.role isEqualToString:@"tutor"]) {
            NSLog(@"===== 家教页面,暂时有问题 ===== ");
            TTDNavigationController *navController = [[TTDNavigationController alloc] initWithRootViewController:self.homeViewController];
            UITabBarItem *tabbarItem = [[UITabBarItem alloc] initWithTitle:@"Session Tracker" image:[UIImage imageNamed:@"tab_icon_time"] selectedImage:[UIImage imageNamed:@"tab_icon_time_selected"]];
            navController.tabBarItem = tabbarItem;
            [array addObject:navController];
            
            navController = [[TTDNavigationController alloc] initWithRootViewController:self.studentRequestViewController];
            tabbarItem = [[UITabBarItem alloc] initWithTitle:@"Request" image:[UIImage imageNamed:@"tab_icon_student_request"] selectedImage:[UIImage imageNamed:@"tab_icon_student_request_selected"]];
            navController.tabBarItem = tabbarItem;
            [array addObject:navController];
            
            navController = [[TTDNavigationController alloc] initWithRootViewController:self.settingViewController];
            tabbarItem = [[UITabBarItem alloc] initWithTitle:@"Setting" image:[UIImage imageNamed:@"tab_icon_settings"] selectedImage:[UIImage imageNamed:@"tab_icon_settings_selected"]];
            navController.tabBarItem = tabbarItem;
            [array addObject:navController];
        }  else if([self.role isEqualToString:@"parent"]) {
            NSLog(@"======家长======");
            TTDNavigationController *navController = [[TTDNavigationController alloc] initWithRootViewController:self.messageUserListViewController];
            UITabBarItem *tabbarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"TapBar_Chat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"TapBar_Chat_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            tabbarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
            navController.tabBarItem = tabbarItem;
            [array addObject:navController];
            self.studentInfoViewController=[[StudentInfoViewController0 alloc] init];
            //            navController = [[TTDNavigationController alloc] initWithRootViewController:self.documentsViewController];
            navController = [[TTDNavigationController alloc] initWithRootViewController:self.studentInfoViewController];
            tabbarItem =[[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"TapBar_Meetings"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"TapBar_Meetings_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
            tabbarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
            navController.tabBarItem = tabbarItem;
            [array addObject:navController];
            navController = [[TTDNavigationController alloc] initWithRootViewController:self.studentListViewController];
            /*  ZN 临时注释
             self.studentListViewController.currentTab = @"Academic";
             tabbarItem = [[UITabBarItem alloc] initWithTitle:@"Academic" image:[UIImage imageNamed:@"tab_icon_academic"] selectedImage:[UIImage imageNamed:@"tab_icon_academic_selected"]];
             navController.tabBarItem = tabbarItem;
             [array addObject:navController];
             */
            // 临时注释家长支付功能
            //            navController = [[TTDNavigationController alloc] initWithRootViewController:self.paymentViewController];
            //            tabbarItem = [[UITabBarItem alloc] initWithTitle:@"Payment" image:[UIImage imageNamed:@"tab_icon_payment"] selectedImage:[UIImage imageNamed:@"tab_icon_payment_selected"]];
            //            navController.tabBarItem = tabbarItem;
            //            [array addObject:navController];
            
            NewParentSettingViewController * newparent = [[NewParentSettingViewController alloc]init];
            navController = [[TTDNavigationController alloc] initWithRootViewController:newparent];
            tabbarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"NewTabgeren"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"NewTabSendgeren"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
            tabbarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
            navController.tabBarItem = tabbarItem;
            [array addObject:navController];
        }else if([self.role isEqualToString:@"consultant"] || [self.role isEqualToString:@"manager"]) {
            NSLog(@"=====顾问 和   经理 ========");
            ManagerHomeViewController * magerMain =[ManagerHomeViewController new];
            TTDNavigationController * navController = [[TTDNavigationController alloc]initWithRootViewController:magerMain];
            UITabBarItem * tabbarItem = [[UITabBarItem alloc]initWithTitle:@"" image:[[UIImage imageNamed:@"TapBar_Home"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"TapBar_Home_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
             tabbarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
            navController.tabBarItem = tabbarItem;
            [array addObject:navController];
            //MessageUserListViewcontroller
            
            navController = [[TTDNavigationController alloc] initWithRootViewController:self.messageUserListViewController];
            //            TTDNavigationController *navController = [[TTDNavigationController alloc] initWithRootViewController:self.messageUserListViewController];
            tabbarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"TapBar_Chat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"TapBar_Chat_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            tabbarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
            navController.tabBarItem = tabbarItem;
            [array addObject:navController];
            //StudentListViewController
          MettingsViewController * mettingV = [[MettingsViewController alloc]init];
//            mettingV.currentTab = @"MCP";
            navController = [[TTDNavigationController alloc] initWithRootViewController:mettingV];
            tabbarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"TapBar_Meetings"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"TapBar_Meetings_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
            tabbarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
            navController.tabBarItem = tabbarItem;
            [array addObject:navController];
            //StudentListViewController
            StudentListViewController *slVC2 = [StudentListViewController new];
            slVC2.currentTab = @"Academic";
            navController = [[TTDNavigationController alloc] initWithRootViewController:slVC2];
            tabbarItem =[[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"contacts"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"Tapbar_contacts_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
            tabbarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
            navController.tabBarItem = tabbarItem;
            [array addObject:navController];
            //NewparentSettingViewController (个人中心)
//            NewParentSettingViewController * newparent = [[NewParentSettingViewController alloc]init];
            ZNNewParentViewController * newparent = [[ZNNewParentViewController alloc]init];
            navController = [[TTDNavigationController alloc] initWithRootViewController:newparent];
            tabbarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"profile"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"TapBar_profile_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
            tabbarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
            navController.tabBarItem = tabbarItem;
            [array addObject:navController];
            
        }
        else if([self.role isEqualToString:@"student"]) {
            NSLog(@"======学生=====");
            //学生首页
            StudentMainViewController * stuMain =[StudentMainViewController new];
            TTDNavigationController * navController = [[TTDNavigationController alloc]initWithRootViewController:stuMain];
            UITabBarItem * tabbaritem = [[UITabBarItem alloc]initWithTitle:@"" image:[[UIImage imageNamed:@"TapBar_Home"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"TapBar_Home_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
            navController.tabBarItem = tabbaritem;
            tabbaritem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
            [array addObject:navController];
            //ProgressreportView
            ProgressreportViewController * proview=[ProgressreportViewController new];
            navController = [[TTDNavigationController alloc]initWithRootViewController:proview];
            tabbaritem = [[UITabBarItem alloc]initWithTitle:@"" image:[[UIImage imageNamed:@"TapBar_PR"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"TapBar_PR_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            navController.tabBarItem = tabbaritem;
            tabbaritem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
            [array addObject:navController];
            //MessagesViewController
            MessagesViewController * messageV = [MessagesViewController new];
            navController = [[TTDNavigationController alloc]initWithRootViewController:self.messageUserListViewController];
            tabbaritem = [[UITabBarItem alloc]initWithTitle:@"" image:[[UIImage imageNamed:@"TapBar_Chat"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"TapBar_Chat_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            navController.tabBarItem = tabbaritem;
            tabbaritem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
            [array addObject:navController];
            //MettingsViewController
            MettingsViewController * mettingV = [[MettingsViewController alloc]init];
            navController = [[TTDNavigationController alloc]initWithRootViewController:mettingV];
            tabbaritem = [[UITabBarItem alloc]initWithTitle:@"" image:[[UIImage imageNamed:@"TapBar_Meetings"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"TapBar_Meetings_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            navController.tabBarItem = tabbaritem;
            tabbaritem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
            [array addObject:navController];
            //AcdemicViewController
            AcdemicViewController * acdemV = [AcdemicViewController new];
            navController = [[TTDNavigationController alloc]initWithRootViewController:acdemV];
            tabbaritem = [[UITabBarItem alloc]initWithTitle:@"" image:[[UIImage imageNamed:@"TapBar_Academic"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"TapBar_Academic_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            navController.tabBarItem = tabbaritem;
            tabbaritem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
            [array addObject:navController];
            
        }
        [tabbarController setViewControllers:array];
    }
    
    return tabbarController;
}

#pragma mark - ZN

- (ParentSettingViewController *)settingViewController {
    if (!settingViewController) {
        settingViewController = [ParentSettingViewController new];
    }
    return settingViewController;
}


- (HomeViewController *)homeViewController {
    if (!homeViewController) {
        homeViewController = [HomeViewController new];
    }
    return homeViewController;
}
- (StudentRequestViewController *)studentRequestViewController {
    if (!studentRequestViewController) {
        studentRequestViewController = [StudentRequestViewController new];
    }
    return studentRequestViewController;
}

- (MessageUserListViewController *)messageUserListViewController {
    if (!messageUserListViewController) {
        messageUserListViewController = [MessageUserListViewController new];
    }
    return messageUserListViewController;
}




- (StudentInfoViewController0 *)studentInfoViewController {
    if (!studentInfoViewController) {
        studentInfoViewController = [StudentInfoViewController0 new];
    }
    return studentInfoViewController;
}

- (DocumentsViewController *)documentsViewController {
    if (!_documentsViewController) {
        _documentsViewController = [DocumentsViewController new];
    }
    return _documentsViewController;
}



- (AcademicViewController *)academicViewController {
    if (!_academicViewController) {
        _academicViewController = [AcademicViewController new];
    }
    return _academicViewController;
}

- (StudentListViewController *)studentListViewController {
    if (!_studentListViewController) {
        _studentListViewController = [StudentListViewController new];
    }
    return _studentListViewController;
}
#pragma mark - 视频邀请通知
-(void)chageVideoMessage:(NSNotification *)notification {
    
    if (_isvideo ==NO) {
        NSDictionary * dic = notification.userInfo;
        NSLog(@"收到视频邀请通知！！！！！=%@",dic);//VsessionID
        ZNReceVideChaatViewController * znrecevideoV=[[ZNReceVideChaatViewController alloc]init];
        NSString * reqname = [dic objectForKey:@"reqname"];
        znrecevideoV.reqname = reqname;
        znrecevideoV.namelab.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        znrecevideoV.nametext =[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        znrecevideoV.ismultiple =NO;
        znrecevideoV.otherArr =[dic objectForKey:@"number"];
        znrecevideoV.VsessionID = [dic objectForKey:@"VsessionID"];
        UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topRootViewController.presentedViewController)
        {
            topRootViewController = topRootViewController.presentedViewController;
        }
        [topRootViewController presentViewController:znrecevideoV animated:YES completion:nil];
    }
//    self.window.rootViewController = znrecevideoV;
//    [self.window makeKeyAndVisible];

}
#pragma mark - 多少人视频通知
-(void)multiplemessage:(NSNotification *) notif {
    
    if (_isvideo ==NO) {
        NSDictionary * dic = notif.userInfo;
        NSLog(@"收到多人视频请求邀请=%@",[dic objectForKey:@"number"]);
        ZNReceVideChaatViewController * znrecevideoV=[[ZNReceVideChaatViewController alloc]init];
        znrecevideoV.namelab.text=[NSString stringWithFormat:@"%@ Launch multiple video",[dic objectForKey:@"name"]];
        znrecevideoV.nametext =[NSString stringWithFormat:@"%@ Launch multiple video",[dic objectForKey:@"name"]];
        znrecevideoV.ismultiple =YES;
        znrecevideoV.numberstr =[dic objectForKey:@"number"];
        UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topRootViewController.presentedViewController)
        {
            topRootViewController = topRootViewController.presentedViewController;
        }
        
        [topRootViewController presentViewController:znrecevideoV animated:YES completion:nil];
    }

    
}
#pragma mark - 动态添加通知
-(void)DynamicallyAdd:(NSNotification *)notif {
    NSDictionary * dic = notif.userInfo;
    ZNListViewController * znlistV = [[ZNListViewController alloc]init];
    
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    znlistV.numbStr = [dic objectForKey:@"numb"];
    znlistV.personArr = [dic objectForKey:@"name"];
    [topRootViewController presentViewController:znlistV animated:YES completion:nil];
}

//对方忙
-(void)otheris:(NSNotification *)notif {
    NSDictionary * dic = notif.userInfo;
    
//    NSArray *strs=[[dic objectForKey:@"name"] componentsSeparatedByString:@"/"];
    NSString * bodystr =@"otheris";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString * bodyStr=[NSString stringWithFormat:@"%@*%@",dateString,bodystr];
    NSMutableString *soundString = [[NSMutableString alloc]initWithString:@"[/9]"];
    [soundString appendString:bodyStr];
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
    [mes addAttributeWithName:@"to" stringValue:[dic objectForKey:@"name"]];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    //组合
    [mes addChild:body];
    NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [mes addChild:received];
    [[XMPPServer xmppStream] sendElement:mes];
    NSLog(@"发送对方正忙。内容 =%@,接收者=%@",soundString,[dic objectForKey:@"name"]);
}

- (void)loginSuccess:(BOOL)animated {
    //herry
//     [[NSNotificationCenter defaultCenter]postNotificationName:@"VideoChatRequest" object:nil];
    
    self.settingViewController=[[ParentSettingViewController alloc]init];
    UINavigationController* naviSeting = [[UINavigationController alloc] initWithRootViewController:self.settingViewController];
    naviSeting.navigationBarHidden = YES;

    UINavigationController* navi = (UINavigationController*)[self.tabbarController.viewControllers objectAtIndex:0];
    BaseViewController* controller = (BaseViewController*)[navi.viewControllers objectAtIndex:0];
    [controller loadNeededInfo];
    self.shouldReloadTimeSheetList = YES;
    self.shouldReloadTimeSheetList = YES;
    self.tabbarController.selectedIndex = 0;

    [self.window.rootViewController presentViewController:self.tabbarController animated:animated completion:nil];
    [self.window makeKeyAndVisible];
}

- (void)setSelectedTab:(NSInteger)tabindex {
    self.tabbarController.selectedIndex = tabindex;
}
-(void)setTabHidden:(BOOL)animated {
    [self.tabbarController setHidesBottomBarWhenPushed:YES];
    [self.tabbarController.tabBar removeFromSuperview];
    //self.tabbarController.tabBar.hidden=animated;
    //self.tabbarController.hidesBottomBarWhenPushed=NO;
    //[self.window.rootViewController presentModalViewController:self.tabbarController animated:NO]; Reject video request to close the page
}
#pragma mark - 收到发送失败通知
-(void)sendmessageerror {
    dispatch_async(dispatch_get_main_queue(), ^{
//         [UIView addMJNotifierWithText:@"Failed to send, check the network" dismissAutomatically:YES];
//         [TopAlertView SetUpbackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.8] andStayTime:3 andImageName:@"1" andTitleStr:@"Failed to send, check the network" andTitleColor:[UIColor whiteColor]];
    });
   
}
#pragma mark - 程序启动
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.rosterstorage = [[XMPPRoomCoreDataStorage alloc]init];
    
    //桌面log
//      [[GHConsole sharedConsole] startPrintLog];
    
    //zn 缩放视图
//    self.floatWindow = [[FloatingWindow alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT/2-25, 50, 50) imageName:@"av_call"];
//    [self.floatWindow makeKeyAndVisible];
//    self.floatWindow.hidden = YES;
    
    _myVideoRoom = [[NSString alloc]init];
    _otherPersonArr = [[NSMutableArray alloc]init];
    
    _znvideochat =NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isserver == NO) {
//                 [UIView addMJNotifierWithText:@"The server is disconnected and is being reconnected!" dismissAutomatically:YES];
//                 [TopAlertView SetUpbackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.8] andStayTime:3 andImageName:@"1" andTitleStr:@"The server is disconnected and is being reconnected!" andTitleColor:[UIColor whiteColor]];
            }
        });
    });
    //收到动态添加人员通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DynamicallyAdd:) name:@"DynamicallyAdd" object:nil];
    
    //收到视频请求通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chageVideoMessage:) name:@"VideoChatRequest" object:nil];
   
    
    //收到发送失败通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendmessageerror) name:@"sendmessageerror" object:nil];
    
    //收到多人视频请求通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(multiplemessage:) name:@"multipleVideoChatRequest" object:nil];
    //收到对方忙通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otheris:) name:@"otheris" object:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"沙盒路径==== %@",paths);
    
    _isvideo = NO;
    _isvideochat = [NSNumber numberWithInt:0];//是否视频状态
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   _datatimeStr = [formatter stringFromDate:[NSDate date]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    LoginViewController* controller = [[LoginViewController alloc] init];
    controller.shouldCheckAutologin=YES;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = self.navigationController;
    self.navigationController.navigationBarHidden = YES;
    [self.window makeKeyAndVisible];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
 
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
    }
    /* 推送的注册，监听和处理都集中在appdelegate 类里
     1.完成推送功能注册请求，即在程序启动时弹出是否使用推送功能
     2.实现程序启动是通过推送消息窗口触发的，这didfinishlanunchingwithoption 这里处理推送内容
     */
    //注册推送通知
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    //判断程序是不是由推送服务完成
    if(launchOptions)
{
        NSDictionary* pushNotificationKey=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
//            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"TTD-Message" message:@"New Message" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Other", nil];
//            [alert show];
            
        }
    }
#ifdef __IPHONE_8_0 //这里主要是针对iOS 8.0,相应的8.1,8.2等版本各程序员可自行发挥，如果苹果以后推出更高版本还不会使用这个注册方式就不得而知了……
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }  else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
#else
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    return YES;
    
}
void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr=[exception callStackSymbols];
    NSString *reason=[exception reason];
    NSString *name=[exception name];
    NSString *str=[NSString stringWithFormat:@"Bug name:%@ reason:%@ arr:%@",name,reason,[arr componentsJoinedByString:@"\r\n"]];
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            @"ios",@"Type",
                            str,@"log",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_INSERTLOG parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         NSLog(@"result, error:%@",error);
     }];
    [operation start];
    
}
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
#endif
//topid
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //注册远方通知 获得 device token
    NSString* token=[NSString stringWithFormat:@"%@",deviceToken];
    devicetoken=token;
    NSLog(@"Apns:%@",token);
    
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //注册失败
    NSString *str=[NSString stringWithFormat:@"%@",error];
    NSLog(@"ApnsError:%@",str);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //收到通知
    /*
     NSLog(@"userinfo:%@",userInfo);
     if([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL)
     {
     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"TTDMessage" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"Cencel" otherButtonTitles:@"Other", nil];
     [alert show];
     }
     NSString *topid=[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
     //清除图标上的通知记录数...
     //application.applicationIconBadgeNumber=0;
     */
    //点击对话框打开操作
    self.tabbarController.selectedIndex=0;
//    if([self.role isEqualToString:TTDROLE_CONSULTANT])
//    {
//        self.tabbarController.selectedIndex=0;
//    }else if([self.role isEqualToString:TTDROLE_STUDENT])
//    {
//        self.tabbarController.selectedIndex=0;
//    }
//    else if([self.role isEqualToString:TTDROLE_STUDENT])
//    {
//        self.tabbarController.selectedIndex=0;
//    }
//    else if([self.role isEqualToString:TTDROLE_MANAGER])
//    {
//        self.tabbarController.selectedIndex=0;
//    }
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}
#pragma mark - 程序挂起
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"程序挂起按了home");
    //zn 临时注销
//    [xmppServer disconnect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //herry
    //[self loginoutsave];
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"程序进入前台");
}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    if([self.role isEqualToString:TTDROLE_CONSULTANT]||[self.role isEqualToString:TTDROLE_STUDENT]||[self.role isEqualToString:TTDROLE_MANAGER]) {
//        //[self hiddenHUD];
//        xmppServer = [XMPPServer sharedServer];
//        [xmppServer connect];
//        
//    }
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application {
    [xmppServer disconnect];
    NSLog(@"程序将终止");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)tabBarController:(BCTabBarController *)tabBarController didSelectViewControllerAtIndex:(int)index
{
    if (index == 3) {
        [self showLogin:NO animated:YES];
    }
}


- (void)loginoutsave
{
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_MEETINGS parameters:params];
    __weak typeof(self) wself = self;
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
        
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
            NSLog(@"请求失败 ==%@",error);
    }];
    [operation start];
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(BOOL) prefersStatusBarHidden {
    return NO;
}

#pragma mark - 字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}





//- (UIInterfaceOrientationMask)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window//
//{
//    //[ self.tabbarController shouldAutorotate];
//    //[ self.tabbarController preferredInterfaceOrientationForPresentation];
//    return UIInterfaceOrientationMaskAll;
//}
@end
