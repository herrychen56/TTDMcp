//
//  PastMeetingViewController.m
//  TTD
//
//  Created by quakoo on 2018/1/8.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "PastMeetingViewController.h"
#import "PastCellTableViewCell.h"
#import "DataModel.h"
#import "MettingModel.h"
#import "MTitleViewController.h"//cell跳转

@interface PastMeetingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableV;
@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation PastMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"METTING === %@",self.jsonDic);
    self.jsonDic = [[NSDictionary alloc]init];
 
    [self requestXML];
  
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
//     [MBManager showLoading];
//    [self requestXML];
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
//                  DLog(@"成功===%@",json);
         //数据解析-划分模型
         self.jsonDic = [SharedAppDelegate dictionaryWithJsonString:json];
         _dataSource = [[NSMutableArray alloc]init];
         
         NSArray * PastMeetings = [_jsonDic objectForKey:@"PastMeetings"];
         for (NSDictionary * dic in PastMeetings) {
             NSDictionary * MeetingDic = [dic objectForKey:@"Meeting"];
             //模型赋值
             MettingModel * model = [[MettingModel alloc]init];
             model.MeeintVideo        =      [dic objectForKey:@"MeeintVideo"];
             model.MeetingChat        =      [MeetingDic objectForKey:@"MeetingChat"];
             model.BeginTime          =      [MeetingDic objectForKey:@"BeginTime"];
             model.ContainSelf        =      [MeetingDic objectForKey:@"ContainSelf"];
             model.CreatedByID        =      [MeetingDic objectForKey:@"CreatedByID"];
             model.CreatedByName      =      [MeetingDic objectForKey:@"CreatedByName"];
             model.CreatedByRole      =      [MeetingDic objectForKey:@"CreatedByRole"];
             model.Duration           =      [MeetingDic objectForKey:@"Duration"];
             model.EndDatetime        =      [MeetingDic objectForKey:@"EndDatetime"];
             model.EndDatetimeStr     =      [MeetingDic objectForKey:@"EndDatetimeStr"];
             model.EndTime            =      [MeetingDic objectForKey:@"EndTime"];
             model.IsEdit             =      [MeetingDic objectForKey:@"IsEdit"];
             model.MeetingID          =      [MeetingDic objectForKey:@"MeetingID"];
             model.MeetingUrl         =      [MeetingDic objectForKey:@"MeetingUrl"];
             model.MeetingUserID      =      [MeetingDic objectForKey:@"MeetingUserID"];
             model.StartDate          =      [MeetingDic objectForKey:@"StartDate"];
             model.StartDatetime      =      [MeetingDic objectForKey:@"StartDatetime"];
             model.StartDatetimeStr   =      [MeetingDic objectForKey:@"StartDatetimeStr"];
             model.Subject            =      [MeetingDic objectForKey:@"Subject"];
             model.TokboxApiKey       =      [MeetingDic objectForKey:@"TokboxApiKey"];
             model.TokboxSecret       =      [MeetingDic objectForKey:@"TokboxSecret"];
             model.TokboxSession      =      [MeetingDic objectForKey:@"TokboxSession"];
             model.TokboxUserKey      =      [MeetingDic objectForKey:@"TokboxUserKey"];
             model.Users              =      [MeetingDic objectForKey:@"Users"];
             model.LoginName          =      [MeetingDic objectForKey:@"LoginName"];
             [_dataSource addObject:model];
         }

          [self CreateTableV];
         [MBManager hideAlert];
  
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"失败===%@",error);
     }];
    [operation start];
}

-(void)CreateTableV {
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0,5, SCREEN_WIDTH, SCREEN_HEIGHT-64-100) style:UITableViewStylePlain];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    [self.tableV registerNib:[UINib nibWithNibName:@"PastCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"meeting"];
    self.tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [self.view addSubview:self.tableV];
    if ([self.tableV respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableV setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([self.tableV respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableV setLayoutMargins: UIEdgeInsetsZero];
    }
}
//下拉
-(void)refresh{
    _dataSource =[[NSMutableArray alloc]init];

    [self requestXML];
}
//表格行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
//单元格样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString * str=@"meeting";
    PastCellTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"CustonTableViewCell" owner:self options:nil]lastObject];
    }
    MettingModel * model = _dataSource[indexPath.row];
    NSString * starstr=[self getUTCFormateLocalDate:model.StartDatetimeStr];
    NSString * endstr = [self getUTCFormateLocalDate:model.EndDatetimeStr];
    NSLog(@"原有开始=%@ 原有结束=%@ \n开始时间=%@ 结束时间 = %@",model.StartDatetimeStr,model.EndDatetimeStr,starstr,endstr);
    cell.UPLabel.text = model.Subject;
     [cell.DownLabel setFont:[UIFont systemFontOfSize:15]];
    cell.DownLabel.frame = CGRectMake(16, 33, self.view.frame.size.width, 21);
    cell.DownLabel.text =[NSString stringWithFormat:@"%@. %@ - %@",model.StartDate,starstr,endstr];
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MettingModel * model = _dataSource[indexPath.row];
    NSString * starstr=[self getUTCFormateLocalDate:model.StartDatetimeStr];
    NSString * endstr = [self getUTCFormateLocalDate:model.EndDatetimeStr];
    MTitleViewController * mtitleV = [[MTitleViewController alloc]init];
    mtitleV.MeetingtitleStr = @"Meeting title";
    mtitleV.UserArr = model.Users;
    mtitleV.mettingTimeStr = [NSString stringWithFormat:@"%@ ",model.StartDate];//Meeting time:
    mtitleV.dourationStr = [NSString stringWithFormat:@"%@ - %@",starstr,endstr];//Duration:
    mtitleV.videoArr = model.MeeintVideo;
    mtitleV.MeetingChatArr = model.MeetingChat;
    mtitleV.meetingtitle =model.Subject;
    [self.navigationController pushViewController:mtitleV animated:YES];
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
- (NSDate *)getLocalFromUTC:(NSString *)utc

{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [dateFormatter setTimeZone:timeZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    NSDate *ldate = [dateFormatter dateFromString:utc];
    
   
    
    return ldate;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
