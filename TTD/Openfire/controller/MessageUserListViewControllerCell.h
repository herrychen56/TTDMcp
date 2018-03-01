//
//  MessageUserListViewControllerCell.h
//  TTD
//
//  Created by andy on 13-10-10.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageUserListViewControllerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *UserName;
@property (strong, nonatomic) IBOutlet UILabel *Messageinfo;
@property (strong, nonatomic) IBOutlet UILabel *MessageinfoTime;
@property (strong, nonatomic) IBOutlet UIImageView *MessageFace;
@property (strong, nonatomic) IBOutlet UIImageView *UserPhoto;
@property (strong, nonatomic) IBOutlet UIView *BadgeView;

@end
