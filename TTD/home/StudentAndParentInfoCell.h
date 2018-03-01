//
//  StudentAndParentInfoCell.h
//  TTD
//
//  Created by andy on 13-9-26.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentAndParentInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblPContactPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblPHomePhone;
@property (weak, nonatomic) IBOutlet UILabel *lblPEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPName;
@property (weak, nonatomic) IBOutlet UILabel *lblGradSchool;
@property (weak, nonatomic) IBOutlet UILabel *lblStuGradYear;
@property (weak, nonatomic) IBOutlet UILabel *lblStuPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblStuEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblStuName;

@end
