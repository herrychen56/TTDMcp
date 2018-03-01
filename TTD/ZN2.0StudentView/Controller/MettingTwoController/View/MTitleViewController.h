//
//  MTitleViewController.h
//  TTD
//
//  Created by 张楠 on 2018/1/9.
//  Copyright © 2018年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUFoldingTableView.h"
@interface MTitleViewController : UIViewController

@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;

@property (nonatomic,strong) NSString * MeetingtitleStr;
@property (nonatomic,strong) NSArray * UserArr;
@property (nonatomic,strong) NSString * mettingTimeStr;
@property (nonatomic,strong) NSString * dourationStr;
@property (nonatomic,strong) NSArray * videoArr;
@property (nonatomic,strong) NSArray * MeetingChatArr;
@property (nonatomic,strong) NSString * meetingtitle;

@end
