//
//  ReportViewController.m
//  TTD
//
//  Created by quakoo on 2018/1/29.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "ReportViewController.h"
#import "Photo.h"
#import "FSScrollContentView.h"//滑动使用
#import "TodotaskViewController.h"
#import "proViewController.h"
@interface ReportViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic,strong) NSMutableArray *taskarr;

@end

@implementation ReportViewController

#pragma mark - 导航右侧
-(void)navleft {
    NSLog(@"点击了Save按钮");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _taskarr=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = nil;
    self.navigationItem.titleView.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    title.text = @"Progress Report";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
//    title.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_leftblack"] style:UIBarButtonItemStylePlain target:self action:@selector(navleft)];
    
    //头部
    UIImageView * iconV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 30, 30)];
    iconV.layer.cornerRadius = 15;
    iconV.layer.masksToBounds = YES;
    if (self.icon.length>5) {
        iconV.image = [Photo string2Image:self.icon];
    }else{
        iconV.image = [UIImage imageNamed:@"defaultUSerImage"];
    }
    
    
    UILabel * namelab = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, SCREEN_WIDTH-90, 30)];
    UILabel * rightlab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH-25, 30)];
    [rightlab setTextColor:[UIColor lightGrayColor]];
    [rightlab setTextAlignment:NSTextAlignmentRight];
    [rightlab setFont:[UIFont systemFontOfSize:13]];
    namelab.text = self.name;
    rightlab.text = self.rigstr;
    [self.view addSubview:iconV];
    [self.view addSubview:namelab];
    [self.view addSubview:rightlab];
    [self otherviews];
}
//创建滑动页面
-(void)otherviews {
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.view.bounds), 50) titles:@[@"To-do Tasks",@"Progress Report"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleFont = [UIFont systemFontOfSize:15];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:15];
    self.titleView.selectIndex = 0;
    self.titleView.titleSelectColor = [UIColor blackColor];
    self.titleView.titleNormalColor = [UIColor grayColor];
    self.titleView.indicatorColor = [UIColor blackColor];
    [self.view addSubview:_titleView];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    TodotaskViewController * todoV = [[TodotaskViewController alloc]init];
    todoV.view.backgroundColor = [UIColor whiteColor];
//    todoV.datasout = self.todoarr;
    todoV.intg = self.indpath;
    proViewController * proV = [[proViewController alloc]init];
    proV.view.backgroundColor = [UIColor whiteColor];
    proV.datasout = self.repotarr;
    [childVCs addObject:todoV];
    [childVCs addObject:proV];
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    //    self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
    [self.view addSubview:_pageContentView];
    UILabel * fglab = [[UILabel alloc]initWithFrame:CGRectMake(0, 120.6, SCREEN_HEIGHT, 1)];
    fglab.backgroundColor= [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
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


@end
