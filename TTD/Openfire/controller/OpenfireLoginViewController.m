//
//  LoginViewController.m
//  BaseProject
//
//  Created by Huan Cho on 13-8-2.
//  Copyright (c) 2013年 ch. All rights reserved.
//

#import "OpenfireLoginViewController.h"
#import "Statics.h"
#import "MainViewController.h"

@interface OpenfireLoginViewController ()

@end

@implementation OpenfireLoginViewController

@synthesize userTextField = _userTextField;
@synthesize passTextField = _passTextField;

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setUserTextField:nil];
    [self setPassTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    //[_userTextField release];
    //[_passTextField release];
    //[super dealloc];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

#pragma mark -private
//登录
- (IBAction)LoginButton:(id)sender {
    
    if ([self validateWithUser:_userTextField.text andPass:_passTextField.text]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.userTextField.text forKey:USERID];
        [defaults setObject:self.passTextField.text forKey:PASS];
        //保存
        [defaults synchronize];
        
        MainViewController *mainCtl = [[MainViewController alloc] init];
        [self presentViewController:mainCtl animated:YES completion:^{
            
        }];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名，密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//退出
- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//校验
-(BOOL)validateWithUser:(NSString *)userText andPass:(NSString *)passText{
    return userText.length > 0 && passText.length > 0;
}
@end
