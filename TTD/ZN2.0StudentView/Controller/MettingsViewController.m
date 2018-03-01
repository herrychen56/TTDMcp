//
//  MettingsViewController.m
//  TTD
//
//  Created by quakoo on 2017/12/5.
//  Copyright © 2017年 totem. All rights reserved.
//

// 获得屏幕尺寸
#define kSCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define kSCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define IS_IOS_10    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==10.0 ? 1 : 0
#import "MettingsViewController.h"
#import "FSScrollContentView.h"//滑动使用
//滑动Controller 分视图
#import "UPMeetingViewController.h"
#import "PastMeetingViewController.h"
#import "DataModel.h"

@interface MettingsViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic,strong) NSDictionary * jsondic;
@end

@implementation MettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _jsondic = [[NSDictionary alloc]init];
    self.navigationItem.titleView = nil;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"Meetings";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
//self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jiahao.png"] style:UIBarButtonItemStylePlain target:self action:@selector(right)];
    
//    [self requestXML];
     [self otherviews];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

-(void) requestXML {
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_MEETINGS parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         ZNgetmettings * znmettings = [ZNgetmettings responseWithDDXMLDocument:XMLDocument];
         NSString * json = znmettings.getMettingsStr;
//         DLog(@"成功===%@",json);
        _jsondic = [SharedAppDelegate dictionaryWithJsonString:json];
//         DLog(@"成功===%@",_jsondic);
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"失败===%@",error);
     }];
    [operation start];
}

//创建滑动页面
-(void)otherviews {
    if (IS_IOS_10) {
        self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 150) titles:@[@"Upcoming Meetings",@"Past Meetings"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    }else{
        self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50) titles:@[@"Upcoming Meetings",@"Past Meetings"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    }
    
    self.titleView.titleFont = [UIFont systemFontOfSize:15];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:15];
    self.titleView.selectIndex = 0;
    self.titleView.titleNormalColor =[UIColor grayColor];
    self.titleView.titleSelectColor = [UIColor blackColor];
    self.titleView.indicatorColor = [UIColor blackColor];
    [self.view addSubview:_titleView];
     NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    
    UPMeetingViewController * upmetting=[[UPMeetingViewController alloc]init];
    upmetting.view.backgroundColor = [UIColor whiteColor];
  
    PastMeetingViewController * pastmetting = [[PastMeetingViewController alloc]init];
    pastmetting.view.backgroundColor = [UIColor whiteColor];
   
    [childVCs addObject:upmetting];
    [childVCs addObject:pastmetting];
    
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    //    self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
    [self.view addSubview:_pageContentView];
    
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 1)];
    lab.backgroundColor= [UIColor grayColor];
    [self.view addSubview:lab];
    
}

#pragma mark --
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
//    self.title =@[@"Up-coming Meetings",@"Past Meetings"][endIndex];
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
//    self.title = @[@"Up-coming Meetings",@"Past Meetings"][endIndex];
}


#pragma mark - 导航右侧an'n
-(void)right {
    NSLog(@"点击了MettingsView页面的加号按钮");
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
