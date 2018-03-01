//
//  ZNNewParentViewController.h
//  TTD
//
//  Created by 张楠 on 2018/2/3.
//  Copyright © 2018年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ZNNewParentViewController : BaseViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *myroeid;
@property (weak, nonatomic) IBOutlet UITextField *myname;

@property (weak, nonatomic) IBOutlet UIButton *logout;

@property (weak, nonatomic) IBOutlet UIImageView *myicon;
@property (weak, nonatomic) IBOutlet UIButton *iconbtn;
@property (weak, nonatomic) IBOutlet UILabel *myid;
@property (weak, nonatomic) IBOutlet UILabel *mylocation;
@property (weak, nonatomic) IBOutlet UIButton *notificationbtn;
@property (weak, nonatomic) IBOutlet UIButton *securitybtn;
//LocationBut
@property (weak, nonatomic) IBOutlet UILabel *LocationButton;

@property(nonatomic, retain) UIImage *photo;
@property (strong, nonatomic) NSMutableArray* photoArray;
@property (strong, nonatomic) NSString* photoString;

@end
