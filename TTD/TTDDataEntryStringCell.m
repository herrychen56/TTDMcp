//
//  TTDDataEntryStringCell.m
//  TTD
//
//  Created by Yu Qi Hao on 8/22/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "TTDDataEntryStringCell.h"

@implementation TTDDataEntryStringCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)configureWithDataEntryItem: (TTDGenericDataEntryItem *)item
{
    if (self.item != item) {
        self.item = item;
        self.titleLabel.text = item.dataTitle;
        self.entryTextField.placeholder = item.placeholderText;
    }
    self.entryTextField.text = item.valueDisplayText;
}

@end
