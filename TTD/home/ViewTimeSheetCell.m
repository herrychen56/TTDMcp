//
//  CreateCell.m
//  TTD
//
//  Created by guligei on 12/7/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import "ViewTimeSheetCell.h"

@implementation ViewTimeSheetCell

@synthesize nameLabel;
@synthesize location;
@synthesize calendar;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
/*0 Draft
 *1 Pending
 *2 First Approval
 *3 Rejected
 *4 Deleted
 */
-(void)setTutoratio:(NSString*)toratios {
    if ([toratios isEqualToString:@"Draft"]) {
        UIColor *myColorRGB = [ [ UIColor alloc ] initWithRed:118/255.0
                                                        green: 60/255.0
                                                         blue: 238/255.0
                                                        alpha: 1.0];
        self.statusLabel.textColor = myColorRGB;
    }
    
    else if ( [toratios isEqualToString:@"Pending"]) {
        UIColor *myColorRGB = [ [ UIColor alloc ] initWithRed:213/255.0
                                                        green: 62/255.0
                                                         blue: 62/255.0
                                                        alpha: 1.0];
        self.statusLabel.textColor = myColorRGB;
    }
    else if ([toratios isEqualToString:@"First Approval"]) {
        UIColor *myColorRGB = [ [ UIColor alloc ] initWithRed:180/255.0
                                                        green: 146/255.0
                                                         blue: 1/255.0
                                                        alpha: 1.0];
        self.statusLabel.textColor = myColorRGB;
    }
    else if ([toratios isEqualToString:@"Final Approval"]) {
        UIColor *myColorRGB = [ [ UIColor alloc ] initWithRed:23/255.0
                                                        green: 155/255.0
                                                         blue: 37/255.0
                                                        alpha: 1.0];
        self.statusLabel.textColor = myColorRGB;
    }
    else if ([toratios isEqualToString:@"Rejected"]) {
        UIColor *myColorRGB = [ [ UIColor alloc ] initWithRed:66/255.0
                                                        green: 160/255.0
                                                         blue: 240/255.0
                                                        alpha: 1.0];
        self.statusLabel.textColor = myColorRGB;
    }
    else if ([toratios isEqualToString:@"Deleted"]) {
        UIColor *myColorRGB = [ [ UIColor alloc ] initWithRed:85/255.0
                                                        green: 84/255.0
                                                         blue: 84/255.0
                                                        alpha: 1.0];
        self.statusLabel.textColor = myColorRGB;
    }
    self.statusLabel.text = toratios;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
