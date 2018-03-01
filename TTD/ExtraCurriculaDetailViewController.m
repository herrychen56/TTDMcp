//
//  ExtraCurriculaDetailViewController.m
//  TTD
//
//  Created by Yu Qi Hao on 8/22/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "ExtraCurriculaDetailViewController.h"

@interface ExtraCurriculaDetailViewController ()

@end

@implementation ExtraCurriculaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    self.dataEntryItems = [TTDGenericDataEntryItemFactory extraCurricularDataEntryGroupWithInfo:self.ec];
    [self.tableView reloadData];
}

@end
