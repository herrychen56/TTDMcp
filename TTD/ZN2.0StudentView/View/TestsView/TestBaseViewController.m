//
//  TestBaseViewController.m
//  TTD
//
//  Created by quakoo on 2018/1/26.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "TestBaseViewController.h"

@interface TestBaseViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TestBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasout.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSStringFromClass([self class]) stringByAppendingString:@"cell"]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSStringFromClass([self class]) stringByAppendingString:@"cell"]];
    }
    NSDictionary * dic=_datasout[indexPath.row];

    
    
    
   
    return cell;
}

@end
