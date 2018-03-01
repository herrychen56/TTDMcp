//
//  StudentInfoCell0.m
//  TTD
//
//  Created by andy on 13-8-31.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "StudentInfoCell0.h"

@implementation StudentInfoCell0
@synthesize lblStuInfo;
@synthesize lblStuName;
@synthesize lblTime;
@synthesize imgStuPhoto;
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
