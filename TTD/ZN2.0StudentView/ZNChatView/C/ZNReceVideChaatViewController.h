//
//  ZNReceVideChaatViewController.h
//  TTD
//
//  Created by quakoo on 2017/12/19.
//  Copyright © 2017年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNReceVideChaatViewController : UIViewController
//取消按钮
@property (weak, nonatomic) IBOutlet UIButton *rejectbtn;

//接听按钮
@property (weak, nonatomic) IBOutlet UIButton *answerbtn;

//姓名
@property (weak, nonatomic) IBOutlet UILabel *namelab;

@property (nonatomic,strong) NSString * nametext;

@property (nonatomic,assign) BOOL ismultiple;

@property (nonatomic,strong) NSString * numberstr;

//1-2 新增动态人数
@property (nonatomic,strong) NSMutableArray * otherArr;


@property (nonatomic,strong) NSString * reqname;

@property (nonatomic,strong) NSString * VsessionID;


@end
