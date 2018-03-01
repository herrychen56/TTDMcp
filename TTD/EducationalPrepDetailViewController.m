//
//  EducationalPrepDetailViewController.m
//  TTD
//
//  Created by Yu Qi Hao on 8/22/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "EducationalPrepDetailViewController.h"

@interface EducationalPrepDetailViewController ()

@end

@implementation EducationalPrepDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    self.dataEntryItems = [TTDGenericDataEntryItemFactory educationalPrepDataEntryGroupWithInfo:self.ep];
    [self.tableView reloadData];
}


@end
