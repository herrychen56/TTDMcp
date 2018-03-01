//
//  ZNListViewController.h
//  TTD
//
//  Created by quakoo on 2017/12/26.
//  Copyright © 2017年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNListViewController : UIViewController
@property (nonatomic,strong) NSString * numbStr;
@property (nonatomic,strong) NSMutableArray * personArr;
//判断添加类型
@property (nonatomic,strong) NSNumber * Roomtype;
@end
