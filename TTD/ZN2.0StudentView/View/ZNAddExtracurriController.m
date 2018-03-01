//
//  ZNAddExtracurriController.m
//  TTD
//
//  Created by quakoo on 2017/12/6.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "ZNAddExtracurriController.h"
#import "ZNAddVolunteerViewController.h"
@interface ZNAddExtracurriController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableV;


@end

@implementation ZNAddExtracurriController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = nil;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"Add Extracurricular Activity";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_white"] style:UIBarButtonItemStylePlain target:self action:@selector(navleft)];
    
    self.tabBarController.tabBar.hidden = YES;
    

    [self createTab];
}
#pragma mark - 导航点击
-(void)navleft {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTab {
    self.tableV =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150) style:UITableViewStylePlain];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.scrollEnabled = NO;
    if ([self.tableV respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableV setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableV respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableV setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:self.tableV];
}
#pragma mark -table代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

#pragma mark 必须实现的方法---设置单元格的个数
//设置每个分区的行数（单元格个数）
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
#pragma mark 必须实现的方法 -- 设置单元格的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"identifiersss";
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor=[UIColor blackColor];
    UIImageView * cellimg=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-35, 15, 15, 20)];
    cellimg.image=[UIImage imageNamed:@"arrow_black"];
    [cell addSubview:cellimg];
     
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Volunteer & Community Service";
        
    }else if (indexPath.row ==1){
        cell.textLabel.text = @"Working Experience";
    }else if (indexPath.row ==2){
        cell.textLabel.text =@"Extracurricular Activity";
    }
    
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"点击的是第%ld个",(long)indexPath.row);
//    if(indexPath.row == 0){
        ZNAddVolunteerViewController * addvolunt = [[ZNAddVolunteerViewController alloc]init];
        addvolunt.cellid = [NSString stringWithFormat:@"%ld",indexPath.row];
        [self.navigationController pushViewController:addvolunt animated:YES];
    
    
    //    NSInteger row =[indexPath row];
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
