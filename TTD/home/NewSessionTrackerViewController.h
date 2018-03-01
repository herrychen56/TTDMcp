//
//  NewSessionTrackerViewController.h
//  TTD
//
//  Created by Andy on 2017/10/18.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "BaseViewController.h"
#import "SignatureView.h"
#import "TimeView.h"
#import "SmoothLineView.h"
@interface NewSessionTrackerViewController : BaseViewController

//滚动试图
@property (nonatomic, strong) UIScrollView *scrollView;
//用户背景
@property (nonatomic, strong) UIImageView *userImageView;
//用户头像
@property (nonatomic, strong) UIImageView *avatarImageView;
//用户名字
@property (nonatomic, strong) UILabel *nameLabel;
//status view
@property (nonatomic, strong) UIView *statusView;
//status tablePart
@property (nonatomic, strong) UIImageView *tablePartImageView;
//icon-status
@property (nonatomic, strong) UIImageView *iconstatusImageView;
//status
@property (nonatomic, strong) UILabel *status;
//status label
@property (nonatomic, strong) UILabel *statusLabel;
//ration View
@property (nonatomic, strong) UIView *rationView;
//ration Part
@property (nonatomic, strong) UIImageView *firstPartBg;
//icon-ration
@property (nonatomic, strong) UIImageView *iconrationImageView;
//ration
@property (nonatomic, strong) UILabel *ration;
//ration textField
@property (nonatomic, strong) UITextField *rotioField;
//ration 下拉试图
@property (nonatomic, strong) UIImageView *arrowTwoImageView;

//student列表背景
@property (nonatomic, strong) UIImageView *studentImageView;

//按钮背景图
@property (nonatomic, strong) UIView *btnContainerView;
//save按钮
@property (nonatomic, strong) UIButton *saveButton;
//submit按钮
@property (nonatomic, strong) UIButton *submitButton;
//head 详情view
@property (nonatomic, strong) UIView *headerInfoView;
//patImage View
@property (nonatomic, strong) UIView *partView;
//partBottomImageView
@property (nonatomic, strong) UIImageView *partBottomImageView;
//partUpImageView
@property (nonatomic, strong) UIImageView *partUpImageView;
//subject 的 箭头
@property (nonatomic, strong) UIImageView *arrowUp;
//location的箭头
@property (nonatomic, strong) UIImageView *arrowBottom;
//subject的field
@property (nonatomic, strong) UITextField *subjectField;
//location的field
@property (nonatomic, strong) UITextField *locationField;


@property (nonatomic, strong) NSMutableArray *recycledTimeViews;

@property (nonatomic, strong) NSMutableArray *recycledSignatureView;

@property (nonatomic, strong) TimeSheetSummary *timeSheetSummary;

@property (nonatomic, strong) TimeSheet* timeSheet;

@property (nonatomic, strong) NSMutableArray *subjectArray;

@property (nonatomic, strong) NSMutableArray *ratioArray;

@property (nonatomic, copy) NSString *rotiaString;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) SignatureView *siggggg;

@property (nonatomic) BOOL isSetStudent;

@property (nonatomic, strong) NSMutableArray* studentArray;

@property (nonatomic, strong) NSMutableArray *locationArray;

@property (nonatomic, strong) NSMutableArray* durationArray;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIView *toolBar;

@property (nonatomic, copy) NSString *subjectName;

@property (nonatomic, copy) NSString *locationName;

@property (nonatomic, strong) UITextField *studentFiled;

@property (nonatomic) BOOL isQuery;

//签名界面
@property (nonatomic, strong) UIView *popoverView;

@property (nonatomic, strong) UIView *signContainerView;

@property (nonatomic, strong) UIImageView *smothBackImageView;

@property (nonatomic, strong) SmoothLineView *signView;

@property (nonatomic, strong) UIButton *signOkButton;

@property (nonatomic, strong) UIButton *signCancelButton;

@property (nonatomic, strong) UIButton *signRewriteButton;

- (void)setStudentArray:(NSMutableArray *)studentArray autoSelect:(BOOL)autoSelect;
@end
