//
//  VolunteerCommunityDetailViewController.m
//  TTD
//
//  Created by Mark Hao on 8/25/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "VolunteerCommunityDetailViewController.h"

@interface VolunteerCommunityDetailViewController ()

@end

@implementation VolunteerCommunityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    self.dataEntryItems = [TTDGenericDataEntryItemFactory volunteerCommunityDataEntryGroupWithInfo:self.vc];
    [self.tableView reloadData];
}

@end
