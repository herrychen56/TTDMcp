//
//  ZNNewParentViewController.m
//  TTD
//
//  Created by 张楠 on 2018/2/3.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "ZNNewParentViewController.h"
#import "DataModel.h"
#import <QuartzCore/QuartzCore.h>
#import "Photo.h"
#import "AppDelegate.h"
#import "BCTabBarController.h"
#import "XMPPHelper.h"
#import "XMPPvCardTemp.h"
#import "MessageUserListViewController.h"

#import "ZNNOtificViewController.h"
#import "ZNsecurityViewController.h"
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]



@interface ZNNewParentViewController ()
@property (nonatomic,strong) XMPPvCardTemp *vcard;
@end

@implementation ZNNewParentViewController
@synthesize photo;
@synthesize photoArray;
@synthesize photoString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([SharedAppDelegate.role  isEqualToString:@"student"]) {
        self.navigationItem.titleView = nil;
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        title.text = @"Profile";
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = title;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Log out" style:UIBarButtonItemStyleDone target:self action:@selector(logoubtn:)];
        self.logout.hidden = YES;
//       self.navigationController.navigationBar.hidden = YES;
//        self.logout.hidden = NO;
//        [self.logout addTarget:self action:@selector(logoubtn:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.navigationItem.titleView = nil;
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        title.text = @"Profile";
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = title;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Log out" style:UIBarButtonItemStyleDone target:self action:@selector(logoubtn:)];
        self.logout.hidden = YES;
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    
    [self.notificationbtn addTarget:self action:@selector(pusnotifv) forControlEvents:UIControlEventTouchUpInside];
    [self.securitybtn addTarget:self action:@selector(pussecv) forControlEvents:UIControlEventTouchUpInside];
    
    self.mylocation.hidden = YES;
    self.LocationButton.hidden = YES;
    
    [self CreateUI];
}

-(void)pusnotifv{
    ZNNOtificViewController * view=[[ZNNOtificViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)pussecv{
    ZNsecurityViewController * secv = [[ZNsecurityViewController alloc]init];
    secv.idstr.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [self.navigationController pushViewController:secv animated:YES];
}


-(void)CreateUI {
    //读取xmppvcard 设置头像
    self.vcard=[XMPPHelper getmyvcard];
    if (SharedAppDelegate.imageStr.length>0) {
        UIImage * pp = [Photo string2Image:SharedAppDelegate.imageStr];
        self.myicon.image = pp;
    }else{
        self.myicon.image = [UIImage imageNamed:@"icon_addPhoto.png"];
    }
    NSString *role=[SharedAppDelegate.role capitalizedStringWithLocale:[NSLocale currentLocale]];
    self.myroeid.text=role;
    //姓名
    self.myname.delegate = self;
    self.myname.text = [NSString stringWithFormat:@"%@",SharedAppDelegate.currentUserInfo.userFullName];
    self.myname.textColor = [UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1.00];
    [self.myname addTarget:self action:@selector(nametextfied:) forControlEvents:UIControlEventEditingDidEnd];
    //ID
    self.myid.text = [NSString stringWithFormat:@"%@",SharedAppDelegate.username];
    NSLog(@"version==%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);
    //返回按钮
//    [self.DoneButton addTarget:self action:@selector(backviewController) forControlEvents:UIControlEventTouchUpInside];
    //相机按钮
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goCameView)];
    [self.myicon addGestureRecognizer:tapGesture];
    self.myicon.userInteractionEnabled=YES;
    
    [self.iconbtn addTarget:self action:@selector(goCameView) forControlEvents:UIControlEventTouchUpInside];
    //logout按钮
//    [self.logoubut addTarget:self action:@selector(logoubtn:) forControlEvents:UIControlEventTouchUpInside];
//    //Contact 按钮
//    [self.ContactButton addTarget:self action:@selector(contactbtn:) forControlEvents:UIControlEventTouchUpInside];
    
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
             self.myicon.image=self.photo;
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
                            self.myname.text, @"newname",
                            self.myname.text, @"cofirname",
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
    [self.myname resignFirstResponder];
    
    
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
