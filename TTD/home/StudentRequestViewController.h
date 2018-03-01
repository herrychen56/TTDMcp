//
//  StudentRequestViewController.h
//  TTD
//
//  Created by andy on 13-9-23.
//  Copyright (c) 2013年 totem. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface StudentRequestViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)btnWaitingRequest:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *waitingRequestButtion;
@property (weak, nonatomic) IBOutlet UIButton *matchedStudentButtion;
- (IBAction)btnMatchedStudent:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *stuRequestTableView;
@property (strong, nonatomic) NSMutableArray* WaitingRequestArray;
@property (strong, nonatomic) NSMutableArray* MatchedStudentArray;
@property(nonatomic) BOOL showOne;
@end
