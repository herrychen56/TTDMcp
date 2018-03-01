//
//  WaitingRequestViewController.h
//  TTD
//
//  Created by andy on 13-9-24.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface WaitingRequestViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *userFullName;
- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerview;
- (IBAction)btnAccept:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewRequest;
@property (weak, nonatomic) IBOutlet UILabel *lblnate;
@property (weak, nonatomic) IBOutlet UILabel *lblfirstmeettime;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblTutorRadio;
@property (weak, nonatomic) IBOutlet UILabel *lblsubject;
@property (weak, nonatomic) IBOutlet UILabel *lblstuname;

@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UIView *userHeadView;
@property (strong, nonatomic) NSMutableArray* requestInfotArray;
@property (strong, nonatomic) NSMutableArray* requestAllStudentInfotArray;
@property (strong, nonatomic) NSString*reqestid;
@end
