//
//  DocumentListCell.h
//  TTD
//
//  Created by Mark Hao on 8/20/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDDocument.h"

@interface DocumentListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileInfoLabel;

-(void)setupCellWith: (TTDDocument *) document;

@end
