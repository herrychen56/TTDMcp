//
//  CourseworkOtherDetailViewController.m
//  TTD
//
//  Created by Mark Hao on 8/25/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "CourseworkOtherDetailViewController.h"

@interface CourseworkOtherDetailViewController ()

@end

@implementation CourseworkOtherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    self.dataEntryItems = [TTDGenericDataEntryItemFactory courseworkOtherDataEntryGroupWithInfo:self.co];
    [self.tableView reloadData];
}
@end
