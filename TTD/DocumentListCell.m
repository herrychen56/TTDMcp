//
//  DocumentListCell.m
//  TTD
//
//  Created by Mark Hao on 8/20/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "DocumentListCell.h"

@implementation DocumentListCell

-(void)setupCellWith:(TTDDocument *)document {
    [self.imageView setImage:[self imageWithImage:[UIImage imageWithData:document.fileThumbnail] scaledToSize:CGSizeMake(45., 60.)]];
    
    self.fileNameLabel.text = document.documentName;
    NSString *dateInNum = [document.uploadedDate substringWithRange:NSMakeRange(6, document.uploadedDate.length -8)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([dateInNum integerValue] / 1000)];
    
    self.fileInfoLabel.text = [NSString stringWithFormat:@"Uploaded by %@ - %@", document.uploadedByRole, [dateFormatter stringFromDate:date]];
                               
}


-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
