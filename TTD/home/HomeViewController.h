//
//  HomeViewController.h
//  TTD
//
//  Created by ZhangChuntao on 12/7/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface HomeViewController : BaseViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *outletTotalHours;
@property (weak, nonatomic) IBOutlet UILabel *outletTotalPayment;

@end
