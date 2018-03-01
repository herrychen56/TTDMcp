//
//  ViewStudentsCell.m
//  TTD
//
//  Created by andy on 13-8-22.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "ViewStudentsCell.h"


@implementation ViewStudentsCell
@synthesize studentName;
@synthesize studentId;
@synthesize studentPhoto;
@synthesize studentEmail;
@synthesize studentTel;
@synthesize studentLocation;
@synthesize btView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setStudentName:nil];
    [self setStudentId:nil];
    [self setStudentPhoto:nil];
    [self setStudentEmail:nil];
    [self setStudentTel:nil];
    [self setStudentLocation:nil];
    [self setBtView:nil];
    [super viewDidUnload];
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
}
@end
