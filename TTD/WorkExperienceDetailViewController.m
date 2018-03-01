//
//  WorkExperienceDetailViewController.m
//  TTD
//
//  Created by Mark Hao on 8/25/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "WorkExperienceDetailViewController.h"

@interface WorkExperienceDetailViewController ()

@end

@implementation WorkExperienceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    self.dataEntryItems = [TTDGenericDataEntryItemFactory workExperienceDataEntryGroupWithInfo:self.we];
    [self.tableView reloadData];
}

@end
