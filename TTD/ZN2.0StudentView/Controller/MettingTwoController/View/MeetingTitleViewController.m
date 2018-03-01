//
//  MeetingTitleViewController.m
//  TTD
//
//  Created by quakoo on 2018/1/9.
//  Copyright © 2018年 totem. All rights reserved.
// Meeting 跳转页面

#import "MeetingTitleViewController.h"
#include "Photo.h"
#import "MTitleModel.h"
@interface MeetingTitleViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView;//展示列表
    NSArray *titleArray;//第一层列表需要展示的数据
    NSMutableArray * oneArr;
    NSMutableArray * twoArr;
    NSDictionary * datadic;
}

@end

@implementation MeetingTitleViewController
//是否隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return NO;
}
//状态栏设置
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    oneArr = [[NSMutableArray alloc]init];
    twoArr = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    titleArray=[[NSArray alloc]initWithObjects:@"Invitee",@"Meeting Time", nil];
    // Do any additional setup after loading the view from its nib.
    [self CreateUI];
    
}

-(void)CreateUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * heardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    heardView.backgroundColor = [UIColor whiteColor];
    UILabel * TitleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, self.view.frame.size.width-180, 40)];
    TitleLab.backgroundColor = [UIColor whiteColor];
    [TitleLab setText:self.MeetingtitleStr];
    [TitleLab setTextColor:[UIColor blackColor]];
    [TitleLab setFont:[UIFont systemFontOfSize:22]];
    [heardView addSubview:TitleLab];
    
    UIButton * videobut = [UIButton buttonWithType:UIButtonTypeCustom];
//    videobut.backgroundColor = [UIColor redColor];
    videobut.frame = CGRectMake(self.view.frame.size.width-100, 20, 40, 40);
    [videobut setImage:[UIImage imageNamed:@"meetingchat"] forState:UIControlStateNormal];
    [videobut addTarget:self action:@selector(meetingchatbut) forControlEvents:UIControlEventTouchUpInside];
    [heardView addSubview:videobut];
    
    UIButton * chatbut = [UIButton buttonWithType:UIButtonTypeCustom];
//    chatbut.backgroundColor = [UIColor blueColor];
    chatbut.frame =  CGRectMake(self.view.frame.size.width-50, 20, 40, 40);
    [chatbut setImage:[UIImage imageNamed:@"meetingplay"] forState:UIControlStateNormal];
    [chatbut addTarget:self action:@selector(meetingvideobut) forControlEvents:UIControlEventTouchUpInside];
    
    [heardView addSubview:chatbut];
    
    
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.sectionFooterHeight=0;
    tableView.tableHeaderView = heardView;
    [self.view addSubview:tableView];
    
}
#pragma mark - 按钮点击事件
-(void)meetingchatbut {
    NSLog(@"meetingchatbut");
}
-(void)meetingvideobut {
    NSLog(@"meetingvideobut");
}


#pragma mark --tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回列表的行数
    return titleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return _UserArr.count;
    }else{
        return 0;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
//自定义section
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 2, self.view.frame.size.width-150, 30)];
    titleLabel.text=[titleArray objectAtIndex:section];
    titleLabel.backgroundColor = [UIColor whiteColor];
    [view addSubview:titleLabel];
    
    
    UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(self.view.frame.size.width -40, 5, 25, 25);
//    but.backgroundColor = [UIColor redColor];
    [but setImage:[UIImage imageNamed:@"xiajiantou"] forState:UIControlStateNormal];
    [view addSubview:but];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str=@"mtitle";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    UIImageView * iconimg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 50, 50)];
    iconimg.layer.cornerRadius = 25;
    iconimg.layer.masksToBounds = YES;
    UILabel * uplab = [[UILabel alloc]initWithFrame:CGRectMake(75, 10, 200, 20)];
    UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(75, 30, 300, 20)];
    [downlab setTextColor:[UIColor grayColor]];
    
   
    if (indexPath.section == 0) {

        for (NSDictionary * dic in _UserArr) {
            MTitleModel * model = [[MTitleModel alloc]init];
            model.UserRole = [dic objectForKey:@"UserRole"];
            model.UserName = [dic objectForKey:@"UserName"];
            model.MeetingUserPhoto = [dic objectForKey:@"MeetingUserPhoto"];
            [oneArr addObject:model];
        }
         MTitleModel * model = oneArr[indexPath.row];
        NSString * imagestr = model.MeetingUserPhoto;
        if (imagestr.length>1) {
             iconimg.image = [Photo string2Image:[NSString stringWithFormat:@"%@",model.MeetingUserPhoto]];
        }else{
            iconimg.image = [UIImage imageNamed:@"icon_student_photo"];
        }
        
        uplab.text = [NSString stringWithFormat:@"%@",model.UserName];
        downlab.text =[NSString stringWithFormat:@"%@",model.UserRole];
        
        [cell addSubview:iconimg];
        [cell addSubview:uplab];
        [cell addSubview:downlab];
    }
    
    
    
    return cell;
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

