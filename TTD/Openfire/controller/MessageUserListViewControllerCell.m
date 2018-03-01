//
//  MessageUserListViewControllerCell.m
//  TTD
//
//  Created by andy on 13-10-10.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "MessageUserListViewControllerCell.h"

@interface MessageUserListViewControllerCell ()

@end

@implementation MessageUserListViewControllerCell
@synthesize UserName;
@synthesize UserPhoto;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
