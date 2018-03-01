//
//  WCMessageObject.h
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMESSAGE_TYPE @"messageType"
#define kMESSAGE_FROM @"messageFrom"
#define kMESSAGE_TO @"messageTo"
#define kMESSAGE_CONTENT @"messageContent"
#define kMESSAGE_DATE @"messageDate"
#define kMESSAGE_ID @"messageId"
#define kMESSAGE_USERNAME @"username"
#define kMESSAGE_STATE @"messageState"
#define kMESSAGE_Count @"messageStateCount"

#define kMESSAGE_SendType @"messagesendType"
#define kMEssAGE_AudioTime @"messageaudioTimes"


enum kWCMessageType {
    kWCMessageTypePlain = 0,
    kWCMessageTypeImage = 1,
    kWCMessageTypeVoice =2,
    kWCMessageTypeLocation=3,
    kWCMessageTypeFace=4,
    //herry 20140428
    kWCMessageTypeAttachment=6,
    kWCMessageTypedidVideo =8,
    kWCMessageTypeVideoChat =9
};

enum kWCMessageCellStyle {
    kWCMessageCellStyleMe = 0,
    kWCMessageCellStyleOther = 1,
    kWCMessageCellStyleMeWithImage=2,
    kWCMessageCellStyleOtherWithImage=3,
    kWCMessageCellStyleMeWithFace=4,
    kWCMessageCellStyleOtherWithFace=5,
    //herry20140428
    kWCMessageCellStyleOtherWithAttachment=6
};




@interface WCMessageObject : NSObject
@property (nonatomic,retain) NSString *messageFrom;
@property (nonatomic,retain) NSString *messageTo;
@property (nonatomic,retain) NSString *messageContent;
@property (nonatomic,retain) NSDate *messageDate;
@property (nonatomic,retain) NSNumber *messageType;
@property (nonatomic,retain) NSNumber *messageId;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *messageState;
@property (nonatomic,retain) NSString *messageCount;

//zn
@property (nonatomic,retain) NSNumber * messagesendType;
@property (nonatomic,retain) NSString * messageaudioTimes;

@property (nonatomic,retain) NSString* userId;
@property (nonatomic,retain) NSString* userNickname;
@property (nonatomic,retain) NSString* userDescription;
@property (nonatomic,retain) NSString* userHead;
@property (nonatomic,retain) NSNumber* friendFlag;
@property (nonatomic,retain) NSString* group;

+(WCMessageObject *)messageWithType:(int)aType;

//将对象转换为字典
-(NSDictionary*)toDictionary;
+(WCMessageObject*)messageFromDictionary:(NSDictionary*)aDic;

//数据库增删改查
+(BOOL)save:(WCMessageObject*)aMessage;
+(BOOL)deleteMessageById:(NSNumber*)aMessageId;
//+(BOOL)merge:(WCMessageObject*)aMessage;
+(BOOL)delMessageListWithUser:(NSString*)FromTo UserName:(NSString *)ByUserName;
//获取某联系人聊天记录
+(NSMutableArray *)fetchMessageListWithUser:(NSString *)userFrom username:(NSString *)messageusername byPage:(int)pageIndex;
+(NSMutableArray *)fetchMessageListWithUserOrderByDesc:(NSString *)userId username:(NSString *)messageusername byPage:(int)pageIndex;
+(BOOL)UpdataMessageState:(NSString *)FromTo UserName:(NSString *)ByUserName;
+(BOOL)UpdataMessageSendErrorType:(NSString *)FromTo ;

+(BOOL)UpdataMessageSendYesType:(NSString *)date ;

//获取最近联系人
+(NSMutableArray *)fetchRecentChatByPage:(int)pageIndex;
+(NSMutableArray *)fetchAllUserMessageInfo:(NSString *)username;
+(int*)CountMessageState:(NSString *)FromTo UserName:(NSString *)ByUserName;
+(int)fetchMessageListWithUserCount:(NSString *)userFrom username:(NSString *)messageusername;
@end
