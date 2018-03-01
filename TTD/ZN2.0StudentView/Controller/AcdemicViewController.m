//
//  AcdemicViewController.m
//  TTD
//
//  Created by quakoo on 2017/12/5.
//  Copyright © 2017年 totem. All rights reserved.
//

// 获得屏幕尺寸
#define kSCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define kSCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height

#import "AcdemicViewController.h"
#import "FSScrollContentView.h"//滑动使用
#import "DocumentsViewController.h"//文件上传查看页面
#import "ZNextractivitiesController.h"
#import "ZNTestsViewController.h"
#import "ZNAcdViewController.h"
@interface AcdemicViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@end

@implementation AcdemicViewController
-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.tabBarController.tabBar.hidden = NO;
    self.navigationItem.titleView = nil;
    self.navigationItem.titleView = nil;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"Academic";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    // Do any additional setup after loading the view.
    [self otherviews];
}
//创建滑动页面
-(void)otherviews {
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50) titles:@[@"Documents",@"Extracurricular Activities",@"Transcript",@"Tests"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleFont = [UIFont systemFontOfSize:15];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:15];
    self.titleView.selectIndex = 0;
    self.titleView.titleSelectColor = [UIColor blackColor];
    self.titleView.titleNormalColor = [UIColor grayColor];
    self.titleView.indicatorColor = [UIColor blackColor];
    [self.view addSubview:_titleView];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    DocumentsViewController * documentslv = [[DocumentsViewController alloc]init];
    
   ZNextractivitiesController  * view2=[[ZNextractivitiesController alloc]init];
    
    ZNTestsViewController * view3 = [[ZNTestsViewController alloc]init];
    
    ZNAcdViewController * view4 = [[ZNAcdViewController alloc]init];
    view4.view.backgroundColor = [UIColor whiteColor];
    [childVCs addObject:documentslv];
    [childVCs addObject:view2];
    [childVCs addObject:view4];
    [childVCs addObject:view3];
    
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    //    self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
    [self.view addSubview:_pageContentView];
    UILabel * fglab = [[UILabel alloc]initWithFrame:CGRectMake(0, 50.5, SCREEN_HEIGHT, 0.8)];
    fglab.backgroundColor=[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
    [self.view addSubview:fglab];
}

#pragma mark -- 滑动delegate
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
//    self.title = @[@"Documents",@"Extracurricular Activities",@"academic",@"tests"][endIndex];
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
//    self.title = @[@"Documents",@"Extracurricular Activities",@"academic",@"tests"][endIndex];
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
