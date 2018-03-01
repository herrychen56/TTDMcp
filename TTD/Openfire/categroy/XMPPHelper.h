//
//  XMPPHelper.h
//  BaseProject
//
//  Created by Huan Cho on 13-8-6.
//  Copyright (c) 2013年 ch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMPPHelper : NSObject

+(UIImage *)xmppUserPhotoForJID:(XMPPJID *)jid;
+(NSString *)xmppUserPhotoForJIDNSString:(XMPPJID *)jid;
+(void)updateVCard:(XMPPvCardTemp *)vcard;
+(XMPPvCardTemp *)getmyvcard;
+(XMPPvCardTemp *)getJidvcard:(XMPPJID *)jid;
+(void)clearvCard:(XMPPJID *)jid;
@end
