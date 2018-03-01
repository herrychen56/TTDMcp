//
//  RequestStudentInfoViewController.h
//  TTD
//
//  Created by andy on 13-9-24.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface RequestStudentInfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIView *tutorInfo;
@property (weak, nonatomic) IBOutlet UIView *subjectInfo;
- (IBAction)btnBack:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollerview;
@property (weak, nonatomic) IBOutlet UIView *viewrequestinfo;
@property (weak, nonatomic) IBOutlet UILabel *lblNote;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstMeetTime;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblRadio;
@property (weak, nonatomic) IBOutlet UILabel *lblSubject;
@property (weak, nonatomic) IBOutlet UITableView *stuAndParentTableView;
@property (strong, nonatomic) NSMutableArray* requestInfotArray;
@property (strong, nonatomic) NSMutableArray* requestAllStudentInfotArray;
@property (strong, nonatomic) NSString*reqestid;
@end
