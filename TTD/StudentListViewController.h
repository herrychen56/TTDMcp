//
//  StudentListViewController.h
//  TTD
//
//  Created by Jeff Tang on 8/24/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface StudentListViewController : BaseViewController

@property (strong, nonatomic) NSArray* studentArray;
@property (strong, nonatomic) NSString* currentTab;

@end
