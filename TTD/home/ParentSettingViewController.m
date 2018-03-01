//
//  ParentSettingViewController.m
//  TTD
//
//  Created by andy on 13-9-4.
//  Copyright (c) 2013年 totem. All rights reserved.
//fhdfh

#import "ParentSettingViewController.h"
#import "DataModel.h"
#import <QuartzCore/QuartzCore.h>
#import "Photo.h"
#import "AppDelegate.h"
#import "BCTabBarController.h"
#import "XMPPHelper.h"
#import "XMPPvCardTemp.h"
@interface ParentSettingViewController ()
@property (nonatomic,strong) XMPPvCardTemp *vcard;
@end

@implementation ParentSettingViewController
@synthesize viewName;
@synthesize viewPassword;
@synthesize lblCofirName;
@synthesize lblCurrPassword;
@synthesize lblNewName;
@synthesize lblConfirPassword;
@synthesize lblNewPassword;
@synthesize txtConfirName;
@synthesize txtCurrPassword;
@synthesize txtConfirPassword;
@synthesize txtNewName;
@synthesize txtNewPassword;
@synthesize viewNameBtns;
@synthesize outletBtnSaveName;
@synthesize outletBtnCancelName;
@synthesize viewPasswordBtns;
@synthesize outletBtnSavePassword;
@synthesize outletBtnCancelPassword;
//@synthesize outletBtnSetPhoto;
@synthesize photo;
@synthesize photoArray;
@synthesize photoImageView;
@synthesize photoString;
@synthesize lblUserName;
//herry20140417
@synthesize myscrollerview;
@synthesize viewSetVoice;
@synthesize mySwich;
@synthesize outletVibrations;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (NSString*)iconImageName
{
    return @"tab_icon_setting.png";
}
- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"btn_logoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(btnSignOut:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStylePlain target:self action:@selector(btnSignOut:)];
    //读取xmppvcard
    self.vcard=[XMPPHelper getmyvcard];
    
   // [self selectLoginInfo];
    if(SharedAppDelegate.imageStr.length>0)
    {
        UIImage *pp=[Photo string2Image:SharedAppDelegate.imageStr];
        photoImageView.image=pp;
    }else
    {
        photoImageView.image=[UIImage imageNamed:@"icon_addPhoto.png"];
    }
    lblUserName.text=[NSString stringWithFormat:@"%@ (%@)", SharedAppDelegate.currentUserInfo.userFullName, SharedAppDelegate.username];
    _lblAppVersion.text = [NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];

    [self hiddenNameAndPassword];
    UITapGestureRecognizer *nameTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handChangeName)];
    
    //在用户名模块创建一个手势对象
    [self.viewName addGestureRecognizer:nameTap];
    //触摸点个数
    [nameTap setNumberOfTouchesRequired:1];
    //点击次数
    [nameTap setNumberOfTapsRequired:1];
    
    UITapGestureRecognizer *passwordTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handChangePassword)];
    
    //在用户名模块创建一个手势对象
    [self.viewPassword addGestureRecognizer:passwordTap];
    //触摸点个数
    [passwordTap setNumberOfTouchesRequired:1];
    //点击次数
    [passwordTap setNumberOfTapsRequired:1];
    
    
    //文本键盘隐藏，设置delegate
    txtNewName.delegate=self;
    txtConfirName.delegate=self;
    txtConfirPassword.delegate=self;
    txtCurrPassword.delegate=self;
    txtNewPassword.delegate=self;
    viewName.tag=001;
    viewPassword.tag=002;
    
    //Set UIView YuanJiao
    
    
    [ParentSettingViewController SetTUIViewLayer:[self.view viewWithTag:1]];
    [ParentSettingViewController SetTUIViewLayer:[self.view viewWithTag:2]];
    [ParentSettingViewController SetTUIViewLayer:[self.view viewWithTag:3]];
    [ParentSettingViewController SetTUIViewLayer:[self.view viewWithTag:4]];
    [ParentSettingViewController SetTUIViewLayer:[self.view viewWithTag:5]];
    
    [ParentSettingViewController SetTextViewLayer:txtConfirPassword];
    [ParentSettingViewController SetTextViewLayer:txtConfirName];
    [ParentSettingViewController SetTextViewLayer:txtCurrPassword];
    [ParentSettingViewController SetTextViewLayer:txtNewName];
    [ParentSettingViewController SetTextViewLayer:txtNewPassword];
    [ParentSettingViewController SetUIButtonLayer:outletBtnSaveName];
    [ParentSettingViewController SetUIButtonLayer:outletBtnSavePassword];
    //herry20140417
    UITapGestureRecognizer *scrollerviewTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollerviewTouch)];
   // [self.myscrollerview addGestureRecognizer:scrollerviewTap];
    //触摸点个数
    [scrollerviewTap setNumberOfTouchesRequired:1];
    
    CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+200);
    self.myscrollerview.delegate=self;
    [self.myscrollerview setContentSize:newSize];
    
    //判断是否有铃声
    NSString* isvoice=[[NSUserDefaults standardUserDefaults] objectForKey:CHAT_VOICE];
    if(isvoice==nil||[isvoice isEqualToString:@"YES"])
    {
        
        [mySwich setOn:YES];
    }
    else
    {
        [mySwich setOn:NO];
    }
    
    NSString* isVibrations=[[NSUserDefaults standardUserDefaults] objectForKey:CHAT_VIBRATIONS];
    
    if(isVibrations==nil||[isVibrations isEqualToString:@"OK"])
    {
        [outletVibrations setOn:YES];
    }
    else
    {
        [outletVibrations setOn:NO];
        
    }
    if([SharedAppDelegate.role isEqualToString:@"consultant"]||[SharedAppDelegate.role isEqualToString:@"student"]||[SharedAppDelegate.role isEqualToString:@"manager"])
    {
        [viewSetVoice setHidden:NO];
    }
    else
    {
        [viewSetVoice setHidden:YES];
    }

}

+(void)SetTextViewLayer:(UITextField *)textview
{
    textview.layer.masksToBounds=YES;
    textview.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    textview.layer.borderWidth=1;
    textview.layer.cornerRadius=6;
    
}
+(void)SetUIButtonLayer:(UIButton *)uibutton
{
    //uibutton.layer.masksToBounds=YES;
    //uibutton.layer.cornerRadius = 6.0;
    //uibutton.layer.borderWidth = 1.0;
    //uibutton.layer.borderColor =  [[UIColor  colorWithRed:244/255.0 green:255/255.0 blue:51/255.0 alpha:0/255.0] CGColor];
}
+(void)SetTUIViewLayer:(UIView *)uiview
{
    //uiview0.layer.masksToBounds = YES;
    uiview.layer.cornerRadius = 6.0;
    uiview.layer.borderWidth = 1.0;
    uiview.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    uiview.layer.shadowColor=[UIColor grayColor].CGColor;
    uiview.layer.shadowOffset=CGSizeMake(0, 0);
    uiview.layer.shadowOpacity=0.5;
    uiview.layer.shadowRadius=5;
    
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    
    //viewName
    if (textField.superview.tag==001)
    {
        frame.origin.y+=124;
    }
    //viewPassword
    else
    {
        frame.origin.y+=184;
        
    }
    
    int offset = frame.origin.y + 25 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
//        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    self.myscrollerview.frame = CGRectMake(0.0f, -offset+48, self.myscrollerview.frame.size.width, self.myscrollerview.frame.size.height);
    [UIView commitAnimations];
}



//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.myscrollerview.frame =CGRectMake(0, 48, self.myscrollerview.frame.size.width, self.myscrollerview.frame.size.height);
}
-(void)handChangeName
{
    
    [self hiddenPassword];
//    [viewName setFrame: CGRectMake(10, 80+20,300, 200)];
//    [viewPassword setFrame:CGRectMake(10, 300+20, 300, 35)];
//    //herry20140418 add setvoice
//    [viewSetVoice setFrame:CGRectMake(10, 375, 300, 75)];
    
    //herry20140417
    [txtNewName resignFirstResponder];
    [txtConfirName resignFirstResponder];
    [txtConfirPassword resignFirstResponder];
    [txtCurrPassword resignFirstResponder];
    [txtNewPassword resignFirstResponder];
    
    
}
-(void)handChangePassword
{
    [self hiddenUsername];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        [viewName setFrame: CGRectMake(10, 134, 300, 35)];
//        [viewPassword setFrame:CGRectMake(10, 174, 300, 250)];
//    }
//    else
//    {
//        [viewName setFrame: CGRectMake(10, 124, 300, 35)];
//        [viewPassword setFrame:CGRectMake(10, 174, 300, 250)];
//    }
//    [viewName setFrame: CGRectMake(10, 80+20, 300, 35)];
//    [viewPassword setFrame:CGRectMake(10, 135+20, 300, 250)];
//
//    //herry20140418 add setvoice
//    [viewSetVoice setFrame:CGRectMake(10, 405+20, 300, 75)];
    

    //herry20140417
    [txtNewName resignFirstResponder];
    [txtConfirName resignFirstResponder];
    [txtConfirPassword resignFirstResponder];
    [txtCurrPassword resignFirstResponder];
    [txtNewPassword resignFirstResponder];
    
}
//HERRY20140417
-(void)scrollerviewTouch
{
    [txtNewName resignFirstResponder];
    [txtConfirName resignFirstResponder];
    [txtConfirPassword resignFirstResponder];
    [txtCurrPassword resignFirstResponder];
    [txtNewPassword resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setViewName:nil];
    [self setViewPassword:nil];
    [self setLblNewName:nil];
    [self setLblNewName:nil];
    [self setTxtNewName:nil];
    [self setLblCofirName:nil];
    [self setTxtConfirName:nil];
    [self setLblCurrPassword:nil];
    [self setTxtCurrPassword:nil];
    [self setLblNewPassword:nil];
    [self setTxtNewPassword:nil];
    [self setLblConfirPassword:nil];
    [self setTxtConfirPassword:nil];
    
    [self setOutletBtnSavePassword:nil];
    [self setOutletBtnSaveName:nil];
    //[self setOutletBtnSetPhoto:nil];
    [self setPhotoImageView:nil];
    [self setLblUserName:nil];
    [super viewDidUnload];
}

- (IBAction)btnSaveName:(id)sender {
    
    if (txtNewName.text.length == 0) {
        [self showAlertWithTitle:nil andMessage:@"Please enter your new username!"];
        return;
    }
    if (txtConfirName.text.length == 0) {
        [self showAlertWithTitle:nil andMessage:@"Please enter your confirm username!"];
        return;
    }
    if ([txtNewName.text isEqualToString:txtConfirName.text]==NO)
    {
        [self showAlertWithTitle:nil andMessage:@"Enter twice inconsistencies!"];
        return;
    }
    
    [txtNewName resignFirstResponder];
    [txtConfirName resignFirstResponder];
    [self updateUserName];
    
}
- (IBAction)btnCancelName:(id)sender {
    [self hiddenNameAndPassword];
}
- (IBAction)btnSavePassword:(id)sender {
    
    if (txtCurrPassword.text.length == 0) {
        [self showAlertWithTitle:nil andMessage:@"Please enter your new current password!"];
        return;
    }
    
    if (txtNewPassword.text.length == 0) {
        [self showAlertWithTitle:nil andMessage:@"Please enter your new password!"];
        return;
    }
    if (txtConfirPassword.text.length == 0) {
        [self showAlertWithTitle:nil andMessage:@"Please enter your confirm password!"];
        return;
    }
    if ([txtNewPassword.text isEqualToString:txtConfirPassword.text]==FALSE) {
        [self showAlertWithTitle:nil andMessage:@"Enter twice inconsistencies!"];
        return;
    }
    
    [txtCurrPassword resignFirstResponder];
    [txtNewPassword resignFirstResponder];
    [txtConfirPassword resignFirstResponder];
    [self updatePassword];
    
}
- (IBAction)btnCancelPassword:(id)sender {
    [self hiddenNameAndPassword];
}

-(void)hiddenUsername

{
    
    lblNewName.hidden=YES;
    txtNewName.hidden=YES;
    lblCofirName.hidden=YES;
    txtConfirName.hidden=YES;
    outletBtnSaveName.hidden=YES;
    outletBtnCancelName.hidden=YES;
    viewNameBtns.hidden = YES;
    
    lblCurrPassword.hidden=NO;
    txtCurrPassword.hidden=NO;
    lblNewPassword.hidden=NO;
    txtNewPassword.hidden=NO;
    lblConfirPassword.hidden=NO;
    txtConfirPassword.hidden=NO;
    outletBtnSavePassword.hidden=NO;
    outletBtnCancelPassword.hidden = NO;
    viewPasswordBtns.hidden = NO;
    
}
-(void)hiddenPassword
{
    lblNewName.hidden=NO;
    txtNewName.hidden=NO;
    lblCofirName.hidden=NO;
    txtConfirName.hidden=NO;
    outletBtnSaveName.hidden=NO;
    outletBtnCancelName.hidden = NO;
    viewNameBtns.hidden = NO;
    
    lblCurrPassword.hidden=YES;
    txtCurrPassword.hidden=YES;
    lblNewPassword.hidden=YES;
    txtNewPassword.hidden=YES;
    lblConfirPassword.hidden=YES;
    txtConfirPassword.hidden=YES;
    outletBtnSavePassword.hidden=YES;
    outletBtnCancelPassword.hidden = YES;
    viewPasswordBtns.hidden = YES;
    
}
-(void)hiddenNameAndPassword
{
    lblNewName.hidden=YES;
    txtNewName.hidden=YES;
    lblCofirName.hidden=YES;
    txtConfirName.hidden=YES;
    outletBtnSaveName.hidden=YES;
    outletBtnCancelName.hidden = YES;
    lblCurrPassword.hidden=YES;
    txtCurrPassword.hidden=YES;
    lblNewPassword.hidden=YES;
    txtNewPassword.hidden=YES;
    lblConfirPassword.hidden=YES;
    txtConfirPassword.hidden=YES;
    outletBtnSavePassword.hidden=YES;
    outletBtnCancelPassword.hidden = YES;
    viewPasswordBtns.hidden = YES;
    viewNameBtns.hidden = YES;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
	NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    imagePickerController.modalPresentationStyle = UIModalPresentationFormSheet;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BCTabBarController *tab =  (BCTabBarController *)app.window.rootViewController.presentedViewController;
    tab.tabBar.hidden = YES;
    
    
	[self presentModalViewController:imagePickerController animated:YES];
    //    imagePickerController.view.superview.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 10.0);//it's important to do this after presentModalViewController
    //    imagePickerController.view.superview.center = self.view.center;
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BCTabBarController *tab =  (BCTabBarController *)app.window.rootViewController.presentedViewController;
    tab.tabBar.hidden = NO;
    
	[picker dismissModalViewControllerAnimated:YES];
	self.photo = [info objectForKey:UIImagePickerControllerEditedImage];
    //测试图片下载功能
    /*NSString *aStr=[Photo image2String:self.photo];
     UIImage *pp=[Photo string2Image:aStr];
     photoImageView.image=pp;
     */
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self uodatePhoto];
    
    
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BCTabBarController *tab =  (BCTabBarController *)app.window.rootViewController.presentedViewController;
    tab.tabBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    UIImage *image = row == 0 ? [UIImage imageNamed:@"male.png"] : [UIImage imageNamed:@"female.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 32, 32);
    
    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 32)] ;
    [rowView insertSubview:imageView atIndex:0];
    //[rowView insertSubview:genderLabel atIndex:1];
    
    
    
    
    return rowView;
}

#pragma mark-UITextFieldDelegate

//点击enter的时候隐藏软键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
    
}

//点击取消（Cancel）或那个小差号的时候隐藏。注意这里如return YES则无法隐藏
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [textField resignFirstResponder];
    textField.text=@"300";
    return NO;
    
}
//点击View的其他区域隐藏软键盘。

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtNewName resignFirstResponder];
    [txtConfirName resignFirstResponder];
    [txtConfirPassword resignFirstResponder];
    [txtCurrPassword resignFirstResponder];
    [txtNewPassword resignFirstResponder];
    
}
-(void)uodatePhoto
{
    
    //更新openfire 用户头像 Andy
    self.vcard.photo= UIImageJPEGRepresentation(self.photo,1.0);
    [XMPPHelper updateVCard:self.vcard];
    
    NSString *aStr=[Photo image2String:self.photo];
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          aStr,@"photo",
                            SharedAppDelegate.role, @"role",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:Update_Phototext parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         UpdateHeadPhotoResponse* res = [UpdateHeadPhotoResponse updateHeadPhotoResponseWithDDXMLDocument:XMLDocument];
         //头像上传成功
         if([res.updateHeadPhotoMessage isEqualToString:@"true"])
         {
             
             
             
             
             // [self.outletBtnSetPhoto setImage:self.photo forState:UIControlStateNormal];
             photoImageView.image=self.photo;
             SharedAppDelegate.imageStr=aStr;
             [[NSUserDefaults standardUserDefaults] setValue:aStr forKey:USER_PHOTO];
             [[NSUserDefaults standardUserDefaults] synchronize];
             //             [self showAlertWithTitle:nil andMessage:@"touxiang!"];
             
         }
         else if([res.updateHeadPhotoMessage isEqualToString:@"-1"])
         {
             [self showAlertWithTitle:nil andMessage:@"no pression!"];
         }
         //失败
         else
         {
             [self showAlertWithTitle:nil andMessage:@"Error"];
         }
         
         
         [self hiddenHUD];
         
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         NSLog(@"error:%@", error);
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
    
}
-(void)updateUserName
{
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            SharedAppDelegate.role, @"role",
                            txtNewName.text, @"newname",
                            txtConfirName.text, @"cofirname",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:Update_UserName parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         UpdateUserNameResponse* res = [UpdateUserNameResponse updateUserNameResponseWithDDXMLDocument:XMLDocument];
         //修改成功
         if([res.updateUsernameMessage isEqualToString:@"true"])
         {
             [self showAlertWithTitle:nil andMessage:@"username update is sucess!"];
           //  lblUserName.text=txtNewName.text;
           //  SharedAppDelegate.username=txtNewName.text;
             
             [self loginoutsave];
             [SharedAppDelegate showLogin:NO animated:YES];
             [SharedAppDelegate clearAllCache];
             
         }
         //修改的用户名已存在
         else if([res.updateUsernameMessage rangeOfString:@"another"].location!=NSNotFound)
         {
             [self showAlertWithTitle:nil andMessage:@"Please change your new username!"];
         }
         //数据更新失败
         else if([res.updateUsernameMessage rangeOfString:@"Error occurred"].location!=NSNotFound)
         {
             [self showAlertWithTitle:nil andMessage:@"Error occurred!"];
         }
         
         [self hiddenHUD];
         
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         NSLog(@"error:%@", error);
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
    
}

-(void)updatePassword
{
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            SharedAppDelegate.role, @"role",
                            txtCurrPassword.text, @"oldpassword",
                            txtNewPassword.text, @"newpassword",
                            txtConfirPassword.text, @"confirmpassword",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:Update_Password parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         UpdatepasswordResponse* res = [UpdatepasswordResponse updatePasswordResponseWithDDXMLDocument:XMLDocument];
         //修改成功
         if([res.updatePasswordMessage isEqualToString:@"true"])
         {
            // SharedAppDelegate.password=txtNewPassword.text;
             [self showAlertWithTitle:nil andMessage:@"password update is sucess!"];
             
             [self loginoutsave];
             [SharedAppDelegate showLogin:NO animated:YES];
             [SharedAppDelegate clearAllCache];
             
         }
         //修改的用户名已存在
         else if([res.updatePasswordMessage rangeOfString:@"Old password"].location!=NSNotFound)
         {
             [self showAlertWithTitle:nil andMessage:@"Old password is not correct!"];
         }
         //更新出错
         else if([res.updatePasswordMessage rangeOfString:@"Error occurred"].location!=NSNotFound)
         {
             [self showAlertWithTitle:nil andMessage:@"Error occurred!"];
         }
         
         [self hiddenHUD];
         
         
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         NSLog(@"error:%@", error);
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
    
}

-(void)selectLoginInfo
{
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:SelectLogin parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         SelectLoginInfo* res = [SelectLoginInfo SelectLoginInfoWithDDXMLDocument:XMLDocument];
         NSString *aStr=res.photo;
         if(aStr.length>0)
         {
             UIImage *pp=[Photo string2Image:aStr];
             photoImageView.image=pp;
         }
         [self hiddenHUD];
         
         
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         NSLog(@"error:%@", error);
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
    
}


- (IBAction)btnchange:(id)sender {
    
    //choose_photo
    //take_photo_from_camera
    //take_photo_from_library
    UIActionSheet *choosePhotoActionSheet;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Camera", @""), NSLocalizedString(@"Photos", @""), nil];
    } else {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Photos", @""), nil];
    }
    
    [choosePhotoActionSheet showInView:self.view];
    [choosePhotoActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}
- (IBAction)btnSignOut:(id)sender {
    [self loginoutsave];
    [SharedAppDelegate showLogin:NO animated:YES];
    [SharedAppDelegate clearAllCache];
    [SharedAppDelegate resetAll];
}
- (void)loginoutsave
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            @"ios",@"source",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:User_LoginOut parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         UserLoginOutResponse* res = [UserLoginOutResponse userLoginOutResponseWithDDXMLDocument:XMLDocument];
         if (!res.userLoginOutMessage) {
             NSLog(@"退出日志写入失败");
         }
         else
         {
             if ([res.userLoginOutMessage isEqualToString:@"true"]) {
                 
                 NSLog(@"退出日志写入成功");
             }
             else
             {
                 NSLog(@"退出日志写入失败");
             }
         }
         
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         NSLog(@"result, error:%@",error);
     }];
    [operation start];
}


- (IBAction)setVoiceChangeed:(id)sender {
    
    BOOL isSetVoice=[mySwich isOn];
    
    if(isSetVoice)
    {
    
         [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:CHAT_VOICE];
        
    }
    else
    {
    
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:CHAT_VOICE];
        
    }
    
}
- (IBAction)btnVibrations:(id)sender {
    BOOL isVibrations=[outletVibrations isOn];
    
    if(isVibrations)
    {
    [[NSUserDefaults standardUserDefaults] setValue:@"OK" forKey:CHAT_VIBRATIONS];
    }
    else
    {
    [[NSUserDefaults standardUserDefaults] setValue:@"NOOK" forKey:CHAT_VIBRATIONS];
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
-(BOOL)shouldAutorotat
{
    return NO;
}
@end
