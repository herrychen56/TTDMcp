//
//  StudentInfoViewController0.h
//  TTD
//
//  Created by andy on 13-8-31.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface StudentInfoViewController0 : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
- (IBAction)btnPrevious:(id)sender;
- (IBAction)btnNext:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblStudentNameID;
@property (weak, nonatomic) IBOutlet UITableView *tableview0;
@property(nonatomic)NSString *text;

@property(nonatomic,retain)NSIndexPath *selectedCellIndexPath;
@property(nonatomic)NSMutableArray *arrbool;
@property (strong, nonatomic) NSMutableArray* meetingminuteArray;

@property (strong, nonatomic) NSArray* studentArray;
@property (strong, nonatomic) NSString* studentid;

@property (strong, nonatomic) NSString* stuFullName;
@end
