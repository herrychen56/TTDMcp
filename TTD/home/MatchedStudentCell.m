//
//  MatchedStudentCell.m
//  TTD
//
//  Created by andy on 13-9-25.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "MatchedStudentCell.h"

@implementation MatchedStudentCell
@synthesize lblStuName;
@synthesize lblPhone;
@synthesize lblGradSchool;
@synthesize lblGradYear;
@synthesize lblStuEmail;
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
