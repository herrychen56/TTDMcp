//
//  BaseViewController.m
//  Card
//
//  Created by chun tao on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController
@synthesize viewShowing;
@synthesize viewLoaded;
@synthesize shouldReload;
@synthesize unreadCount;

- (void)loadNeededInfo
{
    
}

- (void)hideLoadingView
{
    [HUD hide:YES];
    HUD = nil;
}

- (void)showLoadingViewWithMessage:(NSString *)msg
{
    if (HUD) {
        [HUD hide:YES];
        HUD = nil;
    }
    if (self.navigationController) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
    }
    else {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }
	
	
    HUD.dimBackground = YES;
    if (msg == nil) {
        msg = NSLocalizedString(@"Loading", @"");
    }
    HUD.labelText = msg;
    [HUD show:YES];
    HUD.removeFromSuperViewOnHide = YES;
}

- (void)showNetworkNotAvailableAlertView
{
    [self showAlertWithTitle:nil andMessage:@"No network access!"];
}

- (void)showAlertWithTitle:(NSString*) title andMessage:(NSString*) message
{
    if (!viewShowing) {
        return;
    }
    NSString* cancelBtnTitle = NSLocalizedString(@"OK", @"");
    UIAlertView* alertView = [[UIAlertView alloc] 
                              initWithTitle:title 
                              message:message 
                              delegate:nil 
                              cancelButtonTitle:cancelBtnTitle
                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark -
#pragma mark Constants

#pragma mark -
#pragma mark Lifecycle methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 100, self.navigationController.navigationBar.frame.size.height - 10)];
    titleImageView.clipsToBounds = YES;
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    titleImageView.image = [UIImage imageNamed:@"navi_logo"];
    self.navigationItem.titleView = titleImageView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    viewShowing = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    viewShowing = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark -
#pragma mark IBActions
- (void)showHUD
{
//    if (!viewShowing) {
//        return;
//    }
    if (HUD) {
        [self hiddenHUD];
    }
    if (self.navigationController) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    }
    else {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
	
    if (self.navigationController) {
        [self.navigationController.view addSubview:HUD];
    }
    else {
        [self.view addSubview:HUD];
    }
	HUD.dimBackground = NO;
	HUD.delegate = self;
    [HUD show:YES];
}

- (void)hiddenHUD
{
    if (HUD) {
        [HUD hide:YES];
        HUD = nil;
    }
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)showToastMessage:(NSString *) message duration:(int)duration
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	
    hud.userInteractionEnabled = NO;
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = message;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:duration];
}
- (void)showProgressHUD:(MBProgressHUDMode *)mode
{
    if (HUD) {
        [self hiddenHUD];
    }
    if (self.navigationController) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    }
    else {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
    
    if (self.navigationController) {
        [self.navigationController.view addSubview:HUD];
    }
    else {
        [self.view addSubview:HUD];
    }
    HUD.dimBackground = NO;
    HUD.delegate = self;
    HUD.mode=mode;
    HUD.progress=10;
    [HUD show:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

@implementation UIViewController (ResetStuff)

- (void)resetViews
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navi = (UINavigationController*)self;
        UIViewController* controller = [navi.viewControllers objectAtIndex:0];
        if ([controller respondsToSelector:@selector(resetViews)]) {
            [controller resetViews];
        }
    }
}

- (void)clearCache
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navi = (UINavigationController*)self;
        UIViewController* controller = [navi.viewControllers objectAtIndex:0];
        if ([controller respondsToSelector:@selector(clearCache)]) {
            [controller clearCache];
        }
    }
}

@end
