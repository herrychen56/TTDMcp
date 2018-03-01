//
//  ZNLIistModel.h
//  TTD
//
//  Created by quakoo on 2017/12/26.
//  Copyright © 2017年 totem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCMessageObject.h"

@interface ZNLIistModel : NSObject
@property (nonatomic,copy) NSString * nameStr; //姓名

@property (nonatomic,copy) NSString * imageName;//头像

@property (nonatomic,copy) NSString * userid;//用户id

@property (nonatomic,copy) NSString * group;

- (instancetype) initWithid:(WCMessageObject *) idstr ;

@end
