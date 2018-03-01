//
//  MainViewController.h
//  pdjyh
//
//  Created by ch on 12-6-28.
//  Copyright (c) 2012年 ch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChUITabBarView.h"

@interface MainViewController : UIViewController<ChUITabBarViewDelegate>{
     ChUITabBarView *_tabBar;//底部tabBarView
}

@property(nonatomic,retain) NSMutableArray* tabBarItems;//底部按钮items信息

@end
