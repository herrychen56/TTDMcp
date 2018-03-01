//
//  AppDelegate.h
//  TTD
//
//  Created by ZhangChuntao on 12/7/12.
//  Copyright (c) 2012 totem. All rights reserved.
//h

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "XMPPServer.h"

//mark
#import "DocumentsViewController.h"
//#import "PaymentViewController.h"
#import "AcademicViewController.h"
#import "StudentListViewController.h"
//zn
//#import "FloatingWindow.h"

@class BCTabBarController;
@class HomeViewController;
@class CreateTimeSheetViewController;
@class ViewTimeSheetViewController;
@class ViewStudents;
@class ViewStudentDetail;
@class MessageUserListViewController;
@class MessageChatViewController;
@class ParentSettingViewController;
@class ViewContractController;
//herry
@class StudentRequestViewController;
@class StudentInfoViewController0;
@protocol BCTabBarControllerDelegate;



@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    XMPPServer *xmppServer;
    
}
//zn
//@property(strong ,nonatomic) FloatingWindow *floatWindow;

/* ----------Mark--------------*/

@property (nonatomic, strong) DocumentsViewController *documentsViewController;
@property (nonatomic, strong) AcademicViewController *academicViewController;


/* -----------END--------------*/
@property (nonatomic,retain) XMPPServer *xmppServer;
@property (strong,nonatomic) MessageUserListViewController* messageUserListViewController;
@property (strong,nonatomic) MessageChatViewController* messageChatViewController;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController * tabbarController;

@property (strong, nonatomic) HomeViewController* homeViewController;

@property (strong, nonatomic) CreateTimeSheetViewController* createViewController;

@property (strong, nonatomic) ViewTimeSheetViewController* viewTimeSheetViewContrlller;

@property (strong, nonatomic) ViewStudents* viewStudents;

@property (strong, nonatomic) ViewStudentDetail* viewStudentDetail;

@property (strong, nonatomic) ParentSettingViewController* settingViewController;

@property (strong, nonatomic) StudentRequestViewController* studentRequestViewController;

@property (strong, nonatomic) StudentInfoViewController0* studentInfoViewController;

@property (strong, nonatomic) StudentListViewController * studentListViewController;

@property (strong, nonatomic) ViewContractController* viewContractController;

@property (strong, nonatomic) UINavigationController* navigationController;

@property (strong, nonatomic) NSMutableArray* locationArray;

@property (strong, nonatomic) NSMutableArray* totioArray;

@property (strong, nonatomic) NSMutableArray* durationArray;

@property (strong, nonatomic) NSMutableArray* studentArray;

@property (strong, nonatomic) NSMutableArray* NoShowArray;


@property (strong, nonatomic) NSMutableArray* subjectArray;

@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* password;
//herry添加角色字段
@property (strong, nonatomic) NSString* role;
//herrt 添加聊天强制关闭标记
@property (strong, nonatomic) NSString* closeFlog;
//herry 添加收到消息是否有铃声提示
@property (strong, nonatomic)NSString* isVoice;

@property (strong, nonatomic) NSString* devicetoken;
//herry headimage
@property (strong, nonatomic) NSString* imageStr;
//最近聊天人数
@property (nonatomic) NSInteger RecentContactNumber;
@property (strong, nonatomic) NSString* userFullName;
@property (strong, nonatomic) UserInfo* currentUserInfo;
@property (strong, nonatomic) UpdateInfo* updateInfo;
@property (nonatomic) BOOL shouldReloadMutableData;
@property (nonatomic) BOOL shouldReloadTimeSheetList;
@property (nonatomic) BOOL shouldReloadViewStudentList;
@property (strong, nonatomic) NSString* role_Consultant_Type;
//ZN新增
@property (nonatomic,strong) NSNumber * isvideochat;
@property (nonatomic,strong) NSString * datatimeStr;
@property (nonatomic,assign) BOOL isvideo;

@property (nonatomic,assign) BOOL  isserver;

//ZN 新增 TOKBox
@property (nonatomic,strong) NSString * tokApikey;
@property (nonatomic,strong) NSString * tokSessionId;
@property (nonatomic,strong) NSString * tokTen;

@property (nonatomic,assign) BOOL  znvideochat;

//房间唯一标识码
@property (nonatomic,strong) NSString * myVideoRoom;

@property (nonatomic,strong) NSMutableArray * otherPersonArr;
//状态栏高度
@property (nonatomic,strong) NSString * rectstatus;

@property (nonatomic,strong) XMPPRoomCoreDataStorage *rosterstorage ;


//- (void)showSendRequest:(BOOL)shouldCheck animated:(BOOL)animated;
- (void)showLogin:(BOOL)shouldCheck animated:(BOOL)animated;
- (void)loginSuccess:(BOOL)animated;
- (void)setSelectedTab:(NSInteger)tabindex;
- (void)setTabHidden:(BOOL)animated;
- (void)reloadAllControllers;
- (void)clearAllCache;
- (void)resetAll;

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


@end
