//
//  ZNVMListViewController.h
//  TTD
//
//  Created by quakoo on 2018/1/2.
//  Copyright © 2018年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNVMListViewController : UIViewController
@property (nonatomic,strong) NSString * numbStr;
@property (nonatomic,strong) NSMutableArray * personArr;

/**
 已选人数
 */
@property (nonatomic,strong) NSMutableArray *selectedArr;

//动态新增sessionID
@property (nonatomic,strong) NSString * sessionID;

@end
