//
//  NEwsTableViewCell.h
//  TTD
//
//  Created by 张楠 on 2018/1/31.
//  Copyright © 2018年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEwsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UILabel *datalab;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UITextView *contentext;



@end
