//
//  LoginViewController.m
//  TTD
//
//  Created by ZhangChuntao on 12/7/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import "LoginViewController.h"
#import "AFKissXMLRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "DataModel.h"
#import "GlobalConfig.h"
#import "Statics.h"
#import "ZNXMPPManager.h"
#import "XMPPManager.h"
@interface LoginViewController() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (nonatomic, assign) BOOL keyboardOnScreen;

//ZN 新建
@property (nonatomic,strong) NSString * userid;
@property (nonatomic,strong) NSString * password;
@end

@implementation LoginViewController


@synthesize shouldCheckAutologin;
//@synthesize xmppServer;

- (void)viewDidLoad
{
    _userid = [[NSString alloc]init];
    _password = [[NSString alloc]init];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [super viewDidLoad];
    self.keyboardOnScreen = NO;
    [self initSubviews];
    [self loadUpdateInfo];
    // Do any additional setup after loading the view from its nib.
 
    
}

- (NSString*)iconImageName
{
    return @"tab_home.png";
}

- (IBAction)touchView:(id)sender {
    [self resignIfFirstResponder:usernameField];
    [self resignIfFirstResponder:passwordField];
}

- (void)setBtnEnabled: (BOOL)enable {
    self.loginBtn.enabled = enable;
    self.loginBtn.alpha = enable ? 1 : 0.5;
}

- (IBAction)login:(id)sender
{
    
    [self setBtnEnabled:NO];
    if (usernameField.text.length == 0) {
        [self showAlertWithTitle:nil andMessage:@"Please enter your user name."];
        [self setBtnEnabled:YES];
        return;
    }
    if (passwordField.text.length == 0) {
        [self showAlertWithTitle:nil andMessage:@"Please enter your password."];
        [self setBtnEnabled:YES];
        return;
    }
    NSString* password=CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef) passwordField.text, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            usernameField.text, @"username",
                            password, @"password",
                            @"",@"source",nil];
    //NSMutableURLRequest *request = [client requestWithFunction:FUNC_LOGIN parameters:params];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_LOGINRETURN_ROLE parameters:params];
    
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)

     {
         NSLog(@"登录返回=%@",XMLDocument);
         
         [self hideLoadingView];
         [self setBtnEnabled:YES];
         //登录成功
         LoginResponse* res = [LoginResponse responseWithDDXMLDocument:XMLDocument];
         if (!res.state) {
             [self showAlertWithTitle:nil andMessage:res.responseMessage];
             if (autoLoginButton.selected) {
                 //autoLoginButton.selected = NO;
                 //[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:SETTING_AUTO_LOGIN];
             }
         }
         else {
             [[NSUserDefaults standardUserDefaults] setValue:usernameField.text forKey:USER_NAME_REMEMBERED];
             [[NSUserDefaults standardUserDefaults] setValue:passwordField.text forKey:USER_PASSWORD_REMEMBERED];
             SharedAppDelegate.username = usernameField.text;
             SharedAppDelegate.password = password;
             //HERRY 添加
             SharedAppDelegate.role =res.responseMessage;
             //herry添加 20140416
             SharedAppDelegate.closeFlog=@"login";
             //herry20140516
             [self selectLoginInfo];
             //herry20140610
             SharedAppDelegate.studentArray=nil;
             
             [SharedAppDelegate loginSuccess:YES];
             
             //Andy OpenFire Start
             NSLog(@"responseMessage:%@",res.responseMessage);
             
             if ([res.responseMessage isEqualToString:TTDROLE_CONSULTANT]|| [res.responseMessage isEqualToString:TTDROLE_STUDENT]|| [res.responseMessage isEqualToString:TTDROLE_MANAGER]|| [res.responseMessage isEqualToString:TTDROLE_PARENT])
             {
                 NSDictionary *Openfireparams = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 SharedAppDelegate.username, @"username",
                                                 SharedAppDelegate.password, @"password",
                                                 SharedAppDelegate.role,@"role",nil];
                 NSMutableURLRequest *Openfirerequest = [client requestWithFunction:FUNC_OPENFIRECHENGUSERPASSWORD parameters:Openfireparams];
                 AFKissXMLRequestOperation *Openfireoperation =
                 [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)Openfirerequest
                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
                  {
                      
                      OpenfireUserResponse* openfireuserResponse= [OpengfireChangeUserPasswordResponse responseWithDDXMLDocument:XMLDocument];
                      NSLog(@"FUNC_OPENFIRECHENGUSERPASSWORD:%@",openfireuserResponse.info);
                      //OpenFireConnect
                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                      [defaults setObject:usernameField.text forKey:USERID];
                      [defaults setObject:passwordField.text forKey:PASS];
                      [defaults synchronize];
                      SharedAppDelegate.xmppServer=[XMPPServer sharedServer];
                      [[SharedAppDelegate xmppServer] connect];
                      
                  }
                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
                  {
                      
                      
                  }];
                 [Openfireoperation start];
                 
             }
             if([res.responseMessage isEqualToString:TTDROLE_CONSULTANT]|| [res.responseMessage isEqualToString:TTDROLE_STUDENT]|| [res.responseMessage isEqualToString:TTDROLE_MANAGER]|| [res.responseMessage isEqualToString:TTDROLE_PARENT])
             {
                 
                 NSDictionary *Openfireparams = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 SharedAppDelegate.username, @"username",
                                                 SharedAppDelegate.password, @"password",
                                                 SharedAppDelegate.role,@"role",nil];
                 NSMutableURLRequest *Openfirerequest = [client requestWithFunction:FUNC_OPENFIREUSER parameters:Openfireparams];
                 AFKissXMLRequestOperation *Openfireoperation =
                 [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)Openfirerequest
                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
                  {
                      
                      OpenfireUserResponse* openfireuserResponse= [OpenfireUserResponse responseWithDDXMLDocument:XMLDocument];
                      //OpenFireConnect For Consultant
                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                      [defaults setObject:usernameField.text forKey:USERID];
                      [defaults setObject:passwordField.text forKey:PASS];
                      [defaults synchronize];
                      xmppServer = [XMPPServer sharedServer];
                      [xmppServer connect];
                      
                  }
                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
                  {
                      
                      
                  }];
                 [Openfireoperation start];
                 
                 
                 
             }
             if ([res.responseMessage isEqualToString:TTDROLE_CONSULTANT]) {
                 [self ConsultantType];
             }
             [self loadUserInfo];
             [self SetMobileToken];
             
         }
         
     }
 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         NSLog(@"error:%@", error);
         [self setBtnEnabled:YES];
         [self hideLoadingView];
         [self showAlertWithTitle:nil andMessage:@"No internet access!"];
     }];
    [operation start];
    
    [self showLoadingViewWithMessage:@"Log in, please wait..."];
    


}

- (IBAction)checkAction:(id)sender
{
    UIButton* button = (UIButton*)sender;
    button.selected = !button.selected;
    if (button == checkRememberButton) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:button.selected] forKey:SETTING_REMEMBER_PASSWORD];
        if (!button.selected) {
            autoLoginButton.selected = YES;
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:SETTING_AUTO_LOGIN];
        }
    }
    else {
        if (button.selected) {
            checkRememberButton.selected = YES;
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:SETTING_REMEMBER_PASSWORD];
        }
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:button.selected] forKey:SETTING_AUTO_LOGIN];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initSubviews
{
    usernameField.delegate = self;
    passwordField.delegate = self;
    //checkRememberButton.selected=YES;
    //autoLoginButton.selected=YES;
    BOOL ONE_LOGIN=[[[NSUserDefaults standardUserDefaults] valueForKey:SETTING_ONE_LOGIN] boolValue];
    if (ONE_LOGIN==NO)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:SETTING_ONE_LOGIN];
        
        checkRememberButton.selected = YES;
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:SETTING_REMEMBER_PASSWORD];
        autoLoginButton.selected = YES;
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:SETTING_AUTO_LOGIN];
    }
    else
    {
        checkRememberButton.selected = [[[NSUserDefaults standardUserDefaults] valueForKey:SETTING_REMEMBER_PASSWORD] boolValue];
        autoLoginButton.selected = [[[NSUserDefaults standardUserDefaults] valueForKey:SETTING_AUTO_LOGIN] boolValue];
        
        usernameField.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_NAME_REMEMBERED];
        if (checkRememberButton.selected) {
            passwordField.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_PASSWORD_REMEMBERED];
        }
        if (autoLoginButton.selected && self.shouldCheckAutologin) {
            [self login:nil];
        }
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow: (NSNotification *)notification {
    if (!self.keyboardOnScreen) {
        self.logoImageView.hidden = YES;
    }
}

- (void)keyboardWillHide: (NSNotification *)notification {
    if (self.keyboardOnScreen) {
        self.logoImageView.hidden = NO;
    }
}

- (void)keyboardDidShow: (NSNotification *)notification {
    self.keyboardOnScreen = YES;
}

- (void)keyboardDidHide: (NSNotification *)notification {
    self.keyboardOnScreen = NO;
}

- (void)resignIfFirstResponder: (UITextField *)textfield {
    if ([textfield isFirstResponder]) {
        [textfield resignFirstResponder];
    }
}

- (void)loadUserInfo
{
    //NSLog(@"tt:%@",SharedAppDelegate.role);
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.role,@"currentrole",
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password", nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_USER_INFO parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         //NSLog(@"userinfodoc:%@", XMLDocument);
         //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOAD_FULLNAME object:nil];
         SharedAppDelegate.currentUserInfo = [UserInfo userInfoWithDDXMLDocument:XMLDocument];
         //NSLog(@"userinfo:%@, %@, %@", SharedAppDelegate.currentUserInfo.avatarUrl, SharedAppDelegate.currentUserInfo.firstName, SharedAppDelegate.currentUserInfo.lastName);
         [self hiddenHUD];
         
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
//    [self showLoadingViewWithMessage:@"Loading User info..."];
//    [MBManager showLoading];
    
    //User photo
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:USER_PHOTO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSURL *Photourl = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* Photoclient = [[AFHTTPClient alloc] initWithBaseURL:Photourl];
    NSDictionary *Photoparams = [NSDictionary dictionaryWithObjectsAndKeys:
                                 SharedAppDelegate.username, @"username",
                                 nil];
    //NSLog(@"UserPhotoSet-studentname - %@",UserArrayName);
    NSMutableURLRequest *Photorequest = [Photoclient requestWithFunction:FUNC_USERPHOTO parameters:Photoparams];
    AFKissXMLRequestOperation *Photooperation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)Photorequest
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         UserPhoto* res = [UserPhoto UserPhotoWithDDXMLDocument:XMLDocument];
         NSString *aStr=res.photo;
         if(aStr.length>0)
         {
             [[NSUserDefaults standardUserDefaults] setValue:res.photo forKey:USER_PHOTO];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }else
         {
             [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:USER_PHOTO];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"error:%@", error);
     }];
    [Photooperation start];
    
}
// SetMobileToken
-(void)SetMobileToken
{
    if (SharedAppDelegate.devicetoken!=NULL) {
        NSString *_devicetoken=[SharedAppDelegate.devicetoken stringByReplacingOccurrencesOfString:@" " withString:@""];
        _devicetoken=[_devicetoken stringByReplacingOccurrencesOfString:@"<" withString:@""];
        _devicetoken=[_devicetoken stringByReplacingOccurrencesOfString:@">" withString:@""];
        NSURL *url = [NSURL URLWithString:SERVER_URL];
        AFHTTPClient* clientToken = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSDictionary *paramsToken = [NSDictionary dictionaryWithObjectsAndKeys:
                                     SharedAppDelegate.username, @"username",
                                     SharedAppDelegate.password, @"password",
                                     SharedAppDelegate.role,@"role",
                                     @"IOS",@"source_type",
                                     _devicetoken,@"token",
                                     nil];
        NSLog(@"params:%@",paramsToken);
        NSLog(@"SharedAppDelegate.role:%@",SharedAppDelegate.role);
        NSMutableURLRequest *requestToken = [clientToken requestWithFunction:FUNC_SETMOBILETOKEN parameters:paramsToken];
        AFKissXMLRequestOperation *operation =
        [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)requestToken
                                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
         {
             //NSLog(@"userinfodoc:%@", XMLDocument);
             BOOL respon= [SetMobileTokenResponse SetMobileTokenResponseWithDDXMLDocument:XMLDocument];
             NSLog(@"SetMobileTokenRespon:%hhd", respon);
             
         }
                                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
         {
             [self showAlertWithTitle:nil andMessage:@"No Network"];
         }];
        [operation start];
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SharedAppDelegate.updateInfo.updateUrl]];
    }else
    {
        [self exitApplication];
    }
}
- (void)exitApplication {
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    //exit(0);
    
}

- (void)loadUpdateInfo
{
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],    @"Version", nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_UPDATE_INFO parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         NSLog(@"%@", XMLDocument);
         SharedAppDelegate.updateInfo = [UpdateInfo updateInfoWithDDXMLDocument:XMLDocument];
         if (SharedAppDelegate.updateInfo.hasNewVersion) {
             //UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Version" message:@"New version available, would you like to update?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Version" message:@"New version available. Please update now." delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:@"OK", nil];
             [alert show];
         }
         [self hiddenHUD];
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         NSLog(@"error:%@", error);
     }];
    [operation start];
//    [self showHUD];
    
    
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
             SharedAppDelegate.imageStr=aStr;
         }
         else
         {
             SharedAppDelegate.imageStr=nil;
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
- (void)ConsultantType
{
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.role,@"role",
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password", nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_CONSULTANTYPE parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         
         ConsultantTypeResponse *ConsultantType = [ConsultantTypeResponse ConsultantTypeResponseWithDDXMLDocument:XMLDocument];
         SharedAppDelegate.role_Consultant_Type=ConsultantType.info;
         
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         
     }];
    [operation start];
    
    
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


#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}





@end
