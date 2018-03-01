//
//  ViewTimeSheetViewController.h
//  TTD
//
//  Created by ZhangChuntao on 12/7/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ViewTimeSheetViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    BOOL shouldReload;
}
- (IBAction)backAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton* backButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* timeSheetArray;
@end