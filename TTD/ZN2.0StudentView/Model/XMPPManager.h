//
//  XMPPManager.h
//  myXmpp
//
//  Created by ccyy on 15/8/4.
//  Copyright (c) 2015年 ccyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "XMPPMessageArchiving.h"

#import "XMPPMessageArchivingCoreDataStorage.h"
/**
 *  该类主要封装了xmpp的常用方法
 */
@interface XMPPManager : NSObject<XMPPStreamDelegate,XMPPStreamDelegate,XMPPRosterDelegate>
//通信管道，输入输出流
@property(nonatomic,strong)XMPPStream *xmppStream;
//好友管理
@property(nonatomic,strong)XMPPRoster * xmppRoster;
//聊天信息归档
@property(nonatomic,strong)XMPPMessageArchiving * xmppMessageArchiving;
//信息归档上下文
@property (nonatomic,strong)NSManagedObjectContext * messageArchivingContext;


//单例方法
+(XMPPManager *)defaultManager;
//登录的方法
-(void)loginwithName:(NSString *)userName andPassword:(NSString *)password;
//注册
-(void)registerWithName:(NSString *)userName andPassword:(NSString *)password;
-(void)logout;
@end
