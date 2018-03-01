//
//  StudentRequestCell.m
//  TTD
//
//  Created by andy on 13-9-23.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "StudentRequestCell.h"

@implementation StudentRequestCell
@synthesize lblLocation;
@synthesize lblStuName;
@synthesize lblSubject;
@synthesize isNew;
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
