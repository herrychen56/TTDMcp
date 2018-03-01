//
//  StudentMainViewController.h
//  TTD
//
//  Created by quakoo on 2017/12/5.
//  Copyright © 2017年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface StudentMainViewController : BaseViewController<UINavigationControllerDelegate>
@property(nonatomic, retain) UIImage *photo;
@property (nonatomic,strong) NSString * userIDs;
@end
