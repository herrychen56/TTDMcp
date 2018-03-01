//
//  LoginViewController.h
//  TTD
//
//  Created by ZhangChuntao on 12/7/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URL.h"
#import "BaseViewController.h"
#import "XMPPServer.h"

@interface LoginViewController : BaseViewController
{
    IBOutlet UIButton* checkRememberButton;
    IBOutlet UIButton* autoLoginButton;
    
    IBOutlet TTDTextField* usernameField;
    IBOutlet TTDTextField* passwordField;
    XMPPServer *xmppServer;
}

@property (nonatomic) BOOL shouldCheckAutologin;

@end
