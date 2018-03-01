//
//  ZNsecurityViewController.m
//  TTD
//
//  Created by 张楠 on 2018/2/3.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "ZNsecurityViewController.h"

@interface ZNsecurityViewController ()

@end

@implementation ZNsecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.idstr setText: [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
}

- (IBAction)password:(id)sender {
    
    __block UITextField *tf = nil;
    __block UITextField *tf2 = nil;
    __block UITextField *tf3 = nil;
    [LEEAlert alert].config
    .LeeTitle(@"Change Password")
    .LeeAddTextField(^(UITextField *textField) {
        
        // 这里可以进行自定义的设置
        
        textField.placeholder = @"Current Password";
        
        textField.textColor = [UIColor darkGrayColor];
        
        tf = textField; //赋值
    })
    .LeeAddTextField(^(UITextField *textField) {
        
        // 这里可以进行自定义的设置
        
        textField.placeholder = @"New Password";
        
        textField.textColor = [UIColor darkGrayColor];
        
        tf2 = textField; //赋值
    })
    .LeeAddTextField(^(UITextField *textField) {
        
        // 这里可以进行自定义的设置
        
        textField.placeholder = @"Confirm Password";
        
        textField.textColor = [UIColor darkGrayColor];
        
        tf3 = textField; //赋值
    })
    .LeeAction(@"Save", ^{
        
        NSString * curstr = tf.text;
        NSString * newpas = tf2.text;
        NSString * confpas = tf3.text;
        NSURL *url = [NSURL URLWithString:SERVER_URL];
        AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                SharedAppDelegate.username, @"username",
                                SharedAppDelegate.password, @"password",
                                SharedAppDelegate.role, @"role",
                                curstr, @"oldpassword",
                                newpas, @"newpassword",
                                confpas, @"confirmpassword",
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
              NSLog(@"密码修改成功");
             
         }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
         {
             [self hiddenHUD];
             NSLog(@"error:%@", error);
             [self showAlertWithTitle:nil andMessage:@"No Network"];
         }];
        [operation start];
//        [self showHUD];
        
        [tf resignFirstResponder];
        [tf2 resignFirstResponder];
        [tf3 resignFirstResponder];
    })
    .LeeCancelAction(@"Cancel", nil) // 点击事件的Block如果不需要可以传nil
    .LeeShow();
    
    
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
