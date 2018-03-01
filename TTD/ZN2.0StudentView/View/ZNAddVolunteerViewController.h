//
//  ZNAddVolunteerViewController.h
//  TTD
//
//  Created by quakoo on 2017/12/6.
//  Copyright © 2017年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNAddVolunteerViewController : UIViewController

//position
@property (strong, nonatomic) IBOutlet UITextField *positiontext;
@property (nonatomic,strong) NSString * positionstr;
//activity name
@property (strong, nonatomic) IBOutlet UITextField *activitytext;
@property (nonatomic,strong) NSString * activitystr;
//description
@property (strong, nonatomic) IBOutlet UITextField *desciptiontext;
@property (nonatomic,strong) NSString * desciptionstr;
//year
@property (strong, nonatomic) IBOutlet UIButton *onebutton;
@property (strong, nonatomic) IBOutlet UIButton *twobutton;
@property (strong, nonatomic) IBOutlet UIButton *threebutton;
@property (strong, nonatomic) IBOutlet UIButton *fourbutton;

//hrs/week
@property (strong, nonatomic) IBOutlet UITextField *hrstext;
@property (nonatomic,strong) NSString * hrsstr;
//planned
@property (strong, nonatomic) IBOutlet UISwitch *planned;

//leadership
@property (strong, nonatomic) IBOutlet UISwitch *leadership;

//dele experience
@property (strong, nonatomic) IBOutlet UIButton *delebutton;

@property (nonatomic,strong) NSString * butsectionstr;
//Hours/week
@property (weak, nonatomic) IBOutlet UIButton *hoursbtn;
//Weeks/year
@property (weak, nonatomic) IBOutlet UIButton *yearbtn;
//college year1
@property (weak, nonatomic) IBOutlet UIButton *collebtn1;
//college year2
@property (weak, nonatomic) IBOutlet UIButton *collebtn2;
//college year3
@property (weak, nonatomic) IBOutlet UIButton *collebtn3;

//duation
@property (weak, nonatomic) IBOutlet UILabel *duationlab;
@property (weak, nonatomic) IBOutlet UITextField *duationone;
@property (weak, nonatomic) IBOutlet UITextField *duationtwo;
@property (weak, nonatomic) IBOutlet UITextField *duationthree;
@property (weak, nonatomic) IBOutlet UITextField *duationfour;
@property (weak, nonatomic) IBOutlet UILabel *duatlabone;
@property (weak, nonatomic) IBOutlet UILabel *dualabtwo;
@property (weak, nonatomic) IBOutlet UILabel *dualabthree;






@property (nonatomic,strong) NSString * planstr;
@property (nonatomic,strong) NSString * lenstr;

@property (nonatomic,strong) NSString * activID;


@property (nonatomic,strong) NSString * cellid;


@end
