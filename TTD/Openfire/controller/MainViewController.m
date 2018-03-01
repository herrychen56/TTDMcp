//
//  MainViewController.m
//  pdjyh
//
//  Created by ch on 12-6-28.
//  Copyright (c) 2012年 ch. All rights reserved.
//  主控制器

#import "MainViewController.h"
#import "ChUITabBarView.h"
#import "ChTabBarItem.h"
#import "BuddyViewController.h"
#import "GroupViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController{
    NSMutableArray *_tabBarItems;
    UIView *_contentView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    self.tabBarItems = [NSMutableArray array];
    
    [super viewDidLoad];

    //初始化
    [self initTheme];
    [self initContentView];
    [self initViewControllers];
    [self initTabBar];
    
    [_tabBar selectBtnAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark 初始化装载切换控制器后的view的view
-(void)initContentView{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
    
    _contentView = [[[UIView alloc] initWithFrame:rect] autorelease];
    _contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_contentView];
}

#pragma mark 初始化视图控制器
-(void)initViewControllers{    
    //
    UIViewController *homeController = [[[UIViewController alloc] init] autorelease];
    [self addController:homeController tabbarItemTitle:@"首页" normalImageName:@"tabbar_home.png" highlightedImageName:@"tabbar_home_highlighted.png"];
    
    //好友
    BuddyViewController *c2 = [[[BuddyViewController alloc] init] autorelease];
//    c2.view.backgroundColor = [UIColor blueColor];
    [self addController:c2 tabbarItemTitle:@"好友" normalImageName:@"tb_address_normal.png" highlightedImageName:@"tb_address_normal.png"];
    
    //群组
    GroupViewController *c3 = [[[GroupViewController alloc] init] autorelease];
    [self addController:c3 tabbarItemTitle:@"群组" normalImageName:@"tabbar_profile.png" highlightedImageName:@"tabbar_profile_highlighted.png"];
    
    //
    UIViewController *c4 = [[[UIViewController alloc] init] autorelease];
    [self addController:c4 tabbarItemTitle:@"设置" normalImageName:@"tabbar_discover.png" highlightedImageName:@"tabbar_discover_highlighted.png"];
    
    UIViewController *c5 = [[[UIViewController alloc] init] autorelease];
    c5.view.backgroundColor = [UIColor purpleColor];
    [self addController:c5 tabbarItemTitle:@"更多" normalImageName:@"tabbar_more.png" highlightedImageName:@"tabbar_more_highlighted.png"];
}

#pragma mark - addController
-(void)addController:(UIViewController*)controller tabbarItemTitle:(NSString*)title normalImageName:(NSString*)normal highlightedImageName:(NSString*)highlight{
    
    controller.title = title;
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:controller];
    ChTabBarItem *item = [[ChTabBarItem tabBarItemWithTitle:title normalImage:normal highlightedImage:highlight] autorelease];
    [self.tabBarItems addObject:item];
    
    [self addChildViewController:nv];
}

#pragma mark -
-(void)initTabBar{
    CGRect frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    ChUITabBarView *tabBarView = [[ChUITabBarView alloc] initWithFrame:frame tabBarItems:_tabBarItems];
    tabBarView.delegate = self;
    [self.view addSubview:tabBarView];
    _tabBar = tabBarView;
    [tabBarView release];
}

#pragma mark - ChUITabBarViewDelegate implementation
#pragma mark
-(void)chUITabBarViewItemSelectedChangeWithNewItemIndex:(NSInteger)index oldSelectedIndex:(NSInteger)old{
    [[[_contentView subviews] lastObject] removeFromSuperview];
    UIViewController *controller = self.childViewControllers[index];
    controller.view.frame = _contentView.frame;
    [_contentView addSubview:controller.view];
}

#pragma mark 导航控制器的导航条的的定制
-(void)initTheme{
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationbar_background.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor blackColor]}];
}

@end
