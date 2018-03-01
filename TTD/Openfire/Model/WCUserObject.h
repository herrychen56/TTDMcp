//
//  WCUserObject.h
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kUSER_ID @"userId"
#define kUSER_NICKNAME @"userNickname"
#define kUSER_DESCRIPTION @"userDescription"
#define kUSER_USERHEAD @"userHead"
#define kUSER_FRIEND_FLAG @"friendFlag"
#define kUSER__USERNAME @"username"
#define kUSER__GROUP @"group"

#import "BaseViewController.h"

@interface WCUserObject : NSObject
@property (nonatomic,retain) NSString* userId;
@property (nonatomic,retain) NSString* userNickname;
@property (nonatomic,retain) NSString* userDescription;
@property (nonatomic,retain) NSString* userHead;
@property (nonatomic,retain) NSNumber* friendFlag;
@property (nonatomic,retain) NSString* username;
@property (nonatomic,retain) NSString* group;

//数据库增删改查
+(BOOL)saveNewUser:(WCUserObject*)aUser;
+(BOOL)deleteUserById:(NSMutableArray*)userList userName:(NSString *)ByUserName;
+(BOOL)updateUser:(WCUserObject*)newUser;
+(BOOL)haveSaveUserById:(NSString*)userId userName:(NSString *)ByUserName;
+(BOOL)updateUserHead:(WCUserObject*)newUser userHead:(NSString *)userHeadby;
+(NSMutableArray*)fetchAllFriendsFromLocal;
+(WCUserObject*)fetchAllFriendsFromUserID:(NSString *)UserID username:(NSString *)ByUserName;
//将对象转换为字典
-(NSDictionary*)toDictionary;
+(WCUserObject*)userFromDictionary:(NSDictionary*)aDic;
+(void)UserPhotoSet:(NSMutableArray *)UserArray;
+(NSMutableArray*)fetchAllFromUsername:(NSString *)username;
@end
