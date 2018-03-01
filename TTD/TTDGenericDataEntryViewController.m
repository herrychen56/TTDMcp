//
//  TTDGenericDataEntryViewController.m
//  TTD
//
//  Created by Yu Qi Hao on 8/22/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "TTDGenericDataEntryViewController.h"
#import "TTDDataEntryStringCell.h"
#import "TTDDataEntryLongStringCell.h"

@interface TTDGenericDataEntryViewController ()

@end

@implementation TTDGenericDataEntryViewController

- (id)init
{
    self = [super initWithNibName:@"TTDGenericDataEntryViewController" bundle:nil];
    if (self) {
    }
    return self;
}

- (id)initWithDataEntryItems:(NSArray *)items
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.dataEntryItems = items;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTDDataEntryStringCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TTDDataEntryStringCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTDDataEntryLongStringCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TTDDataEntryLongStringCell class])];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataEntryItems.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    TTDGenericDataEntryGroup *group = self.dataEntryItems[section];
    return group.groupTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TTDGenericDataEntryGroup *group = self.dataEntryItems[section];
    NSInteger itemCount = [group.entryItems count];
    return itemCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTDGenericDataEntryItem *item = [self dataEntryItemForIndexPath:indexPath];
    
    if (item) {
        TTDGenericDataEntryTableViewCell *cell = nil;
        switch (item.dataType) {
            case TTDGenericDataEntryDataTypeString:
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTDDataEntryStringCell class]) forIndexPath:indexPath];
                break;
            case TTDGenericDataEntryDataTypeLongString:
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTDDataEntryLongStringCell class]) forIndexPath:indexPath];
            default:
                break;
        }
        
        [cell configureWithDataEntryItem:item];
        return cell;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTDGenericDataEntryItem *item = [self dataEntryItemForIndexPath:indexPath];
    
    if (item) {
        if (item.dataType == TTDGenericDataEntryDataTypeLongString) {
            return 140.;
        } else {
            return 44.;
        }
    }
    else {
        return 0;
    }
}


- (TTDGenericDataEntryItem *)dataEntryItemForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sectionIdx = indexPath.section;
    NSInteger rowIdx = indexPath.row;
    TTDGenericDataEntryGroup *group = self.dataEntryItems[sectionIdx];
    TTDGenericDataEntryItem *item = group.entryItems[rowIdx];
    return item;
}
@end

