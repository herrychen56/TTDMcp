//
//  ZNXMPPManager.m
//  TTD
//
//  Created by quakoo on 2017/12/7.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "ZNXMPPManager.h"

typedef NS_ENUM(NSInteger, ConnectServerPurpose)
{
    ConnectServerPurposeLogin,    //登录
    ConnectServerPurposeRegister   //注册
};

@interface ZNXMPPManager()
//用来记录用户输入的密码
@property(nonatomic,strong)NSString *password;
@property(nonatomic)ConnectServerPurpose connectServerPurposeType;//用来标记连接服务器目的的属性



@end

@implementation ZNXMPPManager

#pragma mark - 单利方法
+(ZNXMPPManager *)defaultManager {
    static ZNXMPPManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager =[[ZNXMPPManager alloc]init];
    });
    return manager;
}
#pragma mark - 重写INIT
-(instancetype)init {
    if ([super init]) {
        //初始化xmppstream，登录和注册都用
        self.xmppStream = [[XMPPStream alloc]init];
        self.xmppStream.enableBackgroundingOnSocket = YES;
        //设置代理
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        // 系统写好的xmpp存储对象
        XMPPRosterCoreDataStorage *rosterCoreDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
        self.xmpproster = [[XMPPRoster alloc]initWithRosterStorage:rosterCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        //激活roster
        [self.xmpproster activate:self.xmppStream];
        //初始化聊天记录管理对象
        XMPPMessageArchivingCoreDataStorage * archiving = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        self.messagearchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:archiving dispatchQueue:dispatch_get_main_queue()];
        //激活管理对象
        [self.messagearchiving activate:self.xmppStream];
        //给管理对象添加代理
        [self.messagearchiving addDelegate:self delegateQueue:dispatch_get_main_queue()];
        self.messageContext = archiving.mainThreadManagedObjectContext;
       
    }
    return self;
}
#pragma mark -connect方法、登录注册
-(void)connect:(NSString *)user :(NSString *)password :(NSInteger)purpose {
    self.password = password;
    self.pro = purpose;
    
    if ([self.xmppStream isConnected]) {
        [self.xmppStream disconnect];
    }
   
      NSDate *datenow = [NSDate date];
      NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//      [xmppStream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@/%@",user,OpenFireHostName,timeSp] resource:@"IOS"]];
    XMPPJID * jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@/%@",user,OpenFireHostName,timeSp] resource:@"IOS"];
    [self.xmppStream setMyJID:jid];
    
    
    [self.xmppStream setHostName:OpenFireUrl];
    NSError * error = nil;
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        NSLog(@"connect方法 error = %@",error);
    }
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"连接服务器失败的方法，请检查网络是否正常");
}
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
    NSLog(@"连接成功");
}
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"再发送密码授权");
    NSError * err=nil;
    switch (self.pro) {
        case 1:
            [self.xmppStream authenticateWithPassword:self.password error:&err];
            break;
        case 2:
            [self.xmppStream registerWithPassword:self.password error:&err];
            
        default:
            break;
    }
    
    if (err) {
        NSLog(@"再次发送密码失败  pro%ld     ==%@",(long)self.pro,err);
    }
    
}
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [self.xmppStream sendElement:presence];
    NSLog(@"登陆成功%@",presence);
    
}

-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"授权失败 %@",error);
    [self.xmppStream disconnect];
    
}
- (void) xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
    
}
- (void) xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败");
}
- (void) registerAction:(NSString *)user :(NSString *)password{
    NSLog(@"registeraction === user ==%@   password == %@",user,password);
}

- (void) XMPPAddFriendSubscribe:(NSString *)name{
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,OpenFireHostName]];
//    [presence addAttributeWithName:@"subscription" stringValue:@"好友"];
    [self.xmpproster subscribePresenceToUser:jid];
}

#pragma mark - 收到消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message  {
    //内容
    NSString * msg = [[message elementForName:@"body"]stringValue];
    //发送者
    NSString * from = [[message attributeForName:@"from"]stringValue];
    NSString *xmltype = [[message attributeForName:@"type"] stringValue];
     NSLog(@"收到消息内容 == %@  发送者 =%@   消息类型 == %@",msg,from,xmltype);
    
    
}
#pragma mark - 获取好友列表














@end
