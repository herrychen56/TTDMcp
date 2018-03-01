//
//  MessageCell.h
//  QQChatDemo
//
//  Created by hellovoidworld on 14/12/8.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioToolbox.h>
#define BACKGROUD_COLOR [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0]

@class MessageFrame, Message;

/**
 cell 代理事件
 */
@protocol MessCellDelegate<NSObject>

-(void)Clickimage:(UIImage *)image;

-(void)playAVi:(NSString *)AVIStr;

-(void)CllickImageIndex:(NSNumber *)ind;

-(void)errorChageYes:(Message *)ind;

@end

@interface MessageCell : UITableViewCell<AVAudioPlayerDelegate>

 @property (strong, nonatomic)   AVAudioPlayer  *player;

/**
 Cell代理属性
 */
@property (strong,nonatomic)id<MessCellDelegate>delegate;


/** 持有存储了聊天记录和聊天框位置尺寸的frame */
@property(nonatomic, strong) MessageFrame *messageFrame;



/** 传入父控件tableView引用的构造方法 */
+ (instancetype) cellWithTableView:(UITableView *) tableView;

@end
