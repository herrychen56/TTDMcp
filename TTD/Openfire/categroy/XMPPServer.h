//
//  XMPPServer.h
//  BaseProject
//
//  Created by Huan Cho on 13-8-5.
//  Copyright (c) 2013年 ch. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "KKChatDelegate.h"
#import "KKMessageDelegate.h"
#import "WCMessageObject.h"
#import "VoiceConverter.h"
#import "ChatVoiceRecorderVC.h"
#import "BaseViewController.h"
@protocol XMPPServerDelegate <NSObject>

-(void)setupStream;
-(void)getOnline;
-(void)getOffline;

@end

@interface XMPPServer : NSObject<XMPPRoomDelegate,XMPPServerDelegate,XMPPRosterDelegate,VoiceRecorderBaseVCDelegate,XMPPMUCDelegate>{
    XMPPStream *xmppStream;
    
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
    
    XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    int badgecount;
    NSString *password;
    BOOL isOpen;
    
    XMPPMUC * xmppmuc;
//    XMPPRoom *room ;
}
@property (nonatomic,retain,strong)  XMPPRoom *room ;

@property (nonatomic, retain, readonly) XMPPStream *xmppStream;
@property (nonatomic, retain, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, retain, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, retain, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, retain, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, retain, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, retain, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, retain, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic,strong) NSMutableArray *friendArray;
@property (nonatomic, retain)  id<KKChatDelegate>       chatDelegate;
@property (nonatomic, retain)  id<KKMessageDelegate>    messageDelegate;
@property (nonatomic,strong) NSMutableArray * VideoArray;
@property (nonatomic,strong) NSMutableArray * groupArr;

+(XMPPServer *)sharedServer;

-(void)getExistRoom;

-(BOOL)connect;

-(void)disconnect;
-(void)sendMessage:(WCMessageObject *)aMessage;
-(void)AllUserPhotoSet:(NSMutableArray *)UserArray;

-(void)CreateRoomWithRoomName:(NSString *)roomname WithPerson:(NSArray *)personarr;
@end
