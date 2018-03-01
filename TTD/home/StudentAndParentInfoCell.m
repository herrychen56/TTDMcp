//
//  StudentAndParentInfoCell.m
//  TTD
//
//  Created by andy on 13-9-26.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "StudentAndParentInfoCell.h"

@implementation StudentAndParentInfoCell
@synthesize lblGradSchool;
@synthesize lblPContactPhone;
@synthesize lblPEmail;
@synthesize  lblPHomePhone;
@synthesize lblPName;
@synthesize lblStuEmail;
@synthesize lblStuGradYear;
@synthesize lblStuName;
@synthesize lblStuPhone;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
