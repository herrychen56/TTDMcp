//
//  XMPPServer.m
//  BaseProject
//
//  Created by Huan Cho on 13-8-5.
//  Copyright (c) 2013年 ch. All rights reserved.
//

#import "XMPPServer.h"
#import "XMPPPresence.h"
#import "XMPPJID.h"
#import "Statics.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPMessage.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "XMPPHelper.h"
#import "Photo.h"
#import "BCTabBarController.h"
#import "XMPPMessageDeliveryReceipts.h"
#import "UIView+MJAlertView.h" //警告框
//#import "GHConsole.h"
//#import "ZNReceVideView.h"// 视频聊天请求

static XMPPServer *singleton = nil;

@implementation XMPPServer

@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize friendArray;
@synthesize chatDelegate;
@synthesize messageDelegate;


static XMPPServer *sharedServerStatic;
+(XMPPServer*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        sharedServerStatic=[[XMPPServer alloc]init];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [[NSUserDefaults standardUserDefaults]setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:USERID];
        [[NSUserDefaults standardUserDefaults]setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"pass"] forKey:PASS];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [sharedServerStatic setupStream];
    });
    
    // Setup the XMPP stream
    return sharedServerStatic;
}
#pragma mark - singleton
+(XMPPServer *)sharedServer{
    @synchronized(self){
        if (singleton == nil) {
            singleton = [[self alloc] init];
        }
    }
    return singleton;
    
}

+(id)allocWithZone:(NSZone *)zone{
    
    @synchronized(self){
        if (singleton == nil) {
            singleton = [super allocWithZone:zone];
            return singleton;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone{
    return singleton;
}

-(id)retain{
    return singleton;
}

-(oneway void)release{
}

+(id)release{
    return nil;
}

-(id)autorelease{
    return singleton;
}

-(void)dealloc{
    [self teardownStream];
    [super dealloc];
}


#pragma mark - private
-(void)setupStream{

	xmppStream = [[XMPPStream alloc] init];

#if !TARGET_IPHONE_SIMULATOR
	{
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	
	
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];

	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
	
	
	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
	
	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
	// Activate xmpp modules
    
	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
}
#pragma mark -发送在线状态
-(void)getOnline{
    //发送在线状态
    XMPPPresence *presence  = [XMPPPresence presenceWithType:@"available"];
    [xmppStream sendElement:presence];
//    NSLog(@"发送状态=%@    =%@    =%@   %@",[presence type],[presence show],[presence status] ,[presence toStr]);
    
    xmppmuc = [[XMPPMUC alloc]initWithDispatchQueue:dispatch_get_main_queue()];
    [xmppmuc activate:xmppStream];
    [xmppmuc addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //通知tab刷新
     [[NSNotificationCenter defaultCenter] postNotificationName:@"TABRELOAD" object:nil userInfo:nil];
   [MBManager hideAlert];
}

#pragma mark - 获取群列表
- (void)getExistRoom
{
    NSXMLElement *queryElement= [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"];
    NSXMLElement *iqElement = [NSXMLElement elementWithName:@"iq"];
    [iqElement addAttributeWithName:@"type" stringValue:@"get"];
    [iqElement addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USERID]]];
    [iqElement addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"conference.%@",OpenFireHostName]];
    [iqElement addAttributeWithName:@"id" stringValue:@"getMyRooms"];
    [iqElement addChild:queryElement];
    [xmppStream sendElement:iqElement];
}
-(void)getOffline{
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

-(BOOL)connect{
    [self disconnect];
    
    
    
    
    [messageDelegate ServerState:false];
    //[self hiddenShow];
    //[self showLoadingViewWithMessage:@"Connectiong to server..."];
//    [MBManager showLoading];
    [self setupStream];
    //从本地取得用户名，密码和服务器地址
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults stringForKey:USERID];
    NSString *pass = [defaults stringForKey:PASS];
    NSString *server = [defaults stringForKey:SERVER];
    //herry
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    NSLog(@"======从本地取得用户名，密码和服务器地址timeSp:%@",timeSp);
    server = OpenFireUrl;
    password = pass;
    
    if (![self.xmppStream isDisconnected]) {
        return YES;
    }
    if (userId <= 0) {
        return NO;
    }
    //设置用户：user1@chtekimacbook-pro.local格式的用户名
    [xmppStream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@/%@",userId,OpenFireHostName,timeSp] resource:@"IOS"]];
    NSLog(@"=====用户名===%@@   hostname==== %@/   times ==== %@",userId,OpenFireHostName,timeSp);
    //设置服务器
    [xmppStream setHostName:server];
    //连接服务器
    NSError *error = nil;
    //    if ( ![xmppStream connect:&error]) {
    if (![xmppStream connectWithTimeout:10 error:&error]) {//新版本的xmpp
        NSLog(@"cant connect %@", server);
        
        return NO;
    }
    return YES;
}

//改变设备为最高等级
-(void)chuangPriority
{
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addChild:[XMPPElement elementWithName:@"priority" stringValue:@"5"]];
    XMPPElement *show = [XMPPElement elementWithName:@"show"];
    XMPPElement *status = [XMPPElement elementWithName:@"status"];
    //[show setStringValue:@"chat"];
    [presence addChild:show];
//     [status setStringValue:@"在线"];
    [presence addChild:status];
    [self.xmppStream sendElement:presence];
}

//断开服务器连接
-(void)disconnect{
    [self getOffline];
    [xmppStream disconnect];
    NSLog(@"==== 服务器断开连接 ");
   AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    app.isserver = NO;
}
#pragma mark - XMPPStream delegate
//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    isOpen = YES;
    NSError *error = nil;
    //验证密码
    [xmppStream authenticateWithPassword:password error:&error];
    NSLog(@"=======连接服务器======");
     _VideoArray = [[NSMutableArray alloc]init];
    CGRect rectsta = [[UIApplication sharedApplication] statusBarFrame];
    SharedAppDelegate.rectstatus =  [NSString stringWithFormat:@"%g",rectsta.size.height];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Chagerectstatus" object:nil userInfo:nil];
//    NSLog(@"状态栏高度 - %f",  SharedAppDelegate.rectstatus);  // 高度
}

//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    [messageDelegate ServerState:true];
    NSLog(@"=====通过验证=====");
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    app.isserver = YES;
    
     [self getExistRoom];
    //上线
    [self getOnline];
}

/*
 
 名册
 
 <iq xmlns="jabber:client" type="result" to="user2@chtekimacbook-pro.local/80f94d95">
 <query xmlns="jabber:iq:roster">
 <item jid="user6" name="" ask="subscribe" subscription="from"/>
 <item jid="user3@chtekimacbook-pro.local" name="bb" subscription="both">
 <group>好友</group><group>user2的群组1</group>
 </item>
 <item jid="user7" name="" ask="subscribe" subscription="from"/>
 <item jid="user7@chtekimacbook-pro.local" name="" subscription="both">
 <group>好友</group><group>user2的群组1</group>
 </item>
 <item jid="user1" name="" ask="subscribe" subscription="from"/>
 </query>
 </iq>
 */
#pragma mark - 花名册
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
//    NSLog(@"接收到iq消息=== %@\n",iq);
    //NSString *userId = [[sender myJID] user];//当前用户
    self.friendArray =[[NSMutableArray alloc] init];
    //NSLog(@"didReceiveIQ--iq is:%@",iq.XMLString);
    if ([@"result" isEqualToString:iq.type]) {
        NSXMLElement *query = iq.childElement;
        if ([@"query" isEqualToString:query.name]) {
            NSArray *items = [query children];
            for (NSXMLElement *item in items) {
                //订阅签署状态  sub== both
                NSString *subscription = [item attributeStringValueForName:@"subscription"];
                
                if ([subscription isEqualToString:@"both"]) {
                    NSString *jid = [item attributeStringValueForName:@"jid"];
                    NSString *name = [item attributeStringValueForName:@"name"];
                    XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
                    //UserList
                    NSArray *jidstrs=[jid componentsSeparatedByString:@"@"];
                    UIImage *_photo = [XMPPHelper xmppUserPhotoForJID:xmppJID];
                    
                    WCUserObject *wcuser=[[WCUserObject alloc]init];
                    [wcuser setUserId:jidstrs[0]];
                    [wcuser setUserNickname:name];
                    
                    [wcuser setFriendFlag:0];
                    [wcuser setUserDescription:nil];
                    [wcuser setUsername:[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
                    
                    //头像
                    if(_photo==nil)
                    {
                        [wcuser setUserHead:nil];
                    }else
                    {
                        NSString *photoBata64=[Photo image2String:_photo];
                        [wcuser setUserHead:photoBata64];
                    }
                    //群组：
                    NSArray *groups = [item elementsForName:@"group"];
                    for (NSXMLElement *groupElement in groups) {
                        NSString *groupName = groupElement.stringValue;
                        //                        NSLog(@"didReceiveIQ----xmppJID:%@ , in group:%@",jid,groupName);
                        //  [[XMPPServer xmppRoster] addUser:xmppJID withNickname:@""];
                        [wcuser setGroup:groupName];
                    }
                    
                    if([WCUserObject haveSaveUserById:jidstrs[0] userName:[[NSUserDefaults standardUserDefaults] stringForKey:USERID]])
                    {
                        [WCUserObject updateUser:wcuser];
                    }else
                    {
                        [WCUserObject saveNewUser:wcuser];
                    }

                    [self.friendArray addObject:[NSString stringWithFormat:@"%@",xmppJID]];

                }
                
                else if ([subscription isEqualToString:@"from"]){
                    
                }
                
                else if ([subscription isEqualToString:@"to"]){
                    
                }
               
                
                
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"user" object:nil userInfo:[NSDictionary dictionaryWithObject:self.friendArray forKey:@"userlist"]];
            
            [WCUserObject deleteUserById:self.friendArray userName:[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
            //[chatDelegate rosterLiset:[WCUserObject fetchAllFromUsername:SharedAppDelegate.username]];//用户列表委托
            [self AllUserPhotoSet:self.friendArray];//Update Photo
            [chatDelegate reloadDataList];//重新加在用户列表
        }
    }
    
    [self chuangPriority];
    
    WCUserObject *wcuser=[[WCUserObject alloc]init];
    
    NSString *elementID = iq.elementID;
    NSArray *results = [iq elementsForXmlns:@"http://jabber.org/protocol/disco#items"];
    if (results.count < 1) {
        return YES;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (DDXMLElement *element in iq.children) {
        if ([element.name isEqualToString:@"query"]) {
            for (DDXMLElement *item in element.children) {
                if ([item.name isEqualToString:@"item"]) {
                    [array addObject:item];
                    NSLog(@"群列表==%@",array);
                    
                    
                    
                    NSString *jid = [item attributeStringValueForName:@"jid"];
//                    NSString *name = [item attributeStringValueForName:@"name"];
                    XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
                    
                    [wcuser setGroup:@"Group Chat"];// 群聊分类
                   
                    [wcuser setUserId:[item attributeStringValueForName:@"name"]];
                    [wcuser setFriendFlag:0];
                    [wcuser setUserDescription:nil];
                    [wcuser setUserHead:nil];
                     [wcuser setUsername:[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
                    [wcuser setUserNickname:[item attributeStringValueForName:@"name"]];// 群聊名称
                   [WCUserObject saveNewUser:wcuser];
                     [self.friendArray addObject:[NSString stringWithFormat:@"%@",xmppJID]];
                }
            }
        }
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"user" object:nil userInfo:[NSDictionary dictionaryWithObject:self.friendArray forKey:@"userlist"]];
////
//    [WCUserObject deleteUserById:self.friendArray userName:[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
//    //[chatDelegate rosterLiset:[WCUserObject fetchAllFromUsername:SharedAppDelegate.username]];//用户列表委托
//    [self AllUserPhotoSet:self.friendArray];//Update Photo
    [chatDelegate reloadDataList];//重新加在用户列表
    
    return YES;
}
#pragma  mark ------收发消息-------
- (void)sendMessage:(WCMessageObject *)messageObject
{
    NSLog(@"========收发消息========");
    //创建message对象
    WCMessageObject *msg=[[WCMessageObject alloc]init];
    [msg setMessageDate:[NSDate date]];
    NSArray *strs=[messageObject.messageTo componentsSeparatedByString:@"@"];
    [msg setMessageFrom:messageObject.messageFrom];
    [msg setMessageTo:strs[0]];
    [msg setUsername:[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
    [msg setMessagesendType:messageObject.messagesendType];
    [msg setMessageState:messageObject.messageState]; //Wei Du
    //判断多媒体消息
    if (messageObject.messageContent.length>4&&[[messageObject.messageContent substringToIndex:4]isEqualToString:@"[/1]"])
    {
        [msg setMessageType:[NSNumber numberWithInt:kWCMessageTypeImage]];
        messageObject.messageContent=[messageObject.messageContent substringFromIndex:4];
    }
    //判断是否为发送语音
    else if (messageObject.messageContent.length>4&&[[messageObject.messageContent substringToIndex:4]isEqualToString:@"[/2]"]) {
        
        [msg setMessageaudioTimes:@"18"];
        [msg setMessageType:[NSNumber numberWithInt:kWCMessageTypeVoice]];
        messageObject.messageContent=[messageObject.messageContent substringFromIndex:4];
        
    }
    else if (messageObject.messageContent.length>4&&[[messageObject.messageContent substringToIndex:4]isEqualToString:@"[/3]"])
    {
        [msg setMessageType:[NSNumber numberWithInt:kWCMessageTypeFace]];
        messageObject.messageContent=[messageObject.messageContent substringFromIndex:4];
        //将表情值换成对应的表情图片名称存入数据库
        NSDictionary  *_faceMap = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"faceMap_en" ofType:@"plist"]]retain];
        NSArray *arry=[_faceMap allKeysForObject: messageObject.messageContent];
        if(arry.count>0)
        {
            NSString *facename=[arry objectAtIndex:0];
            messageObject.messageContent=facename;
        }
        else
        {
            [msg setMessageType:[NSNumber numberWithInt:kWCMessageTypePlain]];
            
        }
        // NSString *str=[_faceMap objectForKey:[NSString stringWithFormat:@"%03d",i]];
    }
    
    else
    {
        [msg setMessageType:[NSNumber numberWithInt:kWCMessageTypePlain]];
    }
    [msg setMessageaudioTimes:@"0"];
    [msg setMessageContent:messageObject.messageContent];
    [WCMessageObject save:msg];
    [chatDelegate messageContentNotice];
    //发送全局通知
    //    [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPNewMsgNotifaction object:msg ];
    //    [msg release];
}
-(NSString *)documentDirectory
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
//获取当前时间作为声音文件名
- (NSString*)getCurrentTimeString
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [dateformat stringFromDate:[NSDate date]];
}
#pragma mark -时间大小对比
-(int)compareDate:(NSString*)startDate withDate:(NSString*)endDate{
    
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startDate];
    date2 = [formatter dateFromString:endDate];
    NSComparisonResult result = [date1 compare:date2];
    NSLog(@"result==%ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            comparisonResult = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            comparisonResult = -1;
            break;
            //date02=date01
        case NSOrderedSame:
            comparisonResult = 0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    return comparisonResult;
}

/*
 收到消息
 
 <message
 to='romeo@example.net'
 from='juliet@example.com/balcony'
 type='chat'
 xml:lang='en'>
 <body>Wherefore art thou, Romeo?</body>
 </message>
 
 */
#pragma mark - 收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
   
   
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *xmltype = [[message attributeForName:@"type"] stringValue];
    
    NSArray * fromname = [from componentsSeparatedByString:@"@"];
    
     NSLog(@"收到消息=====%@   from ===%@    xmltype===%@",msg,from,xmltype);
    //[/9]2018-01-02 23:53:40*sendVideo//amymeng1514908420955.817871//14045@test-u-1.thinktank.com
    
   if (msg.length>4&&[[msg substringToIndex:4]isEqualToString:@"[/9]"])
    {
      
        NSArray * strss=[msg componentsSeparatedByString:@"]"];
        NSLog(@"拆分后视频数据===%@",strss[1]);//2018-01-02 23:53:40*sendVideo//
        NSString * sendvidstr=[NSString stringWithFormat:@"%@",strss[1]];
        NSArray * videobody = [sendvidstr componentsSeparatedByString:@"*"];
        //视频消息发送时间
        NSString * sendVideoTime = [NSString stringWithFormat:@"%@",videobody[0]];//拆分时间
        NSString * sendVideomessage = [NSString stringWithFormat:@"%@",videobody[1]];//拆分内容
        //二次拆分
        NSArray * twosendvideo = [sendVideomessage componentsSeparatedByString:@"//"];
        NSLog(@"接收消息拆分==%@",twosendvideo);
        /*
         (
         sendVideo, 请求内容
         "amymeng1514908420955.817871", 唯一消息吗
         "14045@test-u-1.thinktank.com" // 参会人数
         )
         */
        NSString * listdic =[[NSString alloc]init];
        if (twosendvideo.count>=2) {
            listdic = twosendvideo[2];
        }else{
            
        }
       
        NSLog(@"listdic==%@",listdic);
         NSArray * otherarr = [listdic componentsSeparatedByString:@"||"];
        NSString * twomessage = [NSString stringWithFormat:@"%@",twosendvideo[0]];
        NSString * twonumber=[[NSString alloc]init];
        if (twosendvideo.count>1) {
            twonumber = twosendvideo[1];
        }else{
            twonumber =@"1";
        }
        
        NSLog(@"视频请求时间=%@ 内容=%@",sendVideoTime,sendVideomessage);//sendVideo//amymeng1514908420955.817871//14045@test-u-1.thinktank.com
        NSDictionary * dic =@{@"name":from,@"number":twonumber};
        AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
        //app时间
        NSString * apptime=[NSString stringWithFormat:@"%@",app.datatimeStr];
        NSLog(@"app time = %@  视频状态=%@",apptime,app.isvideochat);
        int tt = [self compareDate:sendVideoTime withDate:apptime];
        // 1  app  >发送时间   -1 app < 发送时间    0 app = 发送时间
        NSLog(@"时间对比结果 =%d",tt);
        //new通知参数
        NSDictionary * dict =[[NSDictionary alloc]init];
        if (twosendvideo.count>1) {
          dict= @{@"name":from,@"number":otherarr,@"reqname":twomessage,@"VsessionID":[NSString stringWithFormat:@"%@",twosendvideo[1]]};
        }else{
          dict =@{@"name":from,@"number":otherarr,@"reqname":twomessage,@"VsessionID":[NSString stringWithFormat:@"%@",twosendvideo[0]]};
        }
        
        
        
        
        
        if ([twomessage isEqualToString:@"receVideo"]) {
            //拒绝
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Theotherpartyrefusesto" object:nil];
        }else if ([twomessage isEqualToString:@"delVideo"]){//挂断视频
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HangupVideoChat" object:nil];;
        }
        else if ([twomessage isEqualToString:@"sendVideo"]) {
            //请求
            if (tt <= 0) {
                 AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
                NSLog(@"对比时间通过 判断是否视频中=%@",app.isvideo ? @"YES":@"NO");
                if (app.isvideo ==NO) {
                    //没开视频
                    SharedAppDelegate.myVideoRoom =[NSString stringWithFormat:@"%@",twosendvideo[1]];
                    [SharedAppDelegate.otherPersonArr addObjectsFromArray: otherarr];
                   
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"VideoChatRequest" object:nil userInfo: dict];//弹出邀请框通知
                }else{
                    //开视频中
                    if ([SharedAppDelegate.myVideoRoom isEqualToString:[NSString stringWithFormat:@"%@",twosendvideo[1]]]) {
                        SharedAppDelegate.otherPersonArr = [[NSMutableArray alloc]init];
                        SharedAppDelegate.otherPersonArr =[NSMutableArray arrayWithArray:otherarr];
                        //发送更新页面通知
//                        [[NSNotificationCenter defaultCenter]postNotificationName:@"chageUI" object:nil userInfo:dict];
                    }else{//roomid 不相同，提示对方用户正忙
                          [[NSNotificationCenter defaultCenter]postNotificationName:@"otheris busy" object:nil userInfo: dict];//对方忙通知
                    }
                }
            }
        }else if ([twomessage isEqualToString:@"chatVideoUI"]){
            //请求
            if (tt <= 0) {
                AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
                NSLog(@"对比时间通过 判断是否视频中=%@",app.isvideo ? @"YES":@"NO");
                if (app.isvideo ==NO) {
                    //没开视频
                    SharedAppDelegate.myVideoRoom =[NSString stringWithFormat:@"%@",twosendvideo[1]];
                    [SharedAppDelegate.otherPersonArr addObjectsFromArray: otherarr];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"VideoChatRequest" object:nil userInfo: dict];//弹出邀请框通知
                }else{
                    //开视频中
                    if ([SharedAppDelegate.myVideoRoom isEqualToString:[NSString stringWithFormat:@"%@",twosendvideo[1]]]) {
                        SharedAppDelegate.otherPersonArr = [[NSMutableArray alloc]init];
                        SharedAppDelegate.otherPersonArr =[NSMutableArray arrayWithArray:otherarr];
                        SharedAppDelegate.myVideoRoom =[NSString stringWithFormat:@"%@",twosendvideo[1]];
                        //发送更新页面通知
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"chageUI" object:nil userInfo:dict];
                    }else{//roomid 不相同，提示对方用户正忙
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"otheris busy" object:nil userInfo: dict];//对方忙通知
                    }
                }
            }
        }else if ([twomessage isEqualToString:@"newchatVideoUI"]){
            //请求
            if (tt <= 0) {
                AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
                NSLog(@"对比时间通过 判断是否视频中=%@",app.isvideo ? @"YES":@"NO");
                if (app.isvideo ==NO) {
                    //没开视频
                    SharedAppDelegate.myVideoRoom =[NSString stringWithFormat:@"%@",twosendvideo[1]];
                    [SharedAppDelegate.otherPersonArr addObjectsFromArray: otherarr];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"VideoChatRequest" object:nil userInfo: dict];//弹出邀请框通知
                }else{
                    //开视频中
                    if ([SharedAppDelegate.myVideoRoom isEqualToString:[NSString stringWithFormat:@"%@",twosendvideo[1]]]) {
                        SharedAppDelegate.otherPersonArr = [[NSMutableArray alloc]init];
                        SharedAppDelegate.otherPersonArr =[NSMutableArray arrayWithArray:otherarr];
                        //发送更新页面通知
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"chageUI" object:nil userInfo:dict];
                    }else{//roomid 不相同，提示对方用户正忙
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"otheris busy" object:nil userInfo: dict];//对方忙通知
                    }
                }
            }
        }

        else if ([twomessage isEqualToString:@"twopersonvideo"]){
        
            if (tt <= 0) {
                AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
                NSLog(@"对比时间通过 判断是否视频中=%@",app.isvideo ? @"YES":@"NO");
                if (app.isvideo ==NO) {
                    //没开视频
                    SharedAppDelegate.myVideoRoom =[NSString stringWithFormat:@"%@",twosendvideo[1]];
                    [SharedAppDelegate.otherPersonArr addObjectsFromArray: otherarr];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"VideoChatRequest" object:nil userInfo: dict];//弹出邀请框通知
                }else{
                    //开视频中
                    if ([SharedAppDelegate.myVideoRoom isEqualToString:[NSString stringWithFormat:@"%@",twosendvideo[1]]]) {
                        SharedAppDelegate.otherPersonArr = [[NSMutableArray alloc]init];
                        SharedAppDelegate.otherPersonArr =[NSMutableArray arrayWithArray:otherarr];
                        //发送更新页面通知
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"chageUI" object:nil userInfo:dict];
                    }else{//roomid 不相同，提示对方用户正忙
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"otheris busy" object:nil userInfo: dict];//对方忙通知
                    }
                }
            }
            
            
        
        }else if ([twomessage isEqualToString:@"multiplesendVideo"]){
            if (tt <= 0) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"multipleVideoChatRequest" object:nil userInfo: dic];
            }
        }
    }else{
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ReceiveMessage" object:nil];
        
        if([xmltype isEqualToString:@"chat"]&&msg!=nil)
        {
            //判断是否有铃声
            NSString* isvoice=[[NSUserDefaults standardUserDefaults] objectForKey:CHAT_VOICE];
            if(isvoice==nil||[isvoice isEqualToString:@"YES"])
            {
                static SystemSoundID soundIDTest = 0;
                NSString * path = [[NSBundle mainBundle] pathForResource:@"sms-received1" ofType:@"caf"];
                if (path) {
                    AudioServicesCreateSystemSoundID( (CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest );
                }
                
                AudioServicesPlaySystemSound(soundIDTest);
            }
            //判断是否是震动
            NSString* isVibrations=[[NSUserDefaults standardUserDefaults] objectForKey:CHAT_VIBRATIONS];
            if(isVibrations==nil||[isVibrations isEqualToString:@"OK"])
            {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            //herry添加
            //判断多媒体消息
            int type=0;//用于保存内容类型
            
            if (msg.length>4&&[[msg substringToIndex:4]isEqualToString:@"[/1]"])
            {
                type=kWCMessageTypeImage;
                msg=[msg substringFromIndex:4];
            }
            //判断是否为发送语音
            else if (msg.length>4&&[[msg substringToIndex:4]isEqualToString:@"[/2]"])
            {
                type=kWCMessageTypeVoice;
                msg=[msg substringFromIndex:4];
            }
            else if(msg.length>4&&[[msg substringToIndex:4]isEqualToString:@"[/3]"])
            {
                type=kWCMessageTypeFace;
                msg=[msg substringFromIndex:4];
                //将表情值换成对应的表情图片名称存入数据库
                NSDictionary  *_faceMap = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"faceMap_en" ofType:@"plist"]]retain];
                NSArray *arry=[_faceMap allKeysForObject: msg];
                if(arry.count>0)
                {
                    NSString *facename=[arry objectAtIndex:0];
                    msg=facename;
                }
                else
                {
                    type=kWCMessageTypePlain;
                }
            }
         
            //创建message对象 保存纪录 andy
            WCMessageObject *msges=[WCMessageObject messageWithType:type];
            NSArray *strs=[from componentsSeparatedByString:@"@"];
            [msges setMessageDate:[NSDate date]];
            [msges setMessageFrom:strs[0]];
            [msges setMessageContent:msg];
            [msges setMessageTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]];
            //[msges setMessageType:[NSNumber numberWithInt:kWCMessageTypePlain]];
            [msges setMessageType:[NSNumber numberWithInt:type]];
            [msges setUsername:[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
            [msges setMessageState:@"1"];
//            [msges setMessageaudioTimes:@1];
            [WCMessageObject save:msges];
            //NSLog(@"mag is :%@",msg);
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (msg !=nil) {
                [dict setObject:msg forKey:@"msg"];
                [dict setObject:from forKey:@"sender"];
                //消息接收到的时间
                [dict setObject:[Statics getCurrentTime] forKey:@"time"];
                //消息委托
                [messageDelegate newMessageReceived:dict];
                NSLog(@"=========收到来自%@消息：%@",from,msg);
                [chatDelegate messageContentNotice];
            }
            [UIApplication sharedApplication].applicationIconBadgeNumber=badgecount;
        }
    }
}
-(NSString*)saveAttachment:(NSString *)http :(NSString *)fileName
{
    NSURL    *url = [NSURL URLWithString:http];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:nil
                                                       error:&error];
    
    
    NSString *path=@"error";
    /* 下载的数据 */
    if (data != nil){
        NSLog(@"============下载数据成功");

        NSString *attachmentDir = [NSString stringWithFormat:@"%@/Attachment", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]];
        
        BOOL isDir = NO;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL existed = [fileManager fileExistsAtPath:attachmentDir isDirectory:&isDir];
        
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:attachmentDir withIntermediateDirectories:YES attributes:nil error:nil];
        }

        path=[attachmentDir stringByAppendingPathComponent:fileName];
        BOOL issucess=[data writeToFile:path atomically:YES];
        
        // NSString*attach=[fileName substringFromIndex:fileName.length-4];
        if (issucess) {
            
            if([[fileName substringFromIndex:fileName.length-4]isEqualToString:@".txt"])
            {
                NSStringEncoding *useencoding=nil;
                NSString *body=[NSString stringWithContentsOfFile:path usedEncoding:useencoding error:nil];
                
                if(!body)
                {
                    body=[NSString stringWithContentsOfFile:path encoding:0x80000632 error:nil];
                }
                if(!body)
                    
                {
                    body=[NSString stringWithContentsOfFile:path encoding:0x80000632 error:nil];
                    
                }
                issucess= [body writeToFile:path atomically:YES encoding:NSUTF16StringEncoding error:nil];
            }
        }
        
        if (issucess) {
            NSLog(@"保存成功.");
        }
        else
        {
            path=@"error";
            NSLog(@"保存失败.");
        }
    } else {
        NSLog(@"754error==%@", error);
    }
    
    return path;
}
/*
 
 收到好友状态
 <presence xmlns="jabber:client"
 from="user3@chtekimacbook-pro.local/ch&#x7684;MacBook Pro"
 to="user2@chtekimacbook-pro.local/7b55e6b">
 <priority>0</priority>
 <c xmlns="http://jabber.org/protocol/caps" node="http://www.apple.com/ichat/caps" ver="900" ext="ice recauth rdserver maudio audio rdclient mvideo auxvideo rdmuxing avcap avavail video"/>
 <x xmlns="http://jabber.org/protocol/tune"/>
 <x xmlns="vcard-temp:x:update">
 <photo>E10C520E5AE956E659A0DBC5C7F48E12DF9BE6EB</photo>
 </x>
 </presence>
 */
#pragma mark -取得好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    


    NSString *presenceType = [presence type]; //取得好友状态

    NSString *userId = [[sender myJID] user];//当前用户

    NSString *presenceFromUser = [[presence from] user];//在线用户
//    NSLog(@"=======获取好友状态 :%@, 当前用户:%@ show=%@  status=%@",[presence type],presenceFromUser,[presence show],[presence status]);

    if (![presenceFromUser isEqualToString:userId]) {
        //对收到的用户的在线状态的判断在线状态

        //在线用户
        if ([presenceType isEqualToString:@"anvilable"]) {
            NSString *buddy = [[NSString stringWithFormat:@"%@@%@", presenceFromUser, OpenFireHostName] retain];
            [chatDelegate newBuddyOnline:buddy];//用户列表委托
//            AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
//            [app.availbleArr addObject:presenceFromUser];
        }

        //用户下线
        else if ([presenceType isEqualToString:@"unavailable"]) {
            [chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, OpenFireHostName]];//用户列表委托
        }

        //这里再次加好友:如果请求的用户返回的是同意添加01
        else if ([presenceType isEqualToString:@"subscribed"]) {
            XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@",[presence from]]];
            [[XMPPServer xmppRoster] acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
            NSLog(@"======这里再次加好友:如果请求的用户返回的是同意添加01");
        }

        //用户拒绝添加好友
        else if ([presenceType isEqualToString:@"unsubscribed"]) {
            //TODO
            NSLog(@"=====用户拒绝添加好友");
        }
    }
}

#pragma mark - XMPPRoster delegate
/**
 *
 *  好友添加请求
 */
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    //好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]];
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    
    NSLog(@"======好友添加请求t----状态:%@,用户：%@,presence:%@",presenceType,presenceFromUser,presence);
    
    
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
    [[XMPPServer xmppRoster]  acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    
    /*
     user1向登录账号user2请求加为好友：
     
     presenceType:subscribe
     presence2:<presence xmlns="jabber:client" to="user2@chtekimacbook-pro.local" type="subscribe" from="user1@chtekimacbook-pro.local"/>
     sender2:<XMPPRoster: 0x7c41450>
     
     登录账号user2发起user1好友请求，user5
     presenceType:subscribe
     presence2:<presence xmlns="jabber:client" type="subscribe" to="user2@chtekimacbook-pro.local" from="user1@chtekimacbook-pro.local"/>
     sender2:<XMPPRoster: 0x14ad2fb0>
     */
}

/**
 * Sent when a Roster Push is received as specified in Section 2.1.6 of RFC 6121.
 *
 * 添加好友、好友确认、删除好友
 
 //请求添加user6@chtekimacbook-pro.local 为好友
 <iq xmlns="jabber:client" type="set" id="880-334" to="user2@chtekimacbook-pro.local/f3e9c656">
 <query xmlns="jabber:iq:roster">
 <item jid="user6@chtekimacbook-pro.local" ask="subscribe" subscription="none"/>
 </query>
 </iq>
 
 //用户6确认后：
 <iq xmlns="jabber:client" type="set" id="880-334" to="user2@chtekimacbook-pro.local/662d302c"><query xmlns="jabber:iq:roster"><item jid="user6@chtekimacbook-pro.local" ask="subscribe" subscription="none"/></query></iq>
 
 //删除用户6：？？？
 <iq xmlns="jabber:client" type="set" id="592-372" to="user2@chtekimacbook-pro.local/c8f2ab68"><query xmlns="jabber:iq:roster"><item jid="user6@chtekimacbook-pro.local" ask="unsubscribe" subscription="from"/></query></iq>
 
 <iq xmlns="jabber:client" type="set" id="954-374" to="user2@chtekimacbook-pro.local/c8f2ab68"><query xmlns="jabber:iq:roster"><item jid="user6@chtekimacbook-pro.local" ask="unsubscribe" subscription="none"/></query></iq>
 
 <iq xmlns="jabber:client" type="set" id="965-376" to="user2@chtekimacbook-pro.local/e799ef0c"><query xmlns="jabber:iq:roster"><item jid="user6@chtekimacbook-pro.local" subscription="remove"/></query></iq>
 */
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq{
    
//    NSLog(@"didReceiveRosterPush:(XMPPIQ *)iq is :%@",iq.XMLString);
}

/**
 * Sent when the initial roster is received.
 * 在收到最初的花名册时发出。
 */
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender{
//    NSLog(@"xmppRosterDidBeginPopulating");
}

/**
 * Sent when the initial roster has been populated into storage.
 *  当最初的花名册被填入存储器时发送。
 */
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender{
//    NSLog(@"xmppRosterDidEndPopulating");
}

/**
 * Sent when the roster recieves a roster item.
 *
 * Example:
 *
 * <item jid='romeo@example.net' name='Romeo' subscription='both'>
 *   <group>Friends</group>
 * </item>
 *
 */
- (void)xmppRoster:(XMPPRoster *)sender didRecieveRosterItem:(NSXMLElement *)item{
    
//        NSString *jid = [item attributeStringValueForName:@"jid"];
//        NSString *name = [item attributeStringValueForName:@"name"];
//        NSString *subscription = [item attributeStringValueForName:@"subscription"];
//
//        DDXMLNode *node = [item childAtIndex:0];
//
//        NSXMLElement *groupElement = [item elementForName:@"group"];
//        NSString *group = [groupElement attributeStringValueForName:@"group"];
//
//        NSLog(@"=====didRecieveRosterItem:  jid=%@,name=%@,subscription=%@,group=%@",jid,name,subscription,group);
    
}
-(void)AllUserPhotoSet:(NSMutableArray *)UserArray
{
    for (int i=0;i<UserArray.count;i++)
    {
        NSRange range=[[UserArray objectAtIndex:i] rangeOfString:@"@"];
        NSString *UserArrayName=[[UserArray objectAtIndex:i] substringToIndex:range.location];
        NSURL *url = [NSURL URLWithString:SERVER_URL];
        AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                UserArrayName, @"username",
                                nil];
        //NSLog(@"UserPhotoSet-studentname - %@",UserArrayName);
        NSMutableURLRequest *request = [client requestWithFunction:FUNC_USERPHOTO parameters:params];
        AFKissXMLRequestOperation *operation =
        [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
         {
             UserPhoto* res = [UserPhoto UserPhotoWithDDXMLDocument:XMLDocument];
             NSString *aStr=res.photo;
             if(aStr.length>0)
             {
                 WCUserObject *UserObject=[[WCUserObject alloc] init];
                 UserObject.userId=UserArrayName;
                 UserObject.username=SharedAppDelegate.username;
                 [WCUserObject updateUserHead:UserObject userHead:res.photo];
             }
             
         }
                                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
         {
             
             NSLog(@"error:%@", error);
             //[self showAlertWithTitle:nil andMessage:@"No Network"];
         }];
        [operation start];
    }
    
    
}



#pragma mark - 创建房间
-(void)CreateRoomWithRoomName:(NSString *)roomname WithPerson:(NSArray *)personarr {
    
    XMPPRoomCoreDataStorage *rosterstorage = [XMPPRoomCoreDataStorage sharedInstance];
    _room = [[XMPPRoom alloc] initWithRoomStorage:SharedAppDelegate.rosterstorage jid:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@conference.%@",roomname,OpenFireHostName]] dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
    [rosterstorage release];
    [_room activate:xmppStream];
    [_room joinRoomUsingNickname:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]] history:nil];
    [_room configureRoomUsingOptions:nil];
    [_room addDelegate:self delegateQueue:dispatch_queue_create("com.ttd.roomqueue", NULL)];
//    [room fetchConfigurationForm];
    
    _groupArr = [[NSMutableArray alloc]init];
    
    _groupArr= [personarr mutableCopy];
    [_groupArr removeLastObject];
   
   
}

//创建结果
-(void)xmppRoomDidCreate:(XMPPRoom *)sender{

    NSLog(@"房间创建结果=== %@", sender.roomSubject);
    [sender fetchConfigurationForm];
}
-(void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(DDXMLElement *)configForm {
    NSLog(@"nnnnnnnnn");
    NSXMLElement * x =[NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    NSXMLElement * p;
    
    p = [NSXMLElement elementWithName:@"field"];
    [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_persistentroom"];//永久房间
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var"stringValue:@"muc#roomconfig_maxusers"];//最大用户
    [p addChild:[NSXMLElement elementWithName:@"value"stringValue:@"50"]];
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var"stringValue:@"muc#roomconfig_changesubject"];//允许改变主题
    [p addChild:[NSXMLElement elementWithName:@"value"stringValue:@"1"]];
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field"];
    [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_publicroom"];       // 公共房间
    [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"0"]];
    [x addChild:p];
    
//    p = [NSXMLElement elementWithName:@"field" ];
//    [p addAttributeWithName:@"var"stringValue:@"muc#roomconfig_publicroom"];//公共房间
//    [p addChild:[NSXMLElement elementWithName:@"value"stringValue:@"1"]];
//    [x addChild:p];
    
//    p = [NSXMLElement elementWithName:@"field"];
//    [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_enablelogging"];     // 允许登录房间对话
//    [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
//    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var"stringValue:@"muc#roomconfig_allowinvites"];//允许邀请
    [p addChild:[NSXMLElement elementWithName:@"value"stringValue:@"1"]];
    [x addChild:p];
    NSLog(@"x===%@",x);
    [sender configureRoomUsingOptions:x];

     NSLog(@"邀请人员：%@  %@   %@  ==%@ ===%@",_groupArr,sender.moduleName,sender.myNickname,sender.roomJID,sender.roomJID.resource);
   
    
    for (int i=0; i<_groupArr.count; i++) {
        NSString * perjid = [NSString stringWithFormat:@"%@",_groupArr[i]];
        NSXMLElement *queryElement= [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/muc#admin"];
        NSXMLElement *iqElement = [NSXMLElement elementWithName:@"iq"];
        [iqElement addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@/testonename",perjid]];
        [iqElement addAttributeWithName:@"id" stringValue:@"admin1"];
        [iqElement addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@",sender.roomJID]];
        [iqElement addAttributeWithName:@"type" stringValue:@"set"];
        
        NSXMLElement *xs = [NSXMLElement elementWithName:@"item"];
        [xs addAttributeWithName:@"affiliation" stringValue:@"admin"];
        [xs addAttributeWithName:@"jid" stringValue:[NSString stringWithFormat:@"%@",perjid]];
        [xs addAttributeWithName:@"role" stringValue:@"moderator"];
        
        [queryElement addChild:xs];
        [iqElement addChild:queryElement];
        
        NSLog(@"ip == %@\n",iqElement);
        
        [[XMPPServer xmppStream] sendElement:iqElement];
    }

}
//是否已经加入房间
-(void)xmppRoomDidJoin:(XMPPRoom *)sender{
    NSLog(@"加入房间成功xmppRoomDidJoin%@===  ==%@",sender.roomSubject,sender.myNickname);
  
    
    NSString * namestr = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSXMLElement * body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:[NSString stringWithFormat:@"%@ 用户进入房间",namestr]] ;
    NSXMLElement * mes = [NSXMLElement elementWithName:@"message"];

    [mes addAttributeWithName:@"type" stringValue:@"groupchat"];
    [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@",sender.roomJID.user,sender.roomJID.domain]];
    [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    [mes addAttributeWithName:@"sendType" stringValue:@"0"];
    [mes addAttributeWithName:@"audiotimes" stringValue:@"0"];
    NSString * siID = [XMPPStream generateUUID];
    [mes addAttributeWithName:@"id" stringValue:siID];

    [mes addChild:body];
    NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [mes addChild:received];

    [[XMPPServer xmppStream] sendElement:mes];
    
    
    [self getuserqx:sender];
}

-(void)getuserqx:(XMPPRoom *)sender {

    
    
}

// 收到禁止名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items{
    NSLog(@"收到聊天室禁止名单列表：%@",items);
}
// 收到好友名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items{
     NSLog(@"收到聊天室好友名单列表：%@",items);
}
// 收到主持人名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items{
     NSLog(@"收到聊天室主持人名单列表：%@",items);
}



//是否已经离开
-(void)xmppRoomDidLeave:(XMPPRoom *)sender{
    NSLog(@"是否已经离开xmppRoomDidLeave");
}
//新人加入群聊
- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID
{
    NSLog(@"新人加入群聊%@: %@", THIS_FILE, THIS_METHOD);
}
//有人退出群聊
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID
{
    NSLog(@"有人退出群聊%@: %@", THIS_FILE, THIS_METHOD);
}
//有人在群里发言
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
    NSLog(@"有人在群里发言：%@  ：%@: %@", message,THIS_FILE, THIS_METHOD);
}
#pragma mark - XMPPMUC DELE
- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitation:(XMPPMessage *)message{
    //收到邀请
    NSLog(@"接收到MUC邀请 内容：%@",message);
    XMPPRoomCoreDataStorage *rosterstorage = [[XMPPRoomCoreDataStorage alloc] init];
    _room = [[XMPPRoom alloc] initWithRoomStorage:rosterstorage jid: roomJID dispatchQueue:dispatch_queue_create("com.ttd.roomqueue", NULL)];
    [rosterstorage release];
    [_room activate:xmppStream];
   
    [_room joinRoomUsingNickname:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]] history:nil];

    [_room addDelegate:self delegateQueue:dispatch_queue_create("com.ttd.roomqueue", NULL)];
    
}

- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitationDecline:(XMPPMessage *)message{
    //收到邀请被拒绝的结果
    NSLog(@"接收到MUC邀请被拒绝的结果 内容：%@",message);
}
- (void)xmppMUC:(XMPPMUC *)sender didDiscoverServices:(NSArray *)services{
    //获取到了服务器列表
    NSLog(@"获取到了服务器列表ServicesListSize:%d",services.count);
//    for (DDXMLElement* element in services) {
//        NSString* name = [element attributeStringValueForName:@"name"];
//        NSString* jid = [element attributeStringValueForName:@"jid"];
//        DLog(@"name:%@,jid:%@",name,jid);
//        [xmppmuc discoverRoomsForServiceNamed:jid];
//    }
}
- (void)xmppMUC:(XMPPMUC *)sender didDiscoverRooms:(NSArray *)rooms forServiceNamed:(NSString *)serviceName{
    //获取到服务器聊天房间列表
    NSLog(@"获取到服务器聊天房间列表RoomListSize:%d",rooms.count);
//    _roomsOnServer = rooms;
}
@end
