//
//  NewParentSettingViewController.h
//  TTD
//
//  Created by quakoo on 2017/12/4.
//  Copyright © 2017年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface NewParentSettingViewController : BaseViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate>
//头像
@property (weak, nonatomic) IBOutlet UIImageView *iconIMg;

//身份
@property (weak, nonatomic) IBOutlet UILabel *identityLab;

//姓名
@property (weak, nonatomic) IBOutlet UILabel *NameLab;
@property (weak, nonatomic) IBOutlet UITextField *Nametext;

//ID
@property (weak, nonatomic) IBOutlet UILabel *IDlab;
//Location
@property (weak, nonatomic) IBOutlet UILabel *Locationlab;
//Contact
@property (weak, nonatomic) IBOutlet UIImageView *ContactImg;
@property (weak, nonatomic) IBOutlet UILabel *ContactLab;

//IDBut
@property (weak, nonatomic) IBOutlet UIButton *IDbutton;

//LocationBut
@property (weak, nonatomic) IBOutlet UIButton *LocationButton;

//ContactBut
@property (weak, nonatomic) IBOutlet UIButton *ContactButton;

//返回按钮
@property (weak, nonatomic) IBOutlet UIButton *DoneButton;


//拍照按钮
@property (weak, nonatomic) IBOutlet UIButton *CamerButton;


//Log OUT
@property (weak, nonatomic) IBOutlet UIButton *logoubut;



@property(nonatomic, retain) UIImage *photo;
@property (strong, nonatomic) NSMutableArray* photoArray;
@property (strong, nonatomic) NSString* photoString;

@end
