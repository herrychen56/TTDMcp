//
//  MTitleViewController.m
//  TTD
//
//  Created by 张楠 on 2018/1/9.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "MTitleViewController.h"
#include "Photo.h"
#import "MTitleModel.h"
#import "ZNManyPeopleVideoViewController.h"
#import "QCPopView.h"

@interface MTitleViewController () <YUFoldingTableViewDelegate,YUFoldingSectionHeaderDelegate,QCPopViewDelegate>
{
     NSMutableArray * oneArr;
    NSMutableArray * UserID;
}
@property (nonatomic, weak) YUFoldingTableView *foldingTableView;
@property (nonatomic, strong) QCPopView *QCPopView;

@end

@implementation MTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    oneArr = [[NSMutableArray alloc]init];
    UserID = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [self setupFoldingTableView];
}
#pragma mark - 设置状态栏颜色
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)setupFoldingTableView
{
    
    for (NSDictionary * dic in _UserArr) {
        MTitleModel * model = [[MTitleModel alloc]init];
        model.UserRole = [dic objectForKey:@"UserRole"];
        model.UserName = [dic objectForKey:@"UserName"];
        model.MeetingUserPhoto = [dic objectForKey:@"MeetingUserPhoto"];
        [oneArr addObject:model];
        [UserID addObject:[dic objectForKey:@"UserID"]];
    }
    
    UIView * heardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    heardView.backgroundColor = [UIColor whiteColor];
    UILabel * TitleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, self.view.frame.size.width-160, 40)];
    TitleLab.backgroundColor = [UIColor whiteColor];
    [TitleLab setText:self.meetingtitle];
    [TitleLab setTextColor:[UIColor blackColor]];
    [TitleLab setFont:[UIFont systemFontOfSize:22]];
    [heardView addSubview:TitleLab];
    if(self.videoArr.count>0)
    {
        UIButton * videobut = [UIButton buttonWithType:UIButtonTypeCustom];
        //    videobut.backgroundColor = [UIColor redColor];
        videobut.frame = CGRectMake(self.view.frame.size.width-100, 20, 40, 40);
        [videobut setImage:[UIImage imageNamed:@"meetingchat"] forState:UIControlStateNormal];
        [videobut addTarget:self action:@selector(meetingchatbut) forControlEvents:UIControlEventTouchUpInside];
        [heardView addSubview:videobut];
    }
    if(self.MeetingChatArr.count>0)
    {
        UIButton * chatbut = [UIButton buttonWithType:UIButtonTypeCustom];
        //    chatbut.backgroundColor = [UIColor blueColor];
        chatbut.frame =  CGRectMake(self.view.frame.size.width-50, 25, 30, 30);
        [chatbut setImage:[UIImage imageNamed:@"recording_play.png"] forState:UIControlStateNormal];
        [chatbut addTarget:self action:@selector(meetingvideobut) forControlEvents:UIControlEventTouchUpInside];
        [heardView addSubview:chatbut];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    _foldingTableView = foldingTableView;
    foldingTableView.tableHeaderView = heardView;
    
    [self.view addSubview:foldingTableView];
    foldingTableView.foldingDelegate = self;
    
    foldingTableView.foldingState = YUFoldingSectionStateShow;
    
    if ([foldingTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [foldingTableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([foldingTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [foldingTableView setLayoutMargins: UIEdgeInsetsZero];
    }
    
}
#pragma mark - 按钮点击事件
-(void)meetingchatbut {
    NSLog(@"meetingchatbut");
}
-(void)meetingvideobut {
    
    if (self.videoArr.count<1) {
        NSLog(@"meetingvideobut");
        [LEEAlert alert].config
        .LeeTitle(@"Message")
        .LeeContent(@"The current data is empty！")
        .LeeAction(@"Confirm", ^{
            
        })
        .LeeShow();
    }else{
        //初始化
        _QCPopView = [[QCPopView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height)];
        //遵守协议
        _QCPopView.QCPopViewDelegate = self;
        //传递数据
        NSMutableArray * videoarr = [self.videoArr mutableCopy];
        [_QCPopView showThePopViewWithArray:videoarr];
    }
}
#pragma mark - QCP 点击事件
-(void)getTheButtonTitleWithIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *buttonStr = self.videoArr[indexPath.row];
//    [_testButton setTitle:buttonStr forState:UIControlStateNormal];
//    [_QCPopView dismissThePopView];
    
    
}


#pragma mark-YUFoldingSectionHeaderDelegate section点击事件
-(void)yuFoldingSectionHeaderTappedAtIndex:(NSInteger)index{
    oneArr = nil;
}

#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
// 返回箭头的位置
- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    return YUFoldingSectionHeaderArrowPositionRight;
}
//箭头图片
- (UIImage *)yuFoldingTableView:(YUFoldingTableView *)yuTableView arrowImageForSection:(NSInteger )section{
    return [UIImage imageNamed:@"arrow_leftblack.png"];
}
//分组个数
- (NSInteger )numberOfSectionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    return 2;
}
//组里cell
- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section
{
    if (section==0) {
        return oneArr.count;
    }else if (section ==1){
        return 1;
    }
    return 0;
}
// section高度
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section
{
    
    return 50;
}
//cell 高度
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
         return 70;
    }else if (indexPath.section ==1) {
         return 220;
    }
    return 0;
}
//section 文字--大小
- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section
{

    NSArray * arr=@[@"  Invitee",@"  Meeting Time"];
    return [NSString stringWithFormat:@"%@",arr[section]];
}
-(UIFont *)yuFoldingTableView:(YUFoldingTableView *)yuTableView fontForTitleInSection:(NSInteger)section
{
    return [UIFont systemFontOfSize:19];
}

- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    

    UITableViewCell *cell = [yuTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //0
    UIImageView * iconimg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 50, 50)];
    iconimg.layer.cornerRadius = 25;
    iconimg.layer.masksToBounds = YES;
    UILabel * uplab = [[UILabel alloc]initWithFrame:CGRectMake(75, 10, 200, 20)];
    UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(75, 30, 300, 20)];
    [downlab setTextColor:[UIColor grayColor]];
    //1
    UILabel * seclab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.view.frame.size.width, 30)];
    UILabel * seclabtwo = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, self.view.frame.size.width, 30)];
    
    if (indexPath.section == 0) {
        MTitleModel * model = oneArr[indexPath.row];
        NSString * imagestr = model.MeetingUserPhoto;
        if (imagestr.length>1) {
            iconimg.image = [Photo string2Image:[NSString stringWithFormat:@"%@",model.MeetingUserPhoto]];
        }else{
            iconimg.image = [UIImage imageNamed:@"videodefaultimage"];
        }
        uplab.text = [NSString stringWithFormat:@"%@",model.UserName];
        downlab.text =[NSString stringWithFormat:@"%@",model.UserRole];
        [cell addSubview:iconimg];
        [cell addSubview:uplab];
        [cell addSubview:downlab];
    }else if (indexPath.section ==1) {
        seclab.text=[NSString stringWithFormat:@"%@",self.mettingTimeStr];
        seclabtwo.text =[NSString stringWithFormat:@"%@",self.dourationStr];
        [cell addSubview:seclab];
        [cell addSubview:seclabtwo];
    }
   
    return cell;
}
- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）

//- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView descriptionForHeaderInSection:(NSInteger )section
//{
//    return @"detailText";
//}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView backgroundColorForHeaderInSection:(NSInteger)section
{
    
    return [UIColor whiteColor];
}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForTitleInSection:(NSInteger)section
{
    return  [UIColor blackColor] ;
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
