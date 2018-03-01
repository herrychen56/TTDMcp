//
//  CreateCell.h
//  TTD
//
//  Created by guligei on 12/7/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kViewTimesheetCellHeight        66

@interface ViewTimeSheetCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel* nameLabel;
@property (retain, nonatomic) IBOutlet UILabel* location;
@property (retain, nonatomic) IBOutlet UILabel* calendar;
@property (retain, nonatomic) IBOutlet UILabel* statusLabel;

-(void)setTutoratio:(NSString*)toratio;

@end
