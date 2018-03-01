//
//  ZNGroupChatViewController.h
//  TTD
//
//  Created by quakoo on 2018/1/6.
//  Copyright © 2018年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNGroupChatViewController : UIViewController
@property(nonatomic, strong) NSString *chatWithUser;
@property (nonatomic,strong) NSString * userNickname;
@property (nonatomic,strong) NSString * ToUserPhoto;

@property (nonatomic, retain)  id<KKChatDelegate>       chatDelegate;
@property (nonatomic, retain)  id<KKMessageDelegate>    messageDelegate;

@end
