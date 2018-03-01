//
//  TTDDataEntryStringCell.h
//  TTD
//
//  Created by Yu Qi Hao on 8/22/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTDDataEntryStringCell : TTDGenericDataEntryTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *entryTextField;

@end
