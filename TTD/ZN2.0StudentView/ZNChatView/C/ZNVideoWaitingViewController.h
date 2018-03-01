//
//  ZNVideoWaitingViewController.h
//  TTD
//
//  Created by quakoo on 2017/12/18.
//  Copyright © 2017年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNVideoWaitingViewController : UIViewController



/**
 对方Name
 */
@property (nonatomic,strong) NSString * outherName;
/**
 Tokbox Session
 */
@property (nonatomic,strong) NSString * outToboxSession;

/**
 我的头像
 */
@property (nonatomic,strong) NSString * outherICon;
/**
 左上返回按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *backbutton;
/**
对方视图
 */
@property (weak, nonatomic) IBOutlet UIView *outherView;
/**
我的视图
 */
@property (weak, nonatomic) IBOutlet UIView *MyVideoVv;
/**
麦克风按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *MKFButton;
/**
 录像按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *LXButton;
/**
 声音按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *SYButton;
/**
 挂断按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *GDButton;

/**
waiting
 */
@property (weak, nonatomic) IBOutlet UILabel *waitinglab;

/**
 小头像
 */
@property (weak, nonatomic) IBOutlet UIView *SmallHeadView;
/**
 翻转摄像头
 */
@property (weak, nonatomic) IBOutlet UIButton *FZButton;
/**
 被叫
 */
@property (nonatomic,assign) BOOL  IsCalled;
@end
