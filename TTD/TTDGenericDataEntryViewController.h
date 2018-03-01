//
//  TTDGenericDataEntryViewController.h
//  TTD
//
//  Created by Yu Qi Hao on 8/22/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "BaseViewController.h"

@interface TTDGenericDataEntryViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataEntryItems;

@end
