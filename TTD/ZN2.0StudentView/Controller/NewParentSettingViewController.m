//
//  NewParentSettingViewController.m
//  TTD
//
//  Created by quakoo on 2017/12/4.
//  Copyright © 2017年 totem. All rights reserved.
//   ZN-2.0全新个人页面

#import "NewParentSettingViewController.h"
#import "DataModel.h"
#import <QuartzCore/QuartzCore.h>
#import "Photo.h"
#import "AppDelegate.h"
#import "BCTabBarController.h"
#import "XMPPHelper.h"
#import "XMPPvCardTemp.h"
#import "MessageUserListViewController.h"
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

@interface NewParentSettingViewController ()
@property (nonatomic,strong) XMPPvCardTemp *vcard;
@end



@implementation NewParentSettingViewController
@synthesize photo;
@synthesize photoArray;
@synthesize photoString;

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
//    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    
    if ([SharedAppDelegate.role  isEqualToString:@"student"]) {
        self.DoneButton.hidden=NO;
    }else{
        self.DoneButton.hidden = YES;
    }
    
    
    self.LocationButton.hidden = YES;
    self.Locationlab.hidden = YES;
    [self CreateUI];
    
}

-(void)CreateUI {
    //读取xmppvcard 设置头像
    self.vcard=[XMPPHelper getmyvcard];
    if (SharedAppDelegate.imageStr.length>0) {
        UIImage * pp = [Photo string2Image:SharedAppDelegate.imageStr];
        self.iconIMg.image = pp;
    }else{
        self.iconIMg.image = [UIImage imageNamed:@"icon_addPhoto.png"];
    }
    //姓名
    self.Nametext.delegate = self;
   self.Nametext.text = [NSString stringWithFormat:@"%@",SharedAppDelegate.currentUserInfo.userFullName];
    self.Nametext.textColor = [UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1.00];
    [self.Nametext addTarget:self action:@selector(nametextfied:) forControlEvents:UIControlEventEditingDidEnd];
   //ID
    self.IDlab.text = [NSString stringWithFormat:@"%@",SharedAppDelegate.username];
    NSLog(@"version==%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);
    //返回按钮
    [self.DoneButton addTarget:self action:@selector(backviewController) forControlEvents:UIControlEventTouchUpInside];
    //相机按钮
    [self.CamerButton addTarget:self action:@selector(goCameView) forControlEvents:UIControlEventTouchUpInside];
    //logout按钮
    [self.logoubut addTarget:self action:@selector(logoubtn:) forControlEvents:UIControlEventTouchUpInside];
    //Contact 按钮
    [self.ContactButton addTarget:self action:@selector(contactbtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - Contact按钮
-(void)contactbtn:(UIButton *)conbutton {
    [LEEAlert actionsheet].config
//    .LeeTitle(@"这是一个actionSheet 它有三个不同类型的action!")
    .LeeAction(@"Parents’ Name", ^{
        
        // 点击事件Block
    })
    .LeeDestructiveAction(@"Send Message", ^{
        
        // 点击事件Block
    })
    .LeeDestructiveAction(@"Video Call", ^{
        
        // 点击事件Block
    })
    .LeeCancelAction(@"cancel", ^{
        
        // 点击事件Block
    })
    .LeeShow();
}

#pragma mark -  修改名字
-(void)nametextfied:(UITextField *)textfie {
    self.Nametext.text =[NSString stringWithFormat:@"%@",textfie.text];
    [self updateUserName];
}
#pragma mark - 返回按钮
-(void)backviewController {
    NSLog(@"点击了返回按钮");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - 相机按钮
-(void)goCameView {
    NSLog(@"点击了相机按钮");
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
#pragma mark - LogOUt
-(void)logoubtn:(UIButton *)send {
    [self loginoutsave];
    [SharedAppDelegate showLogin:NO animated:YES];
    [SharedAppDelegate clearAllCache];
    [SharedAppDelegate resetAll];
    //清除所有数据
    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier];
    [USER_DEFAULT removePersistentDomainForName:bundle];
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
             self.iconIMg.image=self.photo;
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
//点击enter的时候隐藏软键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self updateUserName];
    return YES;
    
}
#pragma mark 更新名字
-(void)updateUserName
{
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            SharedAppDelegate.role, @"role",
                            self.Nametext.text, @"newname",
                            self.Nametext.text, @"cofirname",
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
             NSLog(@"姓名修改成功");
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
             NSLog(@"姓名已存在");
             [self showAlertWithTitle:nil andMessage:@"Please change your new username!"];
         }
         //数据更新失败
         else if([res.updateUsernameMessage rangeOfString:@"Error occurred"].location!=NSNotFound)
         {
             NSLog(@"更新数据库失败");
             [self showAlertWithTitle:nil andMessage:@"Error occurred!"];
         }
         
         [self hiddenHUD];
         
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         NSLog(@"===error:%@", error);
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
    
}
#pragma mark - 点击其他区域收回键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.Nametext resignFirstResponder];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
