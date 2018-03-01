//
//  StudentMainViewController.m
//  TTD
//
//  Created by quakoo on 2017/12/5.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "StudentMainViewController.h"
#import "DataModel.h"
#import <QuartzCore/QuartzCore.h>
#import "Photo.h"
#import "AppDelegate.h"
#import "BCTabBarController.h"
#import "XMPPHelper.h"
#import "XMPPvCardTemp.h"
#import "NewParentSettingViewController.h"
#import "ZNChatMessageViewController.h"
#import "ZNNewParentViewController.h"
//#import "UIViewController+CWLateralSlide.h"//抽屉
@interface StudentMainViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UISearchBar *customSearchBar;
    UIButton *lefttView ;
}
@property (nonatomic,strong) XMPPvCardTemp *vcard;
@property (nonatomic,strong) UIImage * iamge;

@property (nonatomic,strong)UITableView * tableV;
@property (nonatomic,strong)NSDictionary * datadic;
@property (nonatomic,strong)NSMutableArray * upmeeting;
@property (nonatomic,strong)NSMutableArray * apslist;
@property (nonatomic,strong)NSMutableArray * contalist;
@end

@implementation StudentMainViewController
@synthesize photo;
- (void)viewDidLoad {
    [super viewDidLoad];
    customSearchBar.hidden = YES;
    lefttView .hidden = NO;
    //    self.navigationItem.titleView = nil;
    _iamge = [[UIImage alloc]init];
    _datadic = [[NSDictionary alloc]init];
    // Do any additional setup after loading the view.
    
    //     [self performSelector:@selector(getallinfor) withObject:nil afterDelay:20.0];
    //     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getallinfor) name:@"TABRELOAD" object:nil];
    
    
    if (self.userIDs.length>1) {
        
        lefttView.hidden= YES;
    }else{
        [self performSelector:@selector(createNavBarImage) withObject:nil afterDelay:6.0];
        lefttView.hidden = NO;
    }
    
    
    
    [self createUI];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSLog(@"沙盒路径==== %@",paths);
    [self getallinfor];
}
-(void)viewWillAppear:(BOOL)animated {
    customSearchBar.hidden = YES;
    if (self.userIDs.length>1) {
        lefttView.hidden= YES;
    }else{
        lefttView.hidden = NO;
    }
    
    self.tabBarController.tabBar.hidden = NO;
}


-(void)getallinfor {
    NSString * userID =[[NSString alloc]init];
    if (self.userIDs.length>1) {
        userID = self.userIDs;
    }else{
        //userID =SharedAppDelegate.username;
        userID=@"0";
    }
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            userID, @"userid",
                            SharedAppDelegate.role, @"usercurren",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_StudentAllInfo parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         ZNgetStudentAllInfo * znconstult = [ZNgetStudentAllInfo responseWithDDXMLDocument:XMLDocument];
         NSString * json = znconstult.getallinfo;
         NSLog(@"shouye成功===");
         _datadic = [SharedAppDelegate dictionaryWithJsonString:json];
         _contalist =[_datadic objectForKey:@"ContactList"];
         _apslist =[_datadic objectForKey:@"APscoresList"];
         _upmeeting =[_datadic objectForKey:@"UP_COMING_MEETING_List"];
         
         //         NSLog(@"===FUNC_GET_StudentAllInfo === %@",_datadic);
         
         
         [self createtableV];
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"FUNC_GET_StudentAllInfo失败===%@",error);
     }];
    [operation start];
}
-(void)createtableV {
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60) style:UITableViewStyleGrouped];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableV.tableFooterView = [UIView new];
    
    [self.view addSubview:_tableV];
}
#pragma mark - TableDelegate
//分组个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}
//分组cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0) {
        return 1+ _contalist.count;
    }else if (section ==1) {
        return 3;
    }else if (section == 2) {
        //        return _threearr.count;
        if ([[NSString stringWithFormat:@"%@",[_datadic objectForKey:@"All_To_Do_Tasks"]] isEqualToString:@"You have 0 to-do tasks."]) {
            return 0;
        }else
        {
            return 2;
        }
    }else if (section ==3){
        return _upmeeting.count+1;
    }else if (section ==4){
        return 5;
    }else if (section ==5){
        return 5+_apslist.count;
    }else if (section ==6){
        return 5;
    }
}
//cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
-(void)chatbutton:(UIButton *)button{
    UITableViewCell *cell = (UITableViewCell *)[button superview] ;
    // 获取cell的indexPath
    NSIndexPath *indexPath = [self.tableV indexPathForCell:cell];
    //    NSLog(@"点击的是第%ld行按钮",button.tag);
    //    NSLog(@"row=%ld\nsec=%ld\n",indexPath.row,indexPath.section);
    
    NSDictionary * dic = _contalist[indexPath.row-1];
    NSString *userid = [dic objectForKey:@"Id"];
    NSString * username = [dic objectForKey:@"TitleName"];
    NSString * photo = [dic objectForKey:@"Photo"];
    
    ZNChatMessageViewController * znchat = [[ZNChatMessageViewController alloc]init];
    znchat.ToUserPhoto = photo;
    znchat.userNickname = username;
    znchat.chatWithUser = [NSString stringWithFormat:@"%@@%@",userid,OpenFireHostName];
    customSearchBar.hidden = YES;
    lefttView .hidden = YES;
    [self.navigationController pushViewController:znchat animated:YES];
    
}

//cell样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:name];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:name];;
    }
    if (indexPath.section ==0) {
        if (indexPath.row ==0) {
            UILabel * titlab = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, SCREEN_WIDTH-25, 30)];
            titlab.text =@"THINKTANK LEARNING SERVICE";
            [cell addSubview:titlab];
            UILabel * llab = [[UILabel alloc]initWithFrame:CGRectMake(10, 49.5, SCREEN_WIDTH -20, 1)];
            llab.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
            [cell addSubview:llab];
            
        }else{
            NSDictionary * dic = _contalist[indexPath.row-1];
            NSString * name = [dic objectForKey:@"name"];
            NSString * titlename = [dic objectForKey:@"TitleName"];
            NSString * role = [dic objectForKey:@"Role"];
            NSString * downname = [dic objectForKey:@"TitleName"];
            NSString * phot=[dic objectForKey:@"Photo"];
            UIImageView * icon =[[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 30, 30)];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 260, 20)];
            UILabel * labRole = [[UILabel alloc]initWithFrame:CGRectMake(80, 25, 260, 20)];
            [labRole setTextColor:[UIColor lightGrayColor]];
            [labRole setTextAlignment:NSTextAlignmentLeft];
            [labRole setFont:[UIFont systemFontOfSize:12]];
            UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(80, 25, 100, 20)];
            [downlab setTextColor:[UIColor lightGrayColor]];
            if (phot.length>10) {
                icon.image = [Photo string2Image:phot];
            }else{
                icon.image= [UIImage imageNamed:@"defaultUSerImage.png"];
            }
            
            lab.text =titlename;
            labRole.text=role;
            downlab.text = downname;
            icon.layer.cornerRadius = 15;
            icon.layer.masksToBounds = YES;
            //按钮
            UIButton * buttone = [UIButton buttonWithType:UIButtonTypeCustom];
            buttone.frame = CGRectMake(SCREEN_WIDTH-60, 10, 20, 20);
            UIButton * butttwo = [UIButton buttonWithType:UIButtonTypeCustom];
            butttwo.frame = CGRectMake(SCREEN_WIDTH-100, 10, 20, 20);
            [buttone setImage:[UIImage imageNamed:@"TapBar_Chat.png"] forState:UIControlStateNormal];
            [butttwo setImage:[UIImage imageNamed:@"TapBar_Chat.png"] forState:UIControlStateNormal];
            
            [buttone addTarget:self action:@selector(chatbutton:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString * username = [dic objectForKey:@"name"];
            if ([username isEqualToString:SharedAppDelegate.username]) {
                
            }else{
                [cell addSubview:buttone];
            }
            
            //            [cell addSubview:butttwo];
            [cell addSubview:icon];
            [cell addSubview:lab];
            [cell addSubview:labRole];
        }
        
    }else if (indexPath.section ==1){
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, SCREEN_WIDTH-40, 25)];
        UILabel * labtwo = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, SCREEN_WIDTH-55, 25)];
        [labtwo setTextColor:[UIColor lightGrayColor]];
        [labtwo setTextAlignment:NSTextAlignmentRight];
        [cell addSubview: lab];
        [cell addSubview:labtwo];
        if (indexPath.row == 0) {
            lab.text=@"School";
            labtwo.text = [NSString stringWithFormat:@"%@",[_datadic objectForKey:@"School"]];
        }else if (indexPath.row ==1){
            lab.text=@"Grade";
            labtwo.text = [NSString stringWithFormat:@"%@",[_datadic objectForKey:@"Grade"]];
        }else if (indexPath.row ==2){
            lab.text=@"Education Consultant";
            labtwo.text = [NSString stringWithFormat:@"%@",[_datadic objectForKey:@"EducationConsultant"]];
            [labtwo setFont:[UIFont systemFontOfSize:14]];
        }
    }else if (indexPath.section ==2){
        if ([[NSString stringWithFormat:@"%@",[_datadic objectForKey:@"All_To_Do_Tasks"]] isEqualToString:@"You have 0 to-do tasks."]) {
            
        }else
        {
            if (indexPath.row ==0) {
                UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 20, 20)];
                imageV.image = [UIImage imageNamed:@"tododuihao.png"];
                UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 49.5, SCREEN_WIDTH-20, 1)];
                downlab.backgroundColor = [UIColor colorWithRed:0.92 green:0.27 blue:0.30 alpha:1.00];
                UILabel * lab  = [[UILabel alloc]init];
                lab .frame=CGRectMake(60, 10, SCREEN_WIDTH, 30);
                [lab setTextColor:[UIColor colorWithRed:0.92 green:0.27 blue:0.30 alpha:1.00]];
                lab.text =@"ALL TO-DO TASKS";
                [cell addSubview:imageV];
                [cell addSubview:lab];
                [cell addSubview:downlab];
            }else if (indexPath.row ==1){
                UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, SCREEN_WIDTH-30, 30)];
                lab.text = [NSString stringWithFormat:@"%@",[_datadic objectForKey:@"All_To_Do_Tasks"]];
                [cell addSubview:lab];
            }
        }
    }else if (indexPath.section ==3){
        if (indexPath.row == 0) {
            UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 20, 20)];
            imageV.image = [UIImage imageNamed:@"meetings"];
            UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 49.5, SCREEN_WIDTH-20, 1)];
            downlab.backgroundColor = [UIColor colorWithRed:0.28 green:0.46 blue:0.67 alpha:1.00];
            UILabel * lab  = [[UILabel alloc]init];
            lab .frame=CGRectMake(60, 10, SCREEN_WIDTH, 30);
            [lab setTextColor:[UIColor colorWithRed:0.28 green:0.46 blue:0.67 alpha:1.00]];
            lab.text =@"UPCOMING MEETING";
            [cell addSubview:imageV];
            [cell addSubview:lab];
            [cell addSubview:downlab];
        }else{
            NSDictionary * dic =_upmeeting[indexPath.row-1];
            NSString * name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Subject"]];
            
            NSString * startim =[NSString stringWithFormat:@"%@",[dic objectForKey:@"StartDatetimeStr"]];
            NSString * endtime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"EndDatetimeStr"]];
            NSString * newstar = [self getUTCFormateLocalDate:startim];
            NSString * newed = [self getUTCFormateLocalDate:endtime];
            
            UILabel * onelab = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, SCREEN_WIDTH-10, 20)];
            UILabel * twolab = [[UILabel alloc]initWithFrame:CGRectMake(25, 25, SCREEN_WIDTH-10, 20)];
            onelab.text=name;
            twolab.text = [NSString stringWithFormat:@"%@. %@ - %@",[dic objectForKey:@"StartDate"],newstar,newed];
            [onelab setTextColor:[UIColor blackColor]];
            [twolab setTextColor:[UIColor lightGrayColor]];
            [onelab setFont:[UIFont systemFontOfSize:17]];
            [twolab setFont:[UIFont systemFontOfSize:12]];
            [cell addSubview:onelab];
            [cell addSubview:twolab];
        }
    }else if (indexPath.section ==4){
        UILabel * lab = [[UILabel alloc]init];
        UILabel * olab = [[UILabel alloc]init];
        lab.textAlignment = NSTextAlignmentRight;
        [lab setTextColor:[UIColor blackColor]];
        [olab setTextColor:[UIColor blackColor]];
        lab.frame=CGRectMake(20, 10, SCREEN_WIDTH-55, 30);
        olab .frame=CGRectMake(30, 10, SCREEN_WIDTH-150, 30);
        
        if (indexPath.row == 0) {
            UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 25, 20)];
            imageV.image = [UIImage imageNamed:@"GGAcademic_active"];
            UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 49.5, SCREEN_WIDTH-20, 1)];
            downlab.backgroundColor = [UIColor colorWithRed:0.27 green:0.49 blue:0.31 alpha:1.00];
            UILabel * lab  = [[UILabel alloc]init];
            lab .frame=CGRectMake(60, 10, SCREEN_WIDTH, 30);
            [lab setTextColor:[UIColor colorWithRed:0.27 green:0.49 blue:0.31 alpha:1.00]];
            lab.text =@"TRANSCRIPT";
            [cell addSubview:imageV];
            [cell addSubview:lab];
            [cell addSubview:downlab];
        }else if (indexPath.row ==1){
            olab.text=@"Unweighted GPA";
            lab.text =[_datadic objectForKey:@"Unweighted_GPA"];
            [cell addSubview:lab];
            [cell addSubview:olab];
        }else if (indexPath.row == 2){
            olab.text=@"Weighted GPA";
            lab.text = [_datadic objectForKey:@"Weighted_GPA"];
            [cell addSubview:lab];
            [cell addSubview:olab];
        }else if (indexPath.row ==3){
            olab.text=@"AG Units";
            lab.text = [_datadic objectForKey:@"AG_Units"];
            [cell addSubview:lab];
            [cell addSubview:olab];
        }else if (indexPath.row ==4){
            olab.text =@"H/AP";
            lab.text = [_datadic objectForKey:@"H_AP"];
            [cell addSubview:lab];
            [cell addSubview:olab];
        }
    }else if (indexPath.section ==5){
        UILabel * lab = [[UILabel alloc]init];
        UILabel * olab = [[UILabel alloc]init];
        lab.textAlignment = NSTextAlignmentRight;
        [lab setTextColor:[UIColor blackColor]];
        [olab setTextColor:[UIColor blackColor]];
        lab.frame=CGRectMake(20, 10, SCREEN_WIDTH-55, 30);
        olab .frame=CGRectMake(30, 10, SCREEN_WIDTH-150, 30);
        if (indexPath.row ==0) {
            UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 25, 20)];
            imageV.image = [UIImage imageNamed:@"GGAcademic_active"];
            UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 49.5, SCREEN_WIDTH-20, 1)];
            downlab.backgroundColor = [UIColor colorWithRed:0.27 green:0.49 blue:0.31 alpha:1.00];
            UILabel * lab  = [[UILabel alloc]init];
            lab .frame=CGRectMake(60, 10, SCREEN_WIDTH, 30);
            [lab setTextColor:[UIColor colorWithRed:0.27 green:0.49 blue:0.31 alpha:1.00]];
            lab.text =@"TESTS";
            [cell addSubview:imageV];
            [cell addSubview:lab];
            [cell addSubview:downlab];
        }else if (indexPath.row==1){
            olab.text=@"SAT";
            lab.text =[_datadic objectForKey:@"SAT"];
            [cell addSubview:lab];
            [cell addSubview:olab];
        }else if (indexPath.row==2){
            olab.text=@"ACT";
            lab.text =[_datadic objectForKey:@"ACT"];
            [cell addSubview:lab];
            [cell addSubview:olab];
        }else if (indexPath.row==3){
            olab.text=@"TOEFL";
            lab.text=[_datadic objectForKey:@"TOEFL"];
            [cell addSubview:lab];
            [cell addSubview:olab];
        }else if (indexPath.row==4){
            olab.text=@"AP Scores";
            lab.text=[_datadic objectForKey:@""];
            [cell addSubview:lab];
            [cell addSubview:olab];
        }else{
            NSLog(@"test 5-5 == %@",_apslist);
            NSDictionary * dic = _apslist[indexPath.row-5];
            lab.frame=CGRectMake(40, 10, SCREEN_WIDTH-80, 20);
            olab .frame=CGRectMake(60, 10, SCREEN_WIDTH-80, 20);
            olab.text=[dic objectForKey:@"Title"];
            lab.text =[dic objectForKey:@"Number"];
            [cell addSubview:lab];
            [cell addSubview:olab];
        }
    }else if (indexPath.section ==6){
        UILabel * lab = [[UILabel alloc]init];
        UILabel * olab = [[UILabel alloc]init];
        lab.textAlignment = NSTextAlignmentRight;
        [lab setTextColor:[UIColor blackColor]];
        [olab setTextColor:[UIColor blackColor]];
        lab.frame=CGRectMake(20, 10, SCREEN_WIDTH-55, 30);
        olab .frame=CGRectMake(30, 10, SCREEN_WIDTH-150, 30);
        if (indexPath.row ==0) {
            UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 25, 20)];
            imageV.image = [UIImage imageNamed:@"GGAcademic_active"];
            UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 49.5, SCREEN_WIDTH-20, 1)];
            downlab.backgroundColor = [UIColor colorWithRed:0.27 green:0.49 blue:0.31 alpha:1.00];
            UILabel * lab  = [[UILabel alloc]init];
            lab .frame=CGRectMake(60, 10, SCREEN_WIDTH, 30);
            [lab setTextColor:[UIColor colorWithRed:0.27 green:0.49 blue:0.31 alpha:1.00]];
            [lab setFont:[UIFont systemFontOfSize:12]];
            lab.text =@"EXTRACURRICULAR ACTIVITIES";
            [cell addSubview:imageV];
            [cell addSubview:lab];
            [cell addSubview:downlab];
        }else if (indexPath.row ==1){
            olab.text=@"Total EA Hours";
            lab.text=[_datadic objectForKey:@"Total_Ea_Hours"];
            [cell addSubview:lab];
            [cell addSubview:olab];
        }else if (indexPath.row ==2){
            olab.text=@"Total Volunteer Hours";
            lab.text=[_datadic objectForKey:@"Total_Volunteer_Hours"];
            [cell addSubview:lab];
            [cell addSubview:olab];
        }else if (indexPath.row==3){
            olab.text=@"Total Leadership";
            lab.text=[_datadic objectForKey:@"Total_Leadership"];
            [cell addSubview:lab];
            [cell addSubview:olab];
        }else if (indexPath.row ==4){
            olab.text=@"Total Awards";
            lab.text=[_datadic objectForKey:@"Total_Awards"];
            [cell addSubview:lab];
            [cell addSubview:olab];
        }
    }
    
    
    return  cell;
}
#pragma mark - 时间差处理
-(NSString *)getUTCFormateLocalDate:(NSString *)localDate
{
    
    //str————》date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];//系统所在时区
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 3600]];// 东8
    NSDate *retdate = [dateFormatter dateFromString:localDate];
    
    //输出
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    dateFormat2.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [dateFormat2 setDateFormat:@"h:mm a"];
    NSString * str = [dateFormat2 stringFromDate:retdate];
    NSLog(@"%@ == %@",[dateFormat2 stringFromDate:retdate],str);
    return [NSString stringWithFormat:@"%@",[dateFormat2 stringFromDate:retdate]];
}
//cell 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.userIDs.length>1) {
        lefttView.hidden= YES;
    }else{
        if (indexPath.section == 2) {
            NSLog(@"点击的是 all to-do tasks");
            self.tabBarController.selectedIndex = 1;
        }
    }
    
    
    
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 8.0f;//section头部高度
    }
    
    return 0.01f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    
    //    view.layer.cornerRadius = 6.0;
    //    view.layer.borderWidth = 1.0;
    //    view.layer.borderColor = [[UIColor whiteColor] CGColor];
    //    view.layer.shadowColor=[UIColor grayColor].CGColor;
    //    view.layer.shadowOffset=CGSizeMake(0, 0);
    //    view.layer.shadowOpacity=0.5;
    //    view.layer.shadowRadius=5;
    
    return view;
}

// 重新绘制cell边框
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 圆角弧度半径
    CGFloat cornerRadius = 6.f;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds, 10, 0);
    
    // CGRectGetMinY：返回对象顶点坐标
    // CGRectGetMaxY：返回对象底点坐标
    // CGRectGetMinX：返回对象左边缘坐标
    // CGRectGetMaxX：返回对象右边缘坐标
    // CGRectGetMidX: 返回对象中心点的X坐标
    // CGRectGetMidY: 返回对象中心点的Y坐标
    
    // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
    
    // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
    if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        // 添加cell的rectangle信息到path中（不包括圆角）
        CGPathAddRect(pathRef, nil, bounds);
    }
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    // cell的背景view
    cell.backgroundView = roundView;
    
    // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
    // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
    backgroundLayer.fillColor = [UIColor whiteColor].CGColor;
    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectedBackgroundView;
    
    
    
}










-(void)createNavBarImage {
    //读取xmppvcard 设置头像
    self.vcard=[XMPPHelper getmyvcard];
    if (SharedAppDelegate.imageStr.length>0) {
        UIImage * pp = [Photo string2Image:SharedAppDelegate.imageStr];
        _iamge = pp;
    }else{
        _iamge = [UIImage imageNamed:@"defaultUSerImage.png"];
    }
    lefttView = [[UIButton alloc] init];
    if (UI_Is_iPhoneX) {
        lefttView.frame = CGRectMake(20, 40, 40, 40);
    }else{
        lefttView.frame = CGRectMake(20, 20, 40, 40);
    }
    [lefttView setImage:_iamge forState:UIControlStateNormal];
    [lefttView addTarget:self action:@selector(leftimg) forControlEvents:UIControlEventTouchUpInside];
    lefttView.layer.cornerRadius = 20;
    lefttView.layer.masksToBounds = YES;
    [self.navigationController.view addSubview:lefttView];
    
    UIImageView*saveImgv=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,22,22)];
    
    
    if (SharedAppDelegate.imageStr.length>0) {
        UIImage * pp = [Photo string2Image:SharedAppDelegate.imageStr];
        _iamge = pp;
    }else{
        _iamge = [UIImage imageNamed:@"defaultUSerImage.png"];
    }
    
    saveImgv.image=_iamge;//保存   UIBarButtonItemStyleBordere
    saveImgv.layer.cornerRadius = 88;
    saveImgv.layer.masksToBounds = YES;
    UIBarButtonItem*saveBitem=[[UIBarButtonItem alloc]initWithCustomView:saveImgv];
    
    UIBarButtonItem * spacebar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    spacebar.width=-10;//间隔作用
    
    //    self.navigationItem.leftBarButtonItems=@[spacebar,saveBitem];
    
    
    
}

-(void)createUI {
    
    
    if (UI_Is_iPhoneX) {
        CGRect mainViewBounds = self.navigationController.view.bounds;
        customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetWidth(mainViewBounds)/2-((CGRectGetWidth(mainViewBounds)-120)/2), CGRectGetMinY(mainViewBounds)+22+20, CGRectGetWidth(mainViewBounds)-120, 40)];
    }else{
        //nav搜索框
        CGRect mainViewBounds = self.navigationController.view.bounds;
        customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetWidth(mainViewBounds)/2-((CGRectGetWidth(mainViewBounds)-120)/2), CGRectGetMinY(mainViewBounds)+22, CGRectGetWidth(mainViewBounds)-120, 40)];
    }
    customSearchBar.delegate = self;
    customSearchBar.backgroundColor = [UIColor clearColor];
    customSearchBar.placeholder = @"Search";
    customSearchBar.showsCancelButton = NO;
    customSearchBar.tintColor = [UIColor orangeColor];
    customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.navigationController.view addSubview: customSearchBar];
    //添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
#pragma mark - 键盘回收
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [customSearchBar resignFirstResponder];
}




#pragma mark - 导航右侧按钮
-(void)leftimg {
    NSLog(@"点击了导航右侧按钮");
    ZNNewParentViewController * znpar = [[ZNNewParentViewController alloc]init];
    lefttView.hidden = YES;
    [self.navigationController pushViewController:znpar animated:YES];
    //    NewParentSettingViewController * newpar = [[NewParentSettingViewController alloc]init];
    //    [self presentViewController:newpar animated:YES completion:nil];
    //    newpar.view.alpha = 0.75;
    //    // 调用这个方法
    //    [self cw_showDrawerViewController:newpar animationType:CWDrawerAnimationTypeDefault configuration:nil];
}
-(void)viewWillDisappear:(BOOL)animated {
    
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
