//
//  ZNXMPPManager.h
//  TTD
//
//  Created by quakoo on 2017/12/7.
//  Copyright © 2017年 totem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "XMPPMessageArchivingCoreDataStorage.h"//聊天记录管理对象
@interface ZNXMPPManager : NSObject<XMPPStreamDelegate>
//通信管道，输入输出流
@property (nonatomic,strong)XMPPStream * xmppStream;
@property (nonatomic,strong)XMPPRoster * xmpproster;
@property (nonatomic,strong)XMPPMessageArchiving * messagearchiving;
@property (nonatomic,strong)NSManagedObjectContext * messageContext;
@property (nonatomic,assign)NSInteger pro;

@property (nonatomic,strong)NSArray * getFriends;

/**
 单利方法
 */
+(ZNXMPPManager *)defaultManager;



-(void)connect:(NSString *)user :(NSString *)password :(NSInteger)purpose;

/**
 登录方法

 @param userName 用户名
 @param password 密码
 */
-(void)loginwithName:(NSString *)userName andPasword:(NSString * )password;

/**
  注册

 @param userName 用户名
 @param Password 密码
 */
-(void)registerWithName:(NSString * )userName andPassword:(NSString *)Password;


/**
 离开
 */
-(void)logout;



@end
