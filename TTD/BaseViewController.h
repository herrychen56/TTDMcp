//
//  BaseViewController.h
//  Card
//
//  Created by chun tao on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "AFKissXMLRequestOperation.h"
#import "GlobalConfig.h"
#import "URL.h"

@interface BaseViewController : UIViewController <MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
	long long expectedLength;
	long long currentLength;
    BOOL naviHasNew;
    BOOL toastShowing;
}
@property (nonatomic) BOOL viewShowing;
@property (nonatomic) BOOL viewLoaded;
@property (nonatomic) int shouldReload;
@property (nonatomic) int unreadCount;

- (void)showHUD;
- (void)hiddenHUD;
- (void)showAlertWithTitle:(NSString*) title andMessage:(NSString*) message;
- (void)showToastMessage:(NSString *) message duration:(int)duration;

- (void)showLoadingViewWithMessage:(NSString *)msg;
- (void)hideLoadingView;
- (void)loadNeededInfo;
- (void)showProgressHUD:(MBProgressHUDMode *)mode;
@end

@interface UIViewController (ResetStuff)

- (void)resetViews;
- (void)clearCache;

@end
