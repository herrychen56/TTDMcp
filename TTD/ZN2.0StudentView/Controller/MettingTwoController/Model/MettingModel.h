//
//  MettingModel.h
//  TTD
//
//  Created by 张楠 on 2018/1/9.
//  Copyright © 2018年 totem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MettingModel : NSObject

@property (nonatomic,strong) NSArray * MeeintVideo;
@property (nonatomic,strong) NSArray * MeetingChat;

@property (nonatomic,strong) NSString * LoginName;

@property (nonatomic,strong) NSString * BeginTime;
@property (nonatomic,strong) NSString * ContainSelf;
@property (nonatomic,assign) NSNumber * CreatedByID;
@property (nonatomic,strong) NSString * CreatedByName;
@property (nonatomic,strong) NSString * CreatedByRole;
@property (nonatomic,strong) NSString * Duration;
@property (nonatomic,strong) NSString * EndDatetime;
@property (nonatomic,strong) NSString * EndDatetimeStr;
@property (nonatomic,strong) NSString * EndTime;
@property (nonatomic,strong) NSString * IsDue;
@property (nonatomic,strong) NSString * IsEdit;
@property (nonatomic,assign) NSNumber * MeetingID;
@property (nonatomic,strong) NSString * MeetingUrl;
@property (nonatomic,assign) NSNumber * MeetingUserID;
@property (nonatomic,strong) NSString * StartDate;
@property (nonatomic,strong) NSString * StartDatetime;
@property (nonatomic,strong) NSString * StartDatetimeStr;
@property (nonatomic,strong) NSString * Subject;
@property (nonatomic,strong) NSString * TokboxApiKey;
@property (nonatomic,strong) NSString * TokboxSecret;
@property (nonatomic,strong) NSString * TokboxSession;
@property (nonatomic,strong) NSString * TokboxUserKey;
@property (nonatomic,assign) NSNumber * UpdatedByID;
@property (nonatomic,strong) NSArray * Users;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end
