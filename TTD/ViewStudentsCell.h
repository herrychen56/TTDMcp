//
//  ViewStudentsCell.h
//  TTD
//
//  Created by andy on 13-8-22.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kViewStudentsCellHeight        66
@interface ViewStudentsCell : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *studentName;
@property (retain, nonatomic) IBOutlet UILabel *studentId;
@property (retain, nonatomic) IBOutlet UIImageView *studentPhoto;
@property (retain, nonatomic) IBOutlet UILabel *studentEmail;
@property (retain, nonatomic) IBOutlet UILabel *studentTel;
@property (retain, nonatomic) IBOutlet UILabel *studentLocation;
@property (retain, nonatomic) IBOutlet UIImageView *btView;

@end
