//
//  AwardsAndHonorsDetailViewController.m
//  TTD
//
//  Created by Yu Qi Hao on 8/22/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "AwardsAndHonorsDetailViewController.h"

@interface AwardsAndHonorsDetailViewController ()

@end

@implementation AwardsAndHonorsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    self.dataEntryItems = [TTDGenericDataEntryItemFactory awardsAndHonorsDataEntryGroupWithInfo:self.ah];
    [self.tableView reloadData];
}


@end
