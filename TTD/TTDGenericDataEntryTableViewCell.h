//
//  TTDGenericDataEntryTableViewCell.h
//  TTD
//
//  Created by Yu Qi Hao on 8/22/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDGenericDataEntryItemFactory.h"

@interface TTDGenericDataEntryTableViewCell : UITableViewCell

@property (nonatomic, strong) TTDGenericDataEntryItem *item;

- (void)configureWithDataEntryItem:(TTDGenericDataEntryItem *)item;

@end
