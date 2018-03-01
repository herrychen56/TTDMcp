//
//  ZNChatMessageViewController.h
//  TTD
//
//  Created by quakoo on 2017/12/8.
//  Copyright © 2017年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNChatMessageViewController : UIViewController
@property(nonatomic, strong) NSString *chatWithUser;
@property (nonatomic,strong) NSString * userNickname;
@property (nonatomic,strong) NSString * ToUserPhoto;
@property (nonatomic,strong) NSString * groupChat;
@property (nonatomic,assign) BOOL  Isgroup;

@property (nonatomic, retain)  id<KKChatDelegate>       chatDelegate;
@property (nonatomic, retain)  id<KKMessageDelegate>    messageDelegate;
@end
