//
//  KKChatDelegate.m
//  BaseProject
//
//  Created by Huan Cho on 13-8-3.
//  Copyright (c) 2013年 ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCMessageObject.h"
@protocol KKMessageDelegate <NSObject>

-(void)newMessageReceived:(NSDictionary *)messageContent;
-(void)ServerState:(BOOL)state;
//-(void)newMessageReceivedObject:(WCMessageObject *)messageobject;
@end
