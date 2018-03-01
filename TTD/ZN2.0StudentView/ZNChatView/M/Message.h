//
//  Message.h
//  QQChatDemo
//
//  Created by hellovoidworld on 14/12/8.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//
// message信息模型，存储聊天记录

#import <Foundation/Foundation.h>

typedef enum {
    MessageTypeMe = 0, // 我发出的信息
    MessageTypeOhter = 1 // 对方发出的信息
} MessageType;

typedef enum {
    MessageTextType =0, //文本消息
    MessagePicvType = 1, // 图片消息
    MessageAviTyer = 2 // 音频消息
} MessagepicType;
typedef enum {
    MessageState_Pending =0,//待发送
    MessageState_Delivered =1,//已发送
    MessageState_Failure =2 //发送失败
} MessageState;


@interface Message : NSObject
//发送状态
@property (nonatomic,assign) MessageState state;

/** 信息 */
@property(nonatomic, copy) NSString *text;
//图片信息
@property(nonatomic,copy) NSString * imgurl;
/** 语音信息 */
@property(nonatomic, copy) NSString *audio;
@property(nonatomic,copy) NSString * audtime;

/** 发送时间 */
@property(nonatomic, copy) NSString *time;

/** 发送方 */
@property(nonatomic, assign) MessageType type;

//发送类型
@property (nonatomic,assign)MessagepicType modetype;

/** 我的头像 */
@property (nonatomic,copy) NSString * myicon;
/** 对方头像 */
@property (nonatomic,copy) NSString * outhericon;

//消息唯一码
@property (nonatomic,copy) NSNumber * messageId;


/** 是否隐藏发送时间 */
@property(nonatomic, assign) BOOL hideTime;

- (instancetype) initWithDictionary:(NSDictionary *) dictionary;
+ (instancetype) messageWithDictionary:(NSDictionary *) dictionary;
+ (instancetype) message;

@end
