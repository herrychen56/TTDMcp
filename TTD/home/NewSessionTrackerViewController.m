//
//  NewSessionTrackerViewController.m
//  TTD
//
//  Created by Andy on 2017/10/18.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "NewSessionTrackerViewController.h"
#import "Photo.h"
#import "BCTabBarController.h"
#import "UIImageView+AFNetworking.h"
#import "TimeView.h"
#import "SignatureView.h"
#import "UIColor+Colours.h"
#import "AppDelegate.h"
#import "NSObject+SBJson.h"
#import "SmoothLineView.h"
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() ==UIUserInterfaceIdiomPad ) ? YES : NO
@interface NewSessionTrackerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,TimeViewResizeDelegate,UIScrollViewDelegate,SignatureViewDelegate>

{
    BOOL firstTimeLoading;
    BOOL shouldResetAllSubviews;
    BOOL localTimeSheetUsed;
    NSInteger studentFieldId;
    NSInteger editingRow;
    SignatureView *currentSigningView;
}

@end

@implementation NewSessionTrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpPopoverView];
    [self setUpUI];
    [self initSubviews];
    if (self.timeSheetSummary) {
        self.isQuery = YES;
        [self loadTimeSheet];
    }
    [self initDatas];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIView *_uiview = (UIView *)[self.view viewWithTag:202];
        _uiview.frame=CGRectMake(_uiview.frame.origin.x,_uiview.frame.origin.y,SCREEN_WIDTH, (_uiview.frame.size.height)-20);
        
        
    }
}

- (void)setUpPopoverView {
    self.popoverView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(10),SCREEN_WIDTH , SCREEN_HEIGHT)];
    self.popoverView.hidden = YES;
    self.popoverView.backgroundColor = [UIColor colorFromHexString:@"#EFEFF4" alpha:1];
    [self.view addSubview:self.popoverView];
    self.signContainerView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH(10), HEIGHT(185), SCREEN_WIDTH - WIDTH(10),  SCREEN_WIDTH - WIDTH(10))];
    [self.popoverView addSubview:self.signContainerView];
    self.signContainerView.backgroundColor = [UIColor whiteColor];
    self.smothBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(10), HEIGHT(10), WIDTH(280), HEIGHT(120))];
    self.smothBackImageView.userInteractionEnabled = YES;
    self.smothBackImageView.backgroundColor = [UIColor colorFromHexString:@"#D0D0D0" alpha:1];
    [self.signContainerView addSubview:self.smothBackImageView];
    self.signView = [[SmoothLineView alloc]initWithFrame:CGRectMake(WIDTH(10), HEIGHT(10), WIDTH(280), HEIGHT(120))];
    [self.signContainerView addSubview:self.signView];
    self.signOkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signOkButton.frame = CGRectMake(WIDTH(80), HEIGHT(293), WIDTH(73), HEIGHT(30));
    [self.signOkButton setTitle:[NSString stringWithFormat:@"OK"] forState:UIControlStateNormal];
    [self.signOkButton setTitleColor:[UIColor colorFromHexString:@"#585858" alpha:1] forState:UIControlStateNormal];
    self.signOkButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:HEIGHT(15)];
    [self.signOkButton addTarget:self action:@selector(signOkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.signContainerView addSubview:self.signOkButton];
    
    
    self.signCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signCancelButton.frame = CGRectMake(WIDTH(179), HEIGHT(290), WIDTH(73), HEIGHT(30));
    [self.signCancelButton setTitle:[NSString stringWithFormat:@"Cancel"] forState:UIControlStateNormal];
    [self.signCancelButton setTitleColor:[UIColor colorFromHexString:@"#585858" alpha:1] forState:UIControlStateNormal];
    self.signCancelButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:HEIGHT(15)];
    [self.signCancelButton addTarget:self action:@selector(signCancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.signContainerView addSubview:self.signCancelButton];
    
    
    
    self.signRewriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signRewriteButton.frame = CGRectMake(WIDTH(277), HEIGHT(290), WIDTH(73), HEIGHT(30));
    [self.signRewriteButton setTitle:[NSString stringWithFormat:@"Rewrite"] forState:UIControlStateNormal];
    [self.signRewriteButton setTitleColor:[UIColor colorFromHexString:@"#585858" alpha:1] forState:UIControlStateNormal];
    self.signRewriteButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:HEIGHT(15)];
    [self.signRewriteButton addTarget:self action:@selector(signRewriteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.signContainerView addSubview:self.signRewriteButton];
    
    

}

- (void)signOkButtonClick:(UIButton *)button {

    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    BCTabBarController *tab = (BCTabBarController *)app.window.rootViewController.presentedViewController;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    tab.tabBar.hidden = NO;
    currentSigningView.signImageView.image = [self.signView getCurrentImage];
    self.popoverView.hidden = YES;
    [self.signView clearButtonClicked];

}

- (void)signCancelButtonClick:(UIButton *)button {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    BCTabBarController *tab = (BCTabBarController *)app.window.rootViewController.presentedViewController;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    tab.tabBar.hidden = NO;
    self.popoverView.hidden = YES;
    [self.signView clearButtonClicked];
}

- (void)signRewriteButtonClick:(UIButton *)button {

    [self.signView clearButtonClicked];
}

- (void)setUpUI {
    //创建自定义滚动视图
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, HEIGHT(800));
    self.scrollView.backgroundColor =  [UIColor colorFromHexString:@"#EBEBF1" alpha:1];
    self.scrollView.delegate = self;
    self.scrollView.tag = 202;
    [self.view addSubview:self.scrollView];
    //创建用户名和用户头像
    self.userImageView = [[UIImageView alloc]init];
    self.userImageView.frame = CGRectMake(WIDTH(8), HEIGHT(4), SCREEN_WIDTH-WIDTH(16), HEIGHT(40));
    self.userImageView.image = [UIImage imageNamed:@"table_head.png"];
    [self.scrollView addSubview:self.userImageView];
    
    self.avatarImageView = [[UIImageView alloc]init];
    self.avatarImageView.frame = CGRectMake(WIDTH(15), HEIGHT(9), 35,35);
    self.avatarImageView.image = [UIImage imageNamed:@"icon_addPhoto"];
    [self.userImageView addSubview:self.avatarImageView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(48), HEIGHT(11), WIDTH(219), HEIGHT(21))];
    self.nameLabel.textColor = [UIColor colorFromHexString:@"#585858" alpha:1];
    self.nameLabel.font = [UIFont fontWithName:@"Arial" size:HEIGHT(10)];
    [self.userImageView addSubview:self.nameLabel];
    //创建statusView和RationView
    //statusView
    self.statusView = [[UIView alloc]initWithFrame:CGRectMake(0, WIDTH(52), SCREEN_HEIGHT, HEIGHT(40))];
    [self.scrollView addSubview:self.statusView];
    self.statusView.hidden = YES;
    self.tablePartImageView =[[UIImageView alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH - WIDTH(16), HEIGHT(40))];
    self.tablePartImageView.image = [UIImage imageNamed:@"table_part_up"];
    [self.statusView addSubview:self.tablePartImageView];
    self.iconstatusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(20), HEIGHT(13), WIDTH(16), WIDTH(16))];
    self.iconstatusImageView.image = [UIImage imageNamed:@"icon_status"];
    [self.tablePartImageView addSubview:self.iconstatusImageView];
    self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(45), HEIGHT(9), WIDTH(116), HEIGHT(21))];
    self.statusLabel.text = @"Status";
    self.statusLabel.textColor = [UIColor colorFromHexString:@"675C1A" alpha:1];;
    self.statusLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:HEIGHT(10.0)];
    self.statusLabel.tag = 2;
    [self.tablePartImageView addSubview:self.statusLabel];
    
    //RationView
    self.rationView = [[UIView alloc]initWithFrame:CGRectMake(0, WIDTH(52), SCREEN_HEIGHT, HEIGHT(40))];
    [self.scrollView addSubview:self.rationView];
    self.firstPartBg =[[UIImageView alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH - WIDTH(16), HEIGHT(40))];
    self.firstPartBg.image = [UIImage imageNamed:@"table_head.png"];
    [self.rationView addSubview:self.firstPartBg];
    self.iconrationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(20), HEIGHT(13),16,16)];
    self.iconrationImageView.image = [UIImage imageNamed:@"icon_tutoratio.png"];
    [self.firstPartBg addSubview:self.iconrationImageView];
    
    self.ration = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(45), HEIGHT(9), WIDTH(116), HEIGHT(21))];
    self.ration.text = @"Student-Tutor Ration";
    self.ration.textColor = [UIColor colorFromHexString:@"675C1A" alpha:1];
    self.ration.font = [UIFont fontWithName:@"Arial-BoldMT" size:HEIGHT(10.0)];
    [self.firstPartBg addSubview:self.ration];
    
    self.arrowTwoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(282), HEIGHT(15), WIDTH(10), WIDTH(10))];
    self.arrowTwoImageView.image = [UIImage imageNamed:@"icon_arrow"];
    [self.firstPartBg addSubview:self.arrowTwoImageView];

    self.rotioField = [[UITextField alloc]initWithFrame:CGRectMake(WIDTH(156), HEIGHT(5), WIDTH(136), HEIGHT(30))];
    self.rotioField.textColor = [UIColor colorFromHexString:@"#585858" alpha:1];
    self.rotioField.borderStyle = UITextBorderStyleNone;
    self.rotioField.adjustsFontSizeToFitWidth = WIDTH(17);
    self.rotioField.font = [UIFont fontWithName:@"Arial" size:HEIGHT(14)];
    self.rotioField.delegate = self;
    self.rotioField.tag = 2;
    self.rotioField.text = self.rotiaString;
    self.firstPartBg.userInteractionEnabled = YES;
    [self.firstPartBg addSubview:self.rotioField];
    //student列表
    self.studentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(8), HEIGHT(92),SCREEN_WIDTH-WIDTH(16) , HEIGHT(40))];
//    self.studentImageView.userInteractionEnabled = YES;
    self.studentImageView.image = [UIImage imageNamed:@"table_head.png"];
    [self.scrollView addSubview:self.studentImageView];
    UIImageView *icStudent = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(20), HEIGHT(13), 16, 16)];
    icStudent.image = [UIImage imageNamed:@"icon_student"];
    [self.studentImageView addSubview:icStudent];
    UILabel *studentLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(44), HEIGHT(9), WIDTH(80), HEIGHT(21))];
    studentLabel.textColor = [UIColor colorFromHexString:@"675C1A" alpha:1];
    studentLabel.text = @"student(s)";
    studentLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:HEIGHT(10)];
    [self.studentImageView addSubview:studentLabel];
    self.studentFiled = [[UITextField alloc]initWithFrame:CGRectMake(WIDTH(148), HEIGHT(5), WIDTH(145), HEIGHT(30))];
    self.studentFiled.textColor = [UIColor colorFromHexString:@"#585858" alpha:1];
    self.studentFiled.borderStyle = UITextBorderStyleNone;
    self.studentFiled.delegate = self;
    self.studentFiled.tag = 1;
    self.studentImageView.hidden = YES;
    [self.studentImageView addSubview:self.studentFiled];
    UIImageView *arrow = [[UIImageView alloc]init];
    arrow = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(278), HEIGHT(14), 10, 10)];
    arrow.image = [UIImage imageNamed:@"icon_arrow"];
    [self.studentImageView addSubview:arrow];    
    //header info View部分
    self.headerInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(130), SCREEN_WIDTH, HEIGHT(82))];
    [self.scrollView addSubview:self.headerInfoView];
    self.partView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(5), SCREEN_WIDTH, HEIGHT(82))];
    [self.headerInfoView addSubview:self.partView];
    //subject部分
    self.partUpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(8), 0, SCREEN_WIDTH-WIDTH(16), HEIGHT(40))];
    self.partUpImageView.image = [UIImage imageNamed:@"table_part_up"];
    [self.partView addSubview:self.partUpImageView];
    UIImageView *subjectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(20), WIDTH(13), 16, 16)];
    subjectImageView.image = [UIImage imageNamed:@"icon_subject"];
    [self.partUpImageView addSubview:subjectImageView];
    UILabel *subjectLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(44), HEIGHT(9), WIDTH(80), HEIGHT(21))];
    subjectLabel.textColor = [UIColor colorFromHexString:@"675C1A" alpha:1];
    subjectLabel.text = @"Subject";
    subjectLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:HEIGHT(10)];
    [self.partUpImageView addSubview:subjectLabel];
    self.subjectField = [[UITextField alloc]initWithFrame:CGRectMake(WIDTH(148), HEIGHT(5), WIDTH(145), HEIGHT(30))];
    self.subjectField.textColor = [UIColor colorFromHexString:@"#585858" alpha:1];
    self.subjectField.borderStyle = UITextBorderStyleNone;
    self.subjectField.delegate = self;
    self.subjectField.tag = 1;
    self.partUpImageView.userInteractionEnabled = YES;
    [self.partUpImageView addSubview:self.subjectField];
    self.arrowUp = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(278), HEIGHT(14), 10, 10)];
    self.arrowUp.image = [UIImage imageNamed:@"icon_arrow"];
    [self.partUpImageView addSubview:self.arrowUp];
    //location部分
    self.partBottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(8), HEIGHT(40), SCREEN_WIDTH-WIDTH(16), HEIGHT(40))];
    self.partBottomImageView.image = [UIImage imageNamed:@"table_part_bottom"];
    [self.partView addSubview:self.partBottomImageView];
    
    UIImageView *locationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(20), WIDTH(13), 16, 16)];
    locationImageView.image = [UIImage imageNamed:@"icon_location"];
    [self.partBottomImageView addSubview:locationImageView];
    UILabel *locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(44), HEIGHT(9), WIDTH(80), HEIGHT(21))];
    locationLabel.textColor = [UIColor colorFromHexString:@"675C1A" alpha:1];
    locationLabel.text = @"Location";
    locationLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:HEIGHT(10)];
    [self.partBottomImageView addSubview:locationLabel];
    self.locationField = [[UITextField alloc]initWithFrame:CGRectMake(WIDTH(148), HEIGHT(5), WIDTH(145), HEIGHT(30))];
    self.locationField.textColor = [UIColor colorFromHexString:@"#585858" alpha:1];
    self.locationField.borderStyle = UITextBorderStyleNone;
    self.locationField.delegate = self;
    self.locationField.tag = 3;
    self.partBottomImageView.userInteractionEnabled = YES;
    [self.partBottomImageView addSubview:self.locationField];
    self.arrowBottom = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(278), HEIGHT(14), WIDTH(10), HEIGHT(10))];
    self.arrowBottom.image = [UIImage imageNamed:@"icon_arrow"];
    [self.partBottomImageView addSubview:self.arrowBottom];
    self.btnContainerView = [[UIView alloc]initWithFrame:CGRectMake(0,HEIGHT(221), SCREEN_WIDTH, HEIGHT(48))];
    [self.scrollView addSubview:self.btnContainerView];
    //save 和 sumit按钮
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveButton.frame = CGRectMake(WIDTH(9), HEIGHT(2), WIDTH(145), HEIGHT(38)) ;
    [self.saveButton setImage:[UIImage imageNamed:@"btn_saveDraft"] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.tag = 1;
    [self.btnContainerView addSubview:self.saveButton];
    //sumit按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.frame = CGRectMake(WIDTH(162), HEIGHT(2), WIDTH(149), HEIGHT(38)) ;
    [self.submitButton setImage:[UIImage imageNamed:@"btn_submit"] forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.tag = 0;
    [self.btnContainerView addSubview:self.submitButton];
    //toolBar
    self.toolBar = [[UIView alloc]init];
    self.toolBar.frame = CGRectMake(0, SCREEN_HEIGHT - HEIGHT(240), SCREEN_WIDTH, HEIGHT(40));
    self.toolBar.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.toolBar];
    self.toolBar.hidden = YES;
    UIButton *donebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [donebutton setTitle:[NSString stringWithFormat:@"done"] forState:UIControlStateNormal];
//    donebutton.backgroundColor = [UIColor redColor];
    donebutton.frame = CGRectMake(SCREEN_WIDTH - WIDTH(40), HEIGHT(10), WIDTH(40), HEIGHT(20));
//    [donebutton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [donebutton addTarget:self action:@selector(Donebutton) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:donebutton];
    //pickerView
    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT - HEIGHT(200), SCREEN_WIDTH, HEIGHT(160));
    self.pickerView.delegate = self;
    self.pickerView.tag = 1;
    self.pickerView.hidden = YES;
    self.pickerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.pickerView];
}

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

//save sumit 按钮点击方法
- (void)ButtonClick:(UIButton *)button {
    if ([self.timeSheetSummary.source isEqualToString:@"Web"]) {
        [self updateWithType:button.tag];
    }else {
        [self submitWithType:button.tag];
    }

}

//toolBar done 按钮的点击方法
- (void)Donebutton {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    BCTabBarController *tab = (BCTabBarController *)app.window.rootViewController.presentedViewController;
    tab.tabBar.hidden = NO;
    [self pickerView:self.pickerView didSelectRow:[self.pickerView selectedRowInComponent:0] inComponent:0];
    [self.siggggg.studentField resignFirstResponder];
    [self.subjectField resignFirstResponder];
    [self.rotioField resignFirstResponder];
    [self.locationField resignFirstResponder];
    self.pickerView.hidden = YES;
    self.toolBar.hidden = YES;

}
//学生数组
- (void)setStudentArray:(NSMutableArray *)studentArray autoSelect:(BOOL)autoSelect {
    
}


//日期类里面的协议方法 TimeView位置
- (void)timeView:(TimeView *)timeView resized:(CGFloat)height {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGFloat maxHeight = 0;
    for (UIView* view in self.scrollView.subviews) {
        if (view.frame.origin.y > timeView.frame.origin.y) {
            CGRect frame = view.frame;
            frame.origin.y += height;
            view.frame = frame;
            CGFloat height = frame.origin.y + frame.size.height + HEIGHT(10);
            if (maxHeight < height) {
                maxHeight = height;
            }
        }
    }
    [UIView commitAnimations];
    if (maxHeight != self.scrollView.contentSize.height) {
        self.scrollView.contentSize = CGSizeMake(0, maxHeight);
    }
}
//判断是否为空
- (NSDictionary*)collectUpdateParam:(NSInteger)submitType
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    self.subjectArray = [[NSMutableArray alloc]init];
    self.ratioArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.subjectArray.count; i++) {
        SubjectInfo* subject = [self.subjectArray objectAtIndex:i];
        if ([self.subjectField.text isEqualToString:subject.subjectName]) {
            [dic setValue:[NSString stringWithFormat:@"%d", subject.subjectId] forKey:@"Subject"];
        }
    }
    if (![dic valueForKey:@"Subject"]) {
        [self showAlertWithTitle:nil andMessage:@"'Subject' cannot be empty!"];
        return nil;
    }
    for (int i = 0; i < self.ratioArray.count; i++) {
        RatioInfo* info = [self.ratioArray objectAtIndex:i];
        if ([self.rotioField.text isEqualToString:info.type]) {
            [dic setValue:[NSString stringWithFormat:@"%d", info.ratioId] forKey:@"StudentTutorRatio"];
        }
    }
    if (![dic valueForKey:@"StudentTutorRatio"]) {
        [self showAlertWithTitle:nil andMessage:@"'Student-Tutor Ratio' cannot be empty!"];
        return nil;
    }
    if (self.locationField.text.length == 0) {
        [self showAlertWithTitle:nil andMessage:@"'Location' cannot be empty!"];
        return nil;
    }
    [dic setValue:self.locationField.text forKey:@"Location"];
    TimeView* timeView = nil;
    NSMutableArray* timeArray = [NSMutableArray array];
    NSMutableArray* studentCellArray = [NSMutableArray array];
    for (UIView* view in self.scrollView.subviews) {
        if (view.tag == 100) {
            timeView = (TimeView*)view;
            NSDictionary* timeDic = [timeView collectParams];
            if (!timeDic) {
                [self showAlertWithTitle:nil andMessage:@"'Duration' cannot be empty!"];
                return nil;
            }
            [timeArray addObject:timeDic];
        }
        else if (view.tag > 100) {
            [studentCellArray addObject:view];
        }
    }
    if (timeArray.count > 0) {
        [dic setValue:timeArray forKey:@"TimesheetSessions"];
    }
    else {
        [dic setValue:@"" forKey:@"TimesheetSessions"];
    }
    if (studentCellArray.count > 0) {
        NSMutableString* studentString = [NSMutableString string];
        NSMutableString* NoShowString = [NSMutableString string];
        for (int i = 0; i < studentCellArray.count; i++) {
            SignatureView* cellView = (SignatureView*)[studentCellArray objectAtIndex:i];
            NSString* stuName = [cellView getStudentString];
            NSString* noshowValue = [cellView getNoShowString];
            if (stuName) {
                [studentString appendFormat:@"%@", stuName];
                [NoShowString appendFormat:@"%@", noshowValue];
                if (i != studentCellArray.count - 1) {
                    [studentString appendString:@","];
                    [NoShowString appendString:@"," ];
                }
            }
        }
        [dic setValue:studentString forKey:@"StuId"];
        [dic setValue:NoShowString forKeyPath:@"NoShow"];
    }
    else {
        [dic setValue:@"" forKey:@"StuId"];
    }
    [dic setValue:@"Web" forKey:@"Source"];
    if (submitType == 1) {
        [dic setValue:UPLOAD_TYPE_SAVE_DRAFT forKey:@"Submittype"];
    }
    else {
        [dic setValue:UPLOAD_TYPE_SUBMIT forKey:@"Submittype"];
    }
    return dic;
}


//修改信息
- (void)updateWithType:(NSInteger)type {

    if (!self.timeSheetSummary) {
        return;
    }
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableDictionary* params = nil;
    NSMutableURLRequest *request = nil;
    NSDictionary* dic = [self collectUpdateParam:type];
    if (!dic) {
        return;
    }
    NSArray* array = [NSArray arrayWithObject:dic];
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
              [array JSONRepresentation],   @"json",
              SharedAppDelegate.username, @"username",
              self.timeSheetSummary.timeSheetId, @"ts_id",
              SharedAppDelegate.password, @"password", nil];
    request = [client requestWithFunction:FUNC_UPDATE_TIMESHEET_WEB parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         [self hideLoadingView];
         UpdateTimeSheetResponse* mResponse = [UpdateTimeSheetResponse updateTimeSheetResponseWithDDXMLDocument:XMLDocument type:0];
         if (mResponse.succeed) {
             SharedAppDelegate.shouldReloadTimeSheetList = YES;
             [self showToastMessage:@"Succeed!" duration:2.0f];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else {
             [self showAlertWithTitle:nil andMessage:mResponse.responseMessage];
         }
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hideLoadingView];
         [self showAlertWithTitle:nil andMessage:@"No internet access!"];
     }];
    [operation start];
    if (type == 1) {
        [self showLoadingViewWithMessage:@"Saving..."];
    }
    else {
        [self showLoadingViewWithMessage:@"Submitting..."];
    }



}
//提交数据
- (void)submitWithType:(NSInteger)type
{
    NSDictionary* dic = [self collectParams:(1-type)];
    if (!dic) {
        return;
    }
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSString* typeSubmit = UPLOAD_TYPE_SUBMIT;
    if (type == 1) {
        typeSubmit = UPLOAD_TYPE_SAVE_DRAFT;
        bool showalert=false;
        for (UIView* view in self.scrollView.subviews) {
            if (view.tag > 100) {
                self.siggggg =view;
                NSInteger stuId = [self.siggggg getStudentId];
                BOOL noshowValue = [self.siggggg getNoShowBool];
                if (noshowValue==false&&stuId>0) {
                    showalert=true;
                }
            }
        }
        if (showalert) {
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"" message:@"Signature and password will not be stored, next time you need to re-enter" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [av show];
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   APPLICATION_VERSION,        @"Version",
                                   typeSubmit,                 @"Submittype",
                                   SharedAppDelegate.username, @"username",
                                   SharedAppDelegate.password, @"password", nil];
    [params setValuesForKeysWithDictionary:dic];
    NSMutableURLRequest *request = nil;
    if (self.isQuery) {
        [params setValue:self.timeSheetSummary.timeSheetId forKey:@"ts_id"];
        request = [client requestWithFunction:FUNC_UPDATE_TIMESHEET parameters:params];
    }
    else {
        request = [client requestWithFunction:FUNC_INSERT_TIMESHEET parameters:params];
    }
    
    
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         [self hideLoadingView];
         if (self.isQuery) {
             UpdateTimeSheetResponse* mResponse = [UpdateTimeSheetResponse updateTimeSheetResponseWithDDXMLDocument:XMLDocument type:1];
             if (mResponse.succeed) {
                 SharedAppDelegate.shouldReloadTimeSheetList = YES;
                 [self showToastMessage:@"Succeed!" duration:2.0f];
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else {
                 [self showAlertWithTitle:nil andMessage:mResponse.responseMessage];
             }
         }
         else {
             InsertTimeSheetResponse* mResponse = [InsertTimeSheetResponse insertTimeSheetResponseWithDDXMLDocument:XMLDocument];
             if (mResponse.succeed) {
                 SharedAppDelegate.shouldReloadTimeSheetList = YES;
                 [self showToastMessage:@"Succeed!" duration:2.0f];
                 [self resetViews];
             }
             else {
                 [self showAlertWithTitle:nil andMessage:mResponse.responseMessage];
             }
         }
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hideLoadingView];
         [self showAlertWithTitle:nil andMessage:@"No internet access!"];
     }];
    [operation start];
    if (type == 1) {
        [self showLoadingViewWithMessage:@"Saving..."];
    }
    else {
        [self showLoadingViewWithMessage:@"Submitting..."];
    }
}

//提示
- (NSDictionary*)collectParams:(BOOL)shouldCheck
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.subjectArray.count; i++) {
        SubjectInfo* subject = [self.subjectArray objectAtIndex:i];
        if ([self.subjectField.text isEqualToString:subject.subjectName]) {
            [dic setValue:[NSString stringWithFormat:@"%d", subject.subjectId] forKey:@"Subject"];
        }
    }
    if (![dic valueForKey:@"Subject"]) {
        [self showAlertWithTitle:nil andMessage:@"'Subject' cannot be empty!"];
        return nil;
    }
    for (int i = 0; i < self.ratioArray.count; i++) {
        RatioInfo* info = [self.ratioArray objectAtIndex:i];
        if ([self.rotioField.text isEqualToString:info.type]) {
            [dic setValue:[NSString stringWithFormat:@"%d", info.ratioId] forKey:@"StudentTutorRatio"];
        }
    }
    if (![dic valueForKey:@"StudentTutorRatio"]) {
        [self showAlertWithTitle:nil andMessage:@"'Student-Tutor Ratio' cannot be empty!"];
        return nil;
    }
    if (self.locationField.text.length == 0) {
        [self showAlertWithTitle:nil andMessage:@"'Location' cannot be empty!"];
        return nil;
    }
    NSString *loactionName=[self.locationField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dic setValue:loactionName forKey:@"Location"];
    TimeView* timeView = nil;
    NSMutableArray* signatureArray = [NSMutableArray array];
    for (UIView* view in self.scrollView.subviews) {
        if (view.tag == 100) {
            timeView = (TimeView*)view;
        }
        else if (view.tag > 100) {
            [signatureArray addObject:view];
        }
    }
    NSDictionary* timeDic = [timeView collectParams];
    if (!timeDic) {
        [self showAlertWithTitle:nil andMessage:@"'Duration' cannot be empty!"];
        return nil;
    }
    [dic setValuesForKeysWithDictionary:timeDic];
    NSMutableArray* array = [NSMutableArray array];
    for (int i = 0; i < signatureArray.count; i++)
    {
        SignatureView* sigView = (SignatureView*)[signatureArray objectAtIndex:i];
        NSDictionary* dic = [sigView collectParams:shouldCheck];
        if (!dic) {
            return nil;
        }
        [array addObject:dic];
    }
    if (array.count == 0) {
        return nil;
    }
    NSString* paramString = [array JSONRepresentation];
    [dic setValue:paramString forKey:@"StudentJson"];
    return dic;
}

- (void)setCellEditable:(BOOL)editable {
    self.subjectField.enabled = editable;
    self.rotioField.enabled = editable;
    self.locationField.enabled = editable;
    self.arrowTwoImageView.hidden = YES;
}

- (void)resetViews {

    self.rotiaString = @"1-1";
    shouldResetAllSubviews = YES;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self setDefaltSelection];
//    [self relayoutSubviews];
    
    
}


- (void)clearCache {
    [self resetViews];

}
//设置默认的field的显示
- (void)setDefaltSelection {
    if (self.studentArray.count > 0) {
        StudentInfo *info = [self.studentArray objectAtIndex:0];
        self.siggggg.studentField.text = info.studentName;
        studentFieldId = info.studentId;
    }
    if (self.subjectArray.count >0) {
        SubjectInfo *subject = [self.subjectArray objectAtIndex:0];
        self.subjectField.text = subject.subjectName;
    }
    if (self.ratioArray.count > 0) {
        RatioInfo* info = [self.ratioArray objectAtIndex:0];
        self.rotioField.text = info.type;
        self.rotiaString = info.type;
    }
    if (self.locationArray.count > 0) {
        LocationInfo* info = [self.locationArray objectAtIndex:0];
        self.locationField.text = info.locName;
    }
    

}
- (void)relayoutSubviews {
   
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(relayoutSubviews) object:nil];
    CGFloat currentY = HEIGHT(118);
    CGFloat contentHeight=self.scrollView.contentSize.height;
    NSInteger ratioCount = 1;
    NSInteger signatureCount = 1;
    BOOL shouldShowSubmit = YES;
    BOOL shouldShowSignature = YES;
    BOOL editable = YES;
    if (self.isQuery) {
         self.partView.hidden = YES;
        [self setTutoratio:self.timeSheetSummary.timeSheetState];
        if (self.statusView.hidden) {
            CGRect frame = self.rationView.frame;
            frame.origin.y += self.statusView.frame.size.height;
            self.rationView.frame = frame;
            self.statusView.hidden = NO;
            self.firstPartBg.image = [UIImage imageNamed:@"table_part_bottom.png"];
        }
        currentY += self.statusView.frame.size.height;
        if (!([self.timeSheetSummary.timeSheetState isEqualToString:STATUS_DRAFT])) {
            shouldShowSignature = NO;
            shouldShowSubmit = NO;
            editable = NO;
                  }
        else {
            if (self.timeSheet.type == 0) {
                shouldShowSignature = NO;
            }
     }
        ratioCount = self.timeSheet.sessionArray.count;
        signatureCount = [self.timeSheet.summary.totur intValue];
        [self setCellEditable:editable];
        if (firstTimeLoading) {
            firstTimeLoading = NO;
            BOOL infoMatch = NO;
            for (int i = 0; i < self.ratioArray.count; i++) {
                RatioInfo* info = [self.ratioArray objectAtIndex:i];
                if (info.ratioId == [self.timeSheet.summary.totur floatValue]) {
                    infoMatch = YES;
                    self.rotioField.text = info.type;
                }
            }
            if (!infoMatch) {
                self.rotioField.text = self.timeSheet.summary.totur;
            }
            infoMatch = NO;
            for (int i = 0; i < self.subjectArray.count; i++) {
                SubjectInfo* subject = [self.subjectArray objectAtIndex:i];
                if (subject.subjectId == [self.timeSheet.summary.subjectId intValue]) {
                    infoMatch = YES;
                    self.subjectField.text = subject.subjectName;
                }
            }
            if (!infoMatch) {
                self.subjectField.text = self.timeSheet.summary.subjectId;
                if (self.subjectArray.count > 0) {
                    SubjectInfo* subject = [self.subjectArray objectAtIndex:0];
                    self.subjectField.text = subject.subjectName;
                }
            }
            self.locationField.text = self.timeSheet.summary.location;
            
        }
        else {
            if (self.rotiaString.length > 0) {
                signatureCount = [[self.rotiaString substringToIndex:1] intValue];
            }
        }
    }
    else {
        if (self.rotiaString.length > 0) {
            signatureCount = [[self.rotiaString substringToIndex:1] intValue];
        }
        else {
            [self setDefaultSelection];
            if (self.rotiaString.length > 0) {
                signatureCount = [[self.rotiaString substringToIndex:1] intValue];
            }
        }
        self.statusView.hidden = YES;
    }
    if (signatureCount==1) {
        for(int i=0;i<SharedAppDelegate.studentArray.count;i++)
        {
            StudentInfo *studentinfo=[SharedAppDelegate.studentArray objectAtIndex:i];
            if(studentinfo.studentId<0)
            {
                [SharedAppDelegate.studentArray removeObjectAtIndex:i];
            }
            
        }
    }else {
        BOOL NewNostudent=YES;
        for(int i=0;i<SharedAppDelegate.studentArray.count;i++)
        {
            StudentInfo *studentinfo=[SharedAppDelegate.studentArray objectAtIndex:i];
            if(studentinfo.studentId<0)
            {
                NewNostudent= false;
            }
            
        }
        if (NewNostudent==true) {
            StudentInfo *studentinfo=[[StudentInfo alloc] init];
            studentinfo.studentName=@"No Student";
            studentinfo.studentId=-1;
            if (SharedAppDelegate.studentArray<=0) {
                SharedAppDelegate.studentArray=[NSMutableArray arrayWithCapacity:0];
                [SharedAppDelegate.studentArray addObject:studentinfo ];
                
            }else
            {
                [SharedAppDelegate.studentArray insertObject:studentinfo atIndex:(SharedAppDelegate.studentArray.count)];
                
            }
        }
        
    }
    for (UIView* view in self.scrollView.subviews) {
        if (view.tag >= 100){
            if (view.tag == 100) {
                [self.recycledTimeViews addObject:view];
            }
            else{
                [self.recycledSignatureView addObject:view];
            }
            [view removeFromSuperview];
        }
    }
    if (!shouldShowSignature) {
        if(self.isQuery)
        {
            if([self.timeSheetSummary.timeSheetState isEqualToString:STATUS_DRAFT])
            {
                
                currentY=HEIGHT(201);
            }
            else
            {
                currentY=HEIGHT(50);
            }
        }
        else
        {
            currentY=HEIGHT(241);
        }
        
        NSArray* stArray = nil;
        NSArray* noshowArray=nil;
        if (self.timeSheetSummary && self.timeSheetSummary.students.length > 0) {
            stArray = [self.timeSheetSummary.students componentsSeparatedByString:@","];
            if (!stArray) {
                stArray = [NSArray arrayWithObject:self.timeSheetSummary.students];
            }
            self.timeSheetSummary.students = nil;
        }
        
        if (self.timeSheet.summary ) {
            noshowArray = [self.timeSheet.summary.noshow componentsSeparatedByString:@","];
            if (!noshowArray) {
                noshowArray = [NSArray arrayWithObject:self.timeSheet.summary.noshow];
            }
        }
        self.btnContainerView.hidden = YES;
        for (int i = 0; i < signatureCount; i++) {
            SignatureView *signatureView = nil;
            if (self.recycledSignatureView.count > 0) {
                signatureView = [self.recycledSignatureView objectAtIndex:0];
                [self.recycledSignatureView removeObject:signatureView];
                if (shouldResetAllSubviews) {
                    [signatureView reset];
                }
            }
            else {
                NSArray* arraySig = [[UINib nibWithNibName:@"SignatureView" bundle:nil] instantiateWithOwner:self options:nil];
                signatureView = [arraySig objectAtIndex:0];
            }
            [signatureView setCellEditable:editable];
            signatureView.tag = 100 + 1 + i;
            signatureView.LoadTimesheet=self.isQuery;
            signatureView.studentArray = SharedAppDelegate.studentArray;
            signatureView.NoShowArray=SharedAppDelegate.NoShowArray;
            signatureView.mDelegate = self;
            signatureView.frame = CGRectMake(0,HEIGHT(140), SCREEN_WIDTH , signatureView.frame.size.height);
            contentHeight+=signatureView.frame.size.height;
            
            if (![self.timeSheetSummary.timeSheetState isEqualToString:STATUS_DRAFT]) {
                signatureView.NoShowSwitch.enabled=false;
                signatureView.NoShowSwitch.hidden=true;
            }
            if (stArray.count > i) {
                signatureView.studentField.text = [stArray objectAtIndex:i];
                
            }else {
                for(int j=0;j<SharedAppDelegate.studentArray.count;j++) {
                    StudentInfo *studentinfo=[SharedAppDelegate.studentArray objectAtIndex:j];
                    if (studentinfo.studentId<0) {
                        signatureView.studentField.text = studentinfo.studentName;
                    }
                }
            }
            if (noshowArray.count>i) {
                for (int j=0;j<SharedAppDelegate.NoShowArray.count;j++){
                    NoShowInfo *noshowinfo=[SharedAppDelegate.NoShowArray objectAtIndex:j];
                    if ([noshowinfo.NoShowValue isEqualToString:[noshowArray objectAtIndex:i]]) {
                        if ([noshowinfo.NoShowValue isEqualToString:@"N"]) {
                            signatureView.NoShowSwitch.on=false;
                            
                        }else
                        {
                            signatureView.NoShowSwitch.on=true;
                        }
                        
                    }
                }
                
                
            }
            
            if (signatureCount == 1) {
                [signatureView setPosition:0];
            }
            else{
                if (i == 0) {
                    [signatureView setPosition:1];
                }
                else if (i == signatureCount - 1) {
                    [signatureView setPosition:3];
                }
                else {
                    [signatureView setPosition:2];
                }
            }
            
            [self.scrollView addSubview:signatureView];
            currentY += signatureView.frame.size.height;
        }
        if (signatureCount) {
            currentY += 10;
        }
    }
    if (shouldShowSignature) {
        currentY=HEIGHT(86);
        if([self.timeSheetSummary.timeSheetState isEqualToString:STATUS_DRAFT]) {
            currentY=HEIGHT(126);
        }
        for (int i = 0; i < signatureCount; i++) {
            SignatureView *signatureView = [[SignatureView alloc]init];;
            if (self.recycledSignatureView.count > 0) {
                signatureView = [self.recycledSignatureView objectAtIndex:0];
                [self.recycledSignatureView removeObject:signatureView];
                if (shouldResetAllSubviews) {
                    [signatureView reset];
                }
            }
            else {
                NSArray* arraySig = [[UINib nibWithNibName:@"SignatureView" bundle:nil] instantiateWithOwner:self options:nil];
                signatureView = [arraySig objectAtIndex:0];
            }
            
            signatureView.tag = 100 + 1 + i;
            signatureView.LoadTimesheet=self.isQuery;
            signatureView.studentArray = SharedAppDelegate.studentArray;
            signatureView.NoShowArray=SharedAppDelegate.NoShowArray;
            signatureView.mDelegate = self;
            signatureView.NoShowSwitch.on = NO;
            signatureView.frame = CGRectMake(0,currentY + HEIGHT(10), SCREEN_WIDTH, signatureView.frame.size.height);
            [self.scrollView addSubview:signatureView];
            contentHeight+=signatureView.frame.size.height;
            currentY += signatureView.frame.size.height + HEIGHT(5);
            if(SharedAppDelegate.studentArray.count<=1)
            {
                for(int j=0;j<SharedAppDelegate.studentArray.count;j++)
                {
                    StudentInfo *studentinfo=[SharedAppDelegate.studentArray objectAtIndex:j];
                    if (studentinfo.studentId<0) {
                        signatureView.studentField.text = studentinfo.studentName;
                    }
                }
            }
        }
        
    }
    self.headerInfoView.frame=CGRectMake(0,currentY + HEIGHT(10),SCREEN_WIDTH, self.headerInfoView.frame.size.height);
    currentY += self.headerInfoView.frame.size.height +HEIGHT(20);
    for (int i = 0; i < ratioCount; i++) {
        TimeView* timeView = nil;
        if (self.recycledTimeViews.count > 0) {
            timeView = [self.recycledTimeViews objectAtIndex:0];
            [self.recycledTimeViews removeObject:timeView];
        }
        else {
            NSArray* array = [[UINib nibWithNibName:@"TimeView" bundle:nil] instantiateWithOwner:self options:nil];
            timeView = [array objectAtIndex:0];
        }
        if (shouldResetAllSubviews) {
            [timeView reset];
        }
        
        timeView.frame = CGRectMake(0, currentY,SCREEN_WIDTH, timeView.frame.size.height);
        timeView.tag = 100;
        [self.scrollView addSubview:timeView];
        [self.headerInfoView removeFromSuperview];
        [self.scrollView addSubview:self.headerInfoView];
        if (self.timeSheet && self.timeSheet.sessionArray.count > i) {
            [timeView reset];
            TimeSheetSession* session = [self.timeSheet.sessionArray objectAtIndex:i];
            [timeView setDate:session.date];
            [timeView setDuration:session.duration];
            [timeView setNote:session.note];
            
        }
        [timeView setCellEditable:editable];
        timeView.mDelegate = self;
        currentY += timeView.frame.size.height + 10;
        contentHeight+=timeView.frame.size.height;
    }
    
    if (shouldShowSubmit) {
        self.btnContainerView.hidden = NO;
        self.btnContainerView.frame = CGRectMake(0, currentY, SCREEN_WIDTH, self.btnContainerView.frame.size.height);
        currentY += self.btnContainerView.frame.size.height;
    }
    else {
        self.btnContainerView.hidden = YES;
    }
    
    
    
    shouldResetAllSubviews = NO;
    self.scrollView.contentSize = CGSizeMake(0, contentHeight);
    //TTLog(@"self.mScrollView.frame.size.height-1-:%f",  self.mScrollView.frame.size.height);
    [self signatureView:nil studentSelected:nil studentId:nil];

}


#pragma mark - SignatureViewDelegate method
//点击签名
- (void)signatureViewTaped:(SignatureView *)signview {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BCTabBarController *tab =  (BCTabBarController *)app.window.rootViewController.presentedViewController;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    tab.tabBar.hidden=YES;
    [self.scrollView touchesEnded:nil withEvent:nil];
    currentSigningView = signview;
    self.popoverView.hidden = NO;
    [self.view bringSubviewToFront:self.popoverView];
    self.signContainerView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    self.signContainerView.alpha = 0.1f;
    [UIView animateWithDuration:0.2f animations:^{
        self.signContainerView.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.signContainerView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            self.signContainerView.transform = CGAffineTransformMakeScale(0.92f, 0.92f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f animations:^{
                self.signContainerView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                NSString *deviceType=[UIDevice currentDevice].model;
                if ([deviceType isEqualToString:@"iPad"])
                {
                    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    BCTabBarController *tab =  (BCTabBarController *)app.window.rootViewController.presentedViewController;
                    //tab.tabBar.hidden=YES;
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
                    {
                        [tab.tabBar setFrame:CGRectMake(0, SCREEN_HEIGHT, 0, 0)];
                    }else
                    {
                        [tab.tabBar setFrame:CGRectMake(0, SCREEN_HEIGHT-20, 0, 0)];
                    }
                    
                    
                    self.signContainerView.frame=CGRectMake(-170,120 , self.view.frame.size.height+60, 470);
                    self.smothBackImageView.frame=CGRectMake(0, -20, self.view.frame.size.height+10, 350);
                    self.signView.frame=CGRectMake(0, -20, self.view.frame.size.height+10, 470);
                }
                else
                {
                    if ([[[UIDevice currentDevice] systemVersion]floatValue]>=7.0) {
                            if (isRetina) {
                            self.signContainerView.frame=CGRectMake(-170, 120, self.view.frame.size.height+20, 470);
                            self.smothBackImageView.frame=CGRectMake(0, 10, self.view.frame.size.height+10, 350);
                            self.signView.frame=CGRectMake(0, 10, self.view.frame.size.height+10, 470);
                            
                        }
                        
                        else
                        {
                            self.signContainerView.frame=CGRectMake(-170, 120, self.view.frame.size.height+20, 470);
                            self.smothBackImageView.frame=CGRectMake(0, 10, self.view.frame.size.height+10, 350);
                            self.signView.frame=CGRectMake(0, 10, self.view.frame.size.height+10, 470);
                        }
                        
                    }
                    else
                    {
                        self.signContainerView.frame=CGRectMake(-170, 120, self.view.frame.size.height, 470);
                        
                        self.smothBackImageView.frame=CGRectMake(0, 10, self.view.frame.size.height+10, 350);
                        self.signView.frame=CGRectMake(0, 10, self.view.frame.size.height+10, 470);
                    }
                    
                }
                
                self.signContainerView.transform= CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
            }];
        }];
    }];
 

}
#pragma mark --  signatureView
//Student Select  学生选择1-1服务的时候 出现一个学生列表 如果选择的是3-1那么选择三个学生列表  默认是1-1的学生列表
- (void)signatureView:(SignatureView *)signView studentSelected:(NSString *)studentName studentId:(NSInteger)studentId
{
    NSMutableArray* sigViewArray = [NSMutableArray array];
    for (UIView* view in self.scrollView.subviews) {
        if (view.tag > 100) {
            [sigViewArray addObject:view];
        }
    }
    if (sigViewArray.count == 0) {
        return;
    }
    NSArray* stArray = nil;
    NSArray* noArray = nil;
    if (self.timeSheet && !localTimeSheetUsed) {
        
        stArray = [self.timeSheet.summary.students componentsSeparatedByString:@","];
        if (!stArray && self.timeSheet.summary.students.length > 0) {
            stArray = [NSArray arrayWithObject:self.timeSheet.summary.students];
        }
        noArray=[self.timeSheet.summary.noshow componentsSeparatedByString:@","];
        if (!noArray&&self.timeSheet.summary.noshow.length>0) {
            noArray=[NSArray arrayWithObject:self.timeSheet.summary.noshow];
        }
        //        self.timeSheet = nil;
        localTimeSheetUsed = YES;
        for (int i = 0; i < sigViewArray.count; i ++) {
            SignatureView* sig = [sigViewArray objectAtIndex:i];
            NSInteger index = sig.tag - 1 - 100;
            if (stArray.count > index) {
                //Student
                for (int j = 0; j < SharedAppDelegate.studentArray.count; j++) {
                    StudentInfo* info = [SharedAppDelegate.studentArray objectAtIndex:j];
                    
                    
                    NSInteger stuid = [[stArray objectAtIndex:index] intValue];
                    NSString* noshowstring=[noArray objectAtIndex:index];
                    if (stuid == info.studentId) {
                        
                        sig.studentField.text = info.studentName;
                        
                        //No Show
                        if ([noshowstring isEqualToString:@"N"]) {
                           
                            sig.NoShowSwitch.on=YES;
                        }else if ([noshowstring isEqualToString:@"Y"])
                        {
                            sig.NoShowSwitch.on=NO;
                         
                        }
                        
                    }
                    else
                    {
                        if(stuid<0)
                        {
                            sig.studentField.text = @"No Student";
                            sig.NoShowSwitch.on=false;
                         
                        }
                    }
                }
                
                
            }
        }
    }
    if (!signView) {
        signView = [sigViewArray objectAtIndex:0];
        studentName = signView.studentField.text;
    }
    for (int i = 0; i < sigViewArray.count; i++) {
        UIView* mView = [sigViewArray objectAtIndex:i];
        if (mView.tag != signView.tag) {
            SignatureView* sigView = (SignatureView*)mView;
            //herry delegate because 3-1 student not correct   date 2015-1-4
            
            if ([sigView.studentField.text isEqualToString:studentName]&&sigView.studentFieldId==studentId&&studentId>0)
            {
                BOOL infoSet = NO;
                for (int j = 0; j < SharedAppDelegate.studentArray.count; j++) {
                    StudentInfo* student = [SharedAppDelegate.studentArray objectAtIndex:j];
                    BOOL hasSame = NO;
                    for (int k = 0; k < sigViewArray.count; k ++) {
                        SignatureView* sig = [sigViewArray objectAtIndex:k];
                        if (sig == sigView) {
                            continue;
                        }
                        if ([student.studentName isEqualToString:sig.studentField.text]) {
                            hasSame = YES;
                        }
                    }
                    if (!hasSame) {
                        sigView.studentField.text = student.studentName;
                        sigView.studentFieldId=student.studentId;
                        infoSet = YES;
                        break;
                    }
                }
                if (!infoSet) {
                    sigView.studentField.text = nil;
                    sigView.studentFieldId=nil;
                }
                //herry delegate because 3-1 student not correct   date 2015-1-4
            }
        }
    }
    
    for (int i = 0; i < sigViewArray.count; i++) {
        SignatureView* sigggg = [sigViewArray objectAtIndex:i];
        
    }
    
    if(self.btnContainerView.hidden==NO)
    {
        for (int i = 0; i < sigViewArray.count; i++) {
            NSMutableArray* deletingArray = [NSMutableArray array];
            NSMutableArray* tempArray = [NSMutableArray arrayWithArray:SharedAppDelegate.studentArray];
            StudentInfo* currentInfo = nil;
            SignatureView* sigView = [sigViewArray objectAtIndex:i];
            for (int j = 0; j < tempArray.count; j++) {
                StudentInfo* info = [tempArray objectAtIndex:j];
                
                for (int k = 0; k < sigViewArray.count; k++) {
                    SignatureView* sig = [sigViewArray objectAtIndex:k];
                    
                    if (([info.studentName isEqualToString:sig.studentField.text])) {
                        if (sig != sigView ) {
                            if(info.studentId>0)
                            {
                                [deletingArray addObject:info];
                            }else
                            {
                                if(sigView.studentFieldId==0)
                                {
                                    currentInfo = info;
                                }
                            }
                        }
                        else {
                            currentInfo = info;
                        }
                    }else
                    {
                        if(sigView.studentFieldId==0)
                        {
                            currentInfo = info;
                        }
                    }
                }
            }
            if (!self.isSetStudent) {
                
                for (int j = 0; j < deletingArray.count; j++) {
                    StudentInfo* info = [deletingArray objectAtIndex:j];
                }
                [tempArray removeObjectsInArray:deletingArray];
                
                sigView.studentArray = tempArray;
                [sigView setStudentArray:tempArray selectedContent:currentInfo.studentId];
            }
            
        }
        self.isSetStudent=NO;
    }
    
    [self setSigViewXY];
    [self NoShowXY];
    
}


- (void)setSubjectAndLocation:(NSString *)subjectName location:(NSString *)location {
    self.subjectName = subjectName;
    self.locationName = location;
    self.subjectField.text = subjectName;
    self.locationField.text = location;

}
//默认一对一 展示学生基本信息
- (void)setSigViewXY {
    NSMutableArray* sigViewArray = [[NSMutableArray alloc]init];
    UIView *timeview=[[UIView alloc]init];
    for (UIView* view in self.scrollView.subviews) {
        if (view.tag > 100) {
            [sigViewArray addObject:view];
        }
        if(view.tag==100)
        {
            timeview=view;
        }
    }
    
    if(self.btnContainerView.hidden==NO && [self.timeSheetSummary.source isEqualToString:@"Web"]!=true)
    {
        for (int i = 0; i < sigViewArray.count; i++) {
            self.siggggg = [sigViewArray objectAtIndex:i];
            NSLog(@"%@",self.studentFiled.text);
            double autoY=self.siggggg.secondPartView.frame.size.height + self.siggggg.lastPartView.frame.size.height + self.siggggg.studentView.frame.size.height;
            if (self.siggggg.studentFieldId<=0 && [self.studentFiled.text isEqualToString:@"No Student"]) {
                if (self.siggggg.frame.size.height>=270){
                    self.siggggg.studentView.hidden=YES;
                    self.siggggg.NoShowarrawImageView.hidden = YES;
                    self.siggggg.frame = CGRectMake(self.siggggg.frame.origin.x, self.siggggg.frame.origin.y + HEIGHT(10) ,SCREEN_WIDTH,self.siggggg.frame.size.height-self.siggggg.studentView.frame.size.height);
                    
                    self.headerInfoView.frame=CGRectMake(self.headerInfoView.frame.origin.x, self.headerInfoView.frame.origin.y-autoY,SCREEN_WIDTH, self.headerInfoView.frame.size.height);
                    
                    timeview.frame=CGRectMake(timeview.frame.origin.x,timeview.frame.origin.y-autoY,SCREEN_WIDTH, timeview.frame.size.height);
                    
                    self.btnContainerView.frame=CGRectMake(self.btnContainerView.frame.origin.x, self.btnContainerView.frame.origin.y-autoY,SCREEN_WIDTH, self.btnContainerView.frame.size.height);
                    self.siggggg.bgImageView.image = [[UIImage imageNamed:@"table_head.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:20];
                    if(i==0&&sigViewArray.count>1){
                        SignatureView* sig1 = [sigViewArray objectAtIndex:1];
                        sig1.frame = CGRectMake(sig1.frame.origin.x, sig1.frame.origin.y-autoY + HEIGHT(10),SCREEN_WIDTH,sig1.frame.size.height);
                        if(sigViewArray.count>2){
                            SignatureView* sig2 = [sigViewArray objectAtIndex:2];
                            sig2.frame = CGRectMake(sig2.frame.origin.x, sig2.frame.origin.y-autoY,SCREEN_WIDTH,sig2.frame.size.height);
                        }
                        
                    }
                    else if(i==1&&sigViewArray.count>1) {
                        if(sigViewArray.count>2){
                            SignatureView* sig2 = [sigViewArray objectAtIndex:2];
                            sig2.frame = CGRectMake(sig2.frame.origin.x, sig2.frame.origin.y-autoY,SCREEN_WIDTH,sig2.frame.size.height);
                            
                        }
                    }
                    else if(i==2) {
                        // Buttoin CGRectMake
                    }
                    
                }
            }
            else {
                if (self.siggggg.frame.size.height<87){
                    self.siggggg.studentView.hidden=NO;
                    self.siggggg.NoShowarrawImageView.hidden = NO;
                    self.siggggg.frame = CGRectMake(self.siggggg.frame.origin.x, self.siggggg.frame.origin.y+HEIGHT(10),SCREEN_WIDTH,self.siggggg.frame.size.height+autoY);
                    self.headerInfoView.frame=CGRectMake(self.headerInfoView.frame.origin.x, self.headerInfoView.frame.origin.y+autoY,SCREEN_WIDTH, self.headerInfoView.frame.size.height);
                    
                    timeview.frame=CGRectMake(timeview.frame.origin.x,timeview.frame.origin.y+autoY,SCREEN_WIDTH, timeview.frame.size.height);
                    
                    
                    self.btnContainerView.frame=CGRectMake(self.btnContainerView.frame.origin.x, self.btnContainerView.frame.origin.y+autoY,SCREEN_WIDTH, self.btnContainerView.frame.size.height);
                    self.siggggg.bgImageView.image = [[UIImage imageNamed:@"table_part_up.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:20];
                    
                    if(i==0&&sigViewArray.count>1)
                    {
                        
                        SignatureView* sig1 = [sigViewArray objectAtIndex:1];
                        sig1.frame = CGRectMake(sig1.frame.origin.x, sig1.frame.origin.y+autoY+HEIGHT(10),SCREEN_WIDTH,sig1.frame.size.height);
                        //self.mScrollView.contentSize = CGSizeMake(0, self.mScrollView.frame.size.height+213);
                        if(sigViewArray.count>2)
                        {
                            SignatureView* sig2 = [sigViewArray objectAtIndex:2];
                            sig2.frame = CGRectMake(sig2.frame.origin.x, sig2.frame.origin.y+autoY+HEIGHT(10),SCREEN_WIDTH,sig2.frame.size.height);
                            //self.mScrollView.contentSize = CGSizeMake(0, self.mScrollView.frame.size.height+213);
                        }
                        
                    }
                    else if(i==1&&sigViewArray.count>1)
                    {
                        if(sigViewArray.count>2)
                        {
                            SignatureView* sig2 = [sigViewArray objectAtIndex:2];
                            sig2.frame = CGRectMake(sig2.frame.origin.x, sig2.frame.origin.y+autoY+HEIGHT(10),SCREEN_WIDTH,sig2.frame.size.height);
                        }
                    }
                    else if(i==2)
                    {
                    }
                    
                }
                
            }
        }}
}
// noShow按钮点击后的方法
-(void)NoShowXY
{
    NSMutableArray* sigViewArray = [NSMutableArray array];
    UIView *timeview=[[UIView alloc]init];
    for (UIView* view in self.scrollView.subviews) {
        if (view.tag > 100) {
            [sigViewArray addObject:view];
        }
        if(view.tag==100)
        {
            timeview=view;
        }
    }
    if(self.btnContainerView.hidden==NO && [self.timeSheetSummary.source isEqualToString:@"Web"]!=true) {
        for (int i = 0; i < sigViewArray.count; i++) {
            self.siggggg = [sigViewArray objectAtIndex:i];
            CGFloat autoY = self.siggggg.secondPartView.frame.size.height + self.siggggg.lastPartView.frame.size.height;
            if (self.siggggg.studentFieldId >= 0 || self.siggggg.studentFieldId == -1) {
                if (self.siggggg.NoShowSwitch.on == YES) {
                    if (self.siggggg.frame.size.height >= 270) {
                        self.siggggg.studentView.hidden = YES;
                        self.siggggg.frame = CGRectMake(self.siggggg.frame.origin.x, self.siggggg.frame.origin.y, SCREEN_WIDTH, self.siggggg.frame.size.height - autoY);
                        self.btnContainerView.frame = CGRectMake(self.btnContainerView.frame.origin.x, self.btnContainerView.frame.origin.y - autoY, SCREEN_WIDTH, self.btnContainerView.frame.size.height);
                        self.headerInfoView.frame = CGRectMake(self.headerInfoView.frame.origin.x, self.headerInfoView.frame.origin.y - autoY, SCREEN_WIDTH, self.headerInfoView.frame.size.height);
                        timeview.frame = CGRectMake(timeview.frame.origin.x, timeview.frame.origin.y - autoY,SCREEN_WIDTH, timeview.frame.size.height);
                        self.siggggg.NoShowarrawImageView.image = [[UIImage imageNamed:@"table_part_bottom"] stretchableImageWithLeftCapWidth:100 topCapHeight:20];
                        if (i == 0 && sigViewArray.count >1) {
                            SignatureView *sign1 = [sigViewArray objectAtIndex:1];
                            sign1.frame = CGRectMake(sign1.frame.origin.x, sign1.frame.origin.y - autoY, SCREEN_WIDTH, sign1.frame.size.height);
                            if (sigViewArray.count > 2) {
                                SignatureView * sign2 = [sigViewArray objectAtIndex:2];
                                sign2.frame = CGRectMake(sign2.frame.origin.x, sign2.frame.origin.y - autoY,SCREEN_WIDTH, sign2.frame.size.height);
                            }
                         
                        } else if (i==1 &&sigViewArray.count >1) {
                                SignatureView * sign2 = [sigViewArray objectAtIndex:2];
                                sign2.frame = CGRectMake(sign2.frame.origin.x, sign2.frame.origin.y - autoY,SCREEN_WIDTH, sign2.frame.size.height);
                        }else if (i ==2 &&sigViewArray.count >1) {
                         
                        
                        }
                        
                    }
                   
                }else if (self.siggggg.NoShowSwitch.on == NO) {
                   NSInteger height = self.siggggg.frame.size.height;
                    if (height<= 87) {
                        self.siggggg.studentView.hidden = NO;
                        self.siggggg.frame = CGRectMake(self.siggggg.frame.origin.x, self.siggggg.frame.origin.y, SCREEN_WIDTH, self.siggggg.frame.size.height + autoY);
                        self.btnContainerView.frame = CGRectMake(self.btnContainerView.frame.origin.x, self.btnContainerView.frame.origin.y + autoY, SCREEN_WIDTH, self.btnContainerView.frame.size.height);
                        self.headerInfoView.frame = CGRectMake(self.headerInfoView.frame.origin.x, self.headerInfoView.frame.origin.y + autoY, SCREEN_WIDTH, self.headerInfoView.frame.size.height);
                        timeview.frame = CGRectMake(timeview.frame.origin.x, timeview.frame.origin.y +autoY,SCREEN_WIDTH, timeview.frame.size.height);
                        self.siggggg.NoShowarrawImageView.image = [UIImage imageNamed:@"table_part_center_up.png"];

                        if (i == 0 && sigViewArray.count >1) {
                            SignatureView *sign1 = [sigViewArray objectAtIndex:1];
                            sign1.frame = CGRectMake(sign1.frame.origin.x, sign1.frame.origin.y + autoY, SCREEN_WIDTH, sign1.frame.size.height);
                            if (sigViewArray.count > 2) {
                                SignatureView * sign2 = [sigViewArray objectAtIndex:2];
                                sign2.frame = CGRectMake(sign2.frame.origin.x, sign2.frame.origin.y + autoY,SCREEN_WIDTH, sign2.frame.size.height);
                            }
                            
                        } else if (i==1 &&sigViewArray.count >1) {
                            SignatureView * sign2 = [sigViewArray objectAtIndex:2];
                            sign2.frame = CGRectMake(sign2.frame.origin.x, sign2.frame.origin.y + autoY,SCREEN_WIDTH, sign2.frame.size.height);

                        }else if (i ==2 &&sigViewArray.count >1) {
                            
                            
                        }
                        
                    }
                }
            }
        }
    }

}
- (void)setDefaultSelection
{
    if (self.studentArray.count > 0) {
        StudentInfo* info = [self.studentArray objectAtIndex:0];
        self.siggggg.studentField.text = info.studentName;
        studentFieldId=info.studentId;
        //studentField.text = @"uuuusfsf";
    }
    if (self.subjectArray.count > 0) {
        SubjectInfo* subject = [self.subjectArray objectAtIndex:0];
        self.subjectField.text = subject.subjectName;
    }
    if (self.ratioArray.count > 0) {
        RatioInfo* info = [self.ratioArray objectAtIndex:0];
        self.rotioField.text = info.type;
        self.rotiaString = info.type;
    }
    if (self.locationArray.count > 0) {
        LocationInfo* info = [self.locationArray objectAtIndex:0];
        self.locationField.text = info.locName;
    }
    
}
-(void)loadNoShowInfo{
    NoShowInfo* infoNo=[[NoShowInfo alloc] init];
    infoNo.NoShowString=@"No";
    infoNo.NoShowValue=@"N";
    NoShowInfo *infoYes=[[NoShowInfo alloc] init];
    infoYes.NoShowString=@"Yes";
    infoYes.NoShowValue=@"Y";
    NSMutableArray *NoShowArray=[[NSMutableArray alloc ]init];
    [NoShowArray addObject:infoNo];
    [NoShowArray addObject:infoYes];
    SharedAppDelegate.NoShowArray =NoShowArray;
    for (UIView* view in self.scrollView.subviews) {
        if (view.tag > 100) {
            SignatureView* sign = (SignatureView*)view;
            sign.NoShowArray = SharedAppDelegate.NoShowArray;
        }
        //}
    }
}
- (void)loadStudentInfo
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password", nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_TIMESHEET_STUDENT parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         SharedAppDelegate.studentArray = [StudentInfo studentsArrayWithDDXMLDocument:XMLDocument];
         if (SharedAppDelegate.studentArray.count>1&&self.isQuery==NO) {
             for(int i=0;i<SharedAppDelegate.studentArray.count;i++)
             {
                 StudentInfo *studentinfo=[SharedAppDelegate.studentArray objectAtIndex:i];
                 if(studentinfo.studentId<0)
                 {
                     [SharedAppDelegate.studentArray removeObjectAtIndex:i];
                 }
                 
             }
         }
         
         for (UIView* view in self.scrollView.subviews) {
             if (view.tag > 100) {
                 SignatureView* sign = (SignatureView*)view;
                 sign.studentArray = SharedAppDelegate.studentArray;
             }
         }
    [self setSigViewXY];
       
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
            [self hiddenHUD];
     }];
        [operation start];
        [self showHUD];
}

- (void)loadTimeSheet
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.timeSheetSummary.timeSheetId, @"ts_id",
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password", nil];
    NSString* function = FUNC_TIMESHEET_MOBILE_DETAIL;
    NSInteger type = 1;
    if ([self.timeSheetSummary.source isEqualToString:@"Web"]) {
        type = 0;
        function = FUNC_TIMESHEET_WEB_DETAIL;
    }
    NSMutableURLRequest *request = [client requestWithFunction:function parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         self.timeSheet = [TimeSheet timeSheetWithXMLDoc:XMLDocument type:type];
         if (!self.timeSheet) {
             [self showAlertWithTitle:nil andMessage:@"Error!"];
         }
         [self relayoutSubviews];
     }
          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
              [self hiddenHUD];
            }];
    [operation start];
    [self showHUD];
}

- (void)initSubviews
{
    self.siggggg.studentField.inputAccessoryView = self.toolBar;
    self.siggggg.studentField.inputAccessoryView = self.toolBar;
    self.subjectField.inputAccessoryView = self.toolBar;
    self.rotioField.inputAccessoryView = self.toolBar;
    self.locationField.inputAccessoryView = self.toolBar;
    self.siggggg.studentField.inputView = self.pickerView;
    self.subjectField.inputView = self.pickerView;
    self.rotioField.inputView = self.pickerView;
    self.locationField.inputView = self.pickerView;
    self.recycledSignatureView = [[NSMutableArray alloc]init];
    self.recycledTimeViews = [[NSMutableArray alloc]init];
    self.studentArray = [[NSMutableArray alloc]init];
    self.ratioArray = [[NSMutableArray alloc]init];
    self.subjectArray = [[NSMutableArray alloc]init];
    self.locationArray = [[NSMutableArray alloc]init];
    self.durationArray = [[NSMutableArray alloc]init];
    [self initDatas];
    firstTimeLoading = YES;
}

- (void)initDatas
{
    int unSetCount = 0;
    if (self.ratioArray.count == 0) {
        unSetCount ++;
        self.ratioArray = SharedAppDelegate.totioArray;
    }
    if (self.locationArray.count == 0) {
        unSetCount ++;
        self.locationArray = SharedAppDelegate.locationArray;
    }
    if (self.durationArray.count == 0) {
        unSetCount ++;
        self.durationArray = SharedAppDelegate.durationArray;
    }
    if (self.subjectArray.count == 0) {
        unSetCount ++;
        self.subjectArray = SharedAppDelegate.subjectArray;
    }
    if (unSetCount > 0 && !self.timeSheetSummary) {
        [self relayoutSubviews];
    }
    self.nameLabel.text = SharedAppDelegate.currentUserInfo.userFullName;
  
    if(SharedAppDelegate.imageStr.length>0)
    {
        UIImage *userImage = [Photo string2Image:SharedAppDelegate.imageStr];
        self.avatarImageView.image = userImage;
    }
//    NSLog(@"self.ratioArray=======%@   %@   %@  %@",self.ratioArray,self.locationArray,self.durationArray,self.subjectArray);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initDatas) name:NOTIFICATION_LOAD_DURATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initDatas) name:NOTIFICATION_LOAD_FULLNAME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initDatas) name:NOTIFICATION_LOAD_LOCATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initDatas) name:NOTIFICATION_LOAD_TOTIO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initDatas) name:NOTIFICATION_LOAD_SUBJECT object:nil];
    [self initDatas];
    if (SharedAppDelegate.shouldReloadMutableData) {
        [self loadStudentInfo];
        [self loadNoShowInfo];
        SharedAppDelegate.shouldReloadMutableData = YES;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (editingRow == 1) {
        if (self.subjectArray.count > row) {
            SubjectInfo* subject = [self.subjectArray objectAtIndex:row];
            self.subjectField.text = subject.subjectName;
        }
    }
    else if (editingRow == 2) {
        if (self.ratioArray.count > row) {
            RatioInfo* ratio = [self.ratioArray objectAtIndex:row];
            self.rotioField.text = ratio.type;
            self.rotiaString = self.rotioField.text;
            [self performSelector:@selector(relayoutSubviews) withObject:nil afterDelay:0.5f];
        }
    }
    else if (editingRow == 3) {
        if (self.locationArray.count > 0) {
            LocationInfo* location = [self.locationArray objectAtIndex:row];
            self.locationField.text = location.locName;
        }
    }
    else if (editingRow == 0) {
        //        StudentInfo* student = [self.studentArray objectAtIndex:row];
        //        studentField.text = student.studentName;
    }
}

#pragma mark - UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (editingRow == 1) {
        if (self.subjectArray.count > 0) {
            SubjectInfo* subject = [self.subjectArray objectAtIndex:row];
            return subject.subjectName;
        }
    }
    else if (editingRow == 2) {
        if (self.ratioArray.count > 0) {
            RatioInfo* ratio = [self.ratioArray objectAtIndex:row];
            return ratio.type;
        }
    }
    else if (editingRow == 3) {
        if (self.locationArray.count > row) {
            LocationInfo* location = [self.locationArray objectAtIndex:row];
            return location.locName;
        }
    }
    else if (editingRow == 0) {
        //        StudentInfo* info = [self.studentArray objectAtIndex:row];
        //        return info.studentName;
    }
    return @"";
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (editingRow == 1) {
        if (self.subjectArray.count > 0) {
            return self.subjectArray.count;
        }
        return 1;
    }
    else if (editingRow == 2) {
        if (self.ratioArray.count > 0) {
            return self.ratioArray.count;
        }
        return 1;
    }
    else if (editingRow == 3) {
        if (self.locationArray.count > 0) {
            return self.locationArray.count;
        }
        return 1;
    }
    else if (editingRow == 0) {
        return self.studentArray.count;
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.pickerView.hidden= NO;
    self.toolBar.hidden = NO;
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    BCTabBarController *tab = (BCTabBarController *)app.window.rootViewController.presentedViewController;
    [self.siggggg.studentField resignFirstResponder];
    [self.subjectField resignFirstResponder];
    [self.rotioField resignFirstResponder];
    [self.locationField resignFirstResponder];
    [self.siggggg.passwordField resignFirstResponder];
    TimeView *timeView = [[TimeView alloc]init];
    [timeView.dateField resignFirstResponder];
    [timeView.timeField resignFirstResponder];
    [timeView.durationField resignFirstResponder];
    [timeView.noteTextView resignFirstResponder];
    editingRow = textField.tag;
    if (editingRow == 1) {
        tab.tabBar.hidden = YES;
        if (self.subjectArray.count == 0) {
            self.subjectArray = SharedAppDelegate.subjectArray;
        }
        [self.pickerView reloadAllComponents];
        if (self.subjectField.text.length > 0) {
            for (int i = 0; i < SharedAppDelegate.subjectArray.count; i++) {
                SubjectInfo* subject = [SharedAppDelegate.subjectArray objectAtIndex:i];
                if ([self.subjectField.text isEqualToString:subject.subjectName]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
        }
    }
    else if (editingRow == 2) {
        tab.tabBar.hidden = YES;
        if (self.ratioArray.count == 0) {
            self.ratioArray = SharedAppDelegate.totioArray;
        }
        [self.pickerView reloadAllComponents];
        if (self.rotioField.text.length > 0) {
            for (int i = 0; i < SharedAppDelegate.totioArray.count; i++) {
                RatioInfo* subject = [SharedAppDelegate.totioArray objectAtIndex:i];
                if ([self.rotioField.text isEqualToString:subject.type]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
        }
    }
    else if (editingRow == 3) {
        tab.tabBar.hidden = YES;
        if (self.locationArray.count == 0) {
            self.locationArray = SharedAppDelegate.locationArray;
        }
        [self.pickerView reloadAllComponents];
        if (self.locationField.text.length > 0) {
            for (int i = 0; i < SharedAppDelegate.locationArray.count; i++) {
                LocationInfo* subject = [SharedAppDelegate.locationArray objectAtIndex:i];
                if ([self.locationField.text isEqualToString:subject.locName]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
        }
        else {
            if (self.locationArray.count > 0) {
                [self.pickerView selectRow:0 inComponent:0 animated:YES];
            }
        }
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
// Returns interface orientation masks.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    return YES;
}
@end
