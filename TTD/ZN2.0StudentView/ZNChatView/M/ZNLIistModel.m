//
//  ZNLIistModel.m
//  TTD
//
//  Created by quakoo on 2017/12/26.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "ZNLIistModel.h"

@implementation ZNLIistModel

- (instancetype) initWithid:(WCMessageObject *) idstr {
    
    self.nameStr = idstr.userNickname;
    self.imageName = idstr.userHead;
    self.userid = [NSString stringWithFormat:@"%@%@",idstr.userId,@"@%@",OpenFireHostName];
    self.group = idstr.group;
//    NSLog(@"用户id==%@",self.userid);
    
    return self;
}

@end
