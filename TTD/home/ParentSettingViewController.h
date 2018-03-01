//
//  ParentSettingViewController.h
//  TTD
//
//  Created by andy on 13-9-4.
//  Copyright (c) 2013年 totem. All rights reserved.
//fghfghn
 
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ParentSettingViewController : BaseViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate>
- (IBAction)btnVibrations:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *outletVibrations;
@property (weak, nonatomic) IBOutlet UISwitch *mySwich;
- (IBAction)setVoiceChangeed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewSetVoice;
@property (weak, nonatomic) IBOutlet UIScrollView *myscrollerview;
- (IBAction)btnSignOut:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
- (IBAction)btnchange:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *outletBtnSetPhoto;
//- (IBAction)btnSetPhoto:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewNameBtns;
@property (weak, nonatomic) IBOutlet UIButton *outletBtnSaveName;
@property (weak, nonatomic) IBOutlet UIButton *outletBtnSavePassword;
@property (weak, nonatomic) IBOutlet UIView *viewPasswordBtns;
@property (weak, nonatomic) IBOutlet UIButton *outletBtnCancelName;
@property (weak, nonatomic) IBOutlet UIButton *outletBtnCancelPassword;

- (IBAction)btnSavePassword:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblConfirPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrPassword;
- (IBAction)btnSaveName:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirName;
@property (weak, nonatomic) IBOutlet UILabel *lblCofirName;
@property (weak, nonatomic) IBOutlet UITextField *txtNewName;
@property (weak, nonatomic) IBOutlet UILabel *lblNewName;


@property (weak, nonatomic) IBOutlet UIView *viewPassword;
@property (weak, nonatomic) IBOutlet UIView *viewName;

@property(nonatomic, retain) UIImage *photo;
@property (strong, nonatomic) NSMutableArray* photoArray;
@property (strong, nonatomic) NSString* photoString;

@property (weak, nonatomic) IBOutlet UILabel *lblAppVersion;

@end
