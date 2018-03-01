//
//  TTDDataEntryLongStringCell.m
//  TTD
//
//  Created by Yu Qi Hao on 8/22/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "TTDDataEntryLongStringCell.h"

@implementation TTDDataEntryLongStringCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithDataEntryItem:(TTDGenericDataEntryItem *)item
{
    if (self.item != item) {
        self.item = item;
    }
    
    self.longStringTextView.text = item.valueDisplayText;
}

@end
