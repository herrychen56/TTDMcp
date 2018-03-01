//
//  ZNManyPeopleVideoViewController.h
//  TTD
//
//  Created by 张楠 on 2017/12/23.
//  Copyright © 2017年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloatingWindow.h"
@interface ZNManyPeopleVideoViewController : UIViewController
@property(strong ,nonatomic) FloatingWindow *floatWindow;

//视频apik
@property(nonatomic,strong) NSString * videoapiKey;
//视频secert
@property(nonatomic,strong) NSString * videosecert;
//视频session
@property (nonatomic,strong) NSString * videoSeesion;
//视频Token
@property (nonatomic,strong) NSString * videoToken;

//视频区域
@property (weak, nonatomic) IBOutlet UIView *VideoArea;
//返回按钮
@property (weak, nonatomic) IBOutlet UIButton *backView;

//翻转相机按钮
@property (weak, nonatomic) IBOutlet UIButton *carmebutton;

//话筒静音按钮
@property (weak, nonatomic) IBOutlet UIButton *MKFButton;

//停止推送视频流
@property (weak, nonatomic) IBOutlet UIButton *SPButton;

//声音按钮
@property (weak, nonatomic) IBOutlet UIButton *SYButton;

//挂断按钮
@property (weak, nonatomic) IBOutlet UIButton *GDButton;

//返回聊天
@property (weak, nonatomic) IBOutlet UIButton *gobackchat;
//添加人数
@property (weak, nonatomic) IBOutlet UIButton *addperson;


//多人视频
@property (nonatomic,strong) NSMutableArray * mtarr;

@property (nonatomic,strong) NSString * getvideoarr;
//新增动态人数
@property (nonatomic,strong) NSMutableArray * alluesrArr;
//动态新增SessionID
@property (nonatomic,strong) NSString * SessionID;
@property (nonatomic,strong) NSMutableArray * nichengarr;

@end
