//
//  UPMeetingViewController.m
//  TTD
//
//  Created by quakoo on 2018/1/8.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "UPMeetingViewController.h"
#import "DataModel.h"
#import "MettingModel.h"
#include "Photo.h"
#import "YUFoldingTableView.h"
#import "PastCellTableViewCell.h"
#import "MTitleViewController.h"
#import "ZNManyPeopleVideoViewController.h"
@interface UPMeetingViewController ()<YUFoldingTableViewDelegate,YUFoldingSectionHeaderDelegate>
{
    NSMutableArray * ToDayArr;
    NSMutableArray * ScheduleArr;
}
@property (nonatomic, weak) YUFoldingTableView *foldingTableView;
@end

@implementation UPMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ToDayArr = [[NSMutableArray alloc]init];
    ScheduleArr = [[NSMutableArray alloc]init];
    NSLog(@"登录用户名 = %@  密码 = %@   分组=%@",SharedAppDelegate.username, SharedAppDelegate.password,SharedAppDelegate.role);
       [MBManager showLoading];
    [self requestXML];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.71 green:0.15 blue:0.18 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
      self.tabBarController.tabBar.hidden = NO;
//    [MBManager showLoading];
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
//         DLog(@"成功===%@",json);
         self.jsonDic = [SharedAppDelegate dictionaryWithJsonString:json];

         NSArray * todayarr = [_jsonDic objectForKey:@"Today"];
         NSArray * schearr = [_jsonDic objectForKey:@"ScheduledMeeting"];
         
         for (NSDictionary * MeetingDic in todayarr) {
             //模型赋值
              MettingModel * model = [[MettingModel alloc]init];
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
             [ToDayArr addObject:model];
         }
         for (NSDictionary * MeetingDic in schearr) {
//             NSDictMeetingDicionary * MeetingDic = [dic objectForKey:@"Meeting"];
             //模型赋值
              MettingModel * model = [[MettingModel alloc]init];
             model.LoginName          =      [MeetingDic objectForKey:@"LoginName"];
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
             
             [ScheduleArr addObject:model];
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             [self CreateTableV];
             [MBManager hideAlert];
         });
         
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"失败===%@",error);
     }];
    [operation start];
}

-(void)CreateTableV {
    self.automaticallyAdjustsScrollViewInsets = NO;
    YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    _foldingTableView = foldingTableView;
    
    [self.view addSubview:foldingTableView];
    foldingTableView.foldingDelegate = self;
     [foldingTableView registerNib:[UINib nibWithNibName:@"PastCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"meeting"];
    foldingTableView.foldingState = YUFoldingSectionStateShow;
     foldingTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    if ([foldingTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [foldingTableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([foldingTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [foldingTableView setLayoutMargins: UIEdgeInsetsZero];
    }
}
//下拉
-(void)refresh{
     ToDayArr =[[NSMutableArray alloc]init];
    ScheduleArr=[[NSMutableArray alloc]init];
    [self requestXML];
}
#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
// 返回箭头的位置
- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
  return YUFoldingSectionHeaderArrowPositionRight;
   
}
//箭头图片
- (UIImage *)yuFoldingTableView:(YUFoldingTableView *)yuTableView arrowImageForSection:(NSInteger )section{
    return [UIImage imageNamed:@""];
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
       
        if (ToDayArr.count ==0) {
            return 1;
        }else{
         return ToDayArr.count;
        }
       
    }else if (section==1){
        if (ScheduleArr.count ==0) {
            return 1;
        }else{
            return ScheduleArr.count;
        }
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
    return 70;
}
//section 文字--大小
- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section
{
    
    NSArray * arr=@[@"  Today",@"  Scheduled Meeting   "];
    return [NSString stringWithFormat:@"%@",arr[section]];
}
-(UIFont *)yuFoldingTableView:(YUFoldingTableView *)yuTableView fontForTitleInSection:(NSInteger)section
{
    return [UIFont systemFontOfSize:19];
}

- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"mmcell%ld%ld",indexPath.section,indexPath.row];
    PastCellTableViewCell * cell=[yuTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PastCellTableViewCell" owner:self options:nil]lastObject];
    }
    
    cell.UPLabel.text = @"Meeting title";
    cell.MeetNow.frame = CGRectMake(self.view.frame.size.width-124, 15, 104, 40);
//    [cell.DownLabel setFont:[UIFont systemFontOfSize:15]];
    cell.DownLabel.adjustsFontSizeToFitWidth = YES;
    cell.DownLabel.textAlignment = NSTextAlignmentLeft;
    cell.DownLabel .font = [UIFont systemFontOfSize:20];
    cell.MeetNow.layer.cornerRadius = 10;
    cell.MeetNow.layer.masksToBounds = YES;
    if (indexPath.section ==0) {
        
        if (ToDayArr.count == 0) {
            cell.UPLabel.text = @"      No Meeting";
            cell.UPLabel.frame = cell.frame;
            [cell.UPLabel setTextAlignment:NSTextAlignmentLeft];
            [cell.DownLabel setFont:[UIFont systemFontOfSize:10]];
            cell.DownLabel.text =@"";
            cell.LeftV.hidden = NO;
            cell.MeetNow.hidden = YES;
        }else{
            MettingModel * model = ToDayArr[indexPath.row];
            NSString * starstr=[self getUTCFormateLocalDate:model.StartDatetimeStr];
            NSString * endstr = [self getUTCFormateLocalDate:model.EndDatetimeStr];
            NSLog(@"开始时间=%@  \n 结束时间=%@",starstr,endstr);
            cell.UPLabel.text = model.Subject;
            [cell.DownLabel setFont:[UIFont systemFontOfSize:10]];
            cell.DownLabel.text =[NSString stringWithFormat:@"%@ - %@",starstr,endstr];
            cell.LeftV.hidden = NO;
            cell.MeetNow.hidden = NO;
        }

    }else if (indexPath.section ==1) {
        if (ScheduleArr.count == 0) {
            cell.UPLabel.text = @"      No Meeting";
            cell.UPLabel.frame = cell.frame;
            [cell.UPLabel setTextAlignment:NSTextAlignmentLeft];
            cell.DownLabel.frame = CGRectMake(16, 33, self.view.frame.size.width, 21);
            cell.DownLabel.text =@"";
            cell.LeftV.hidden = YES;
            cell.MeetNow.hidden = YES;
        }else{
            MettingModel * model = ScheduleArr[indexPath.row];
            NSString * starstr=[self getUTCFormateLocalDate:model.StartDatetimeStr];
            NSString * endstr = [self getUTCFormateLocalDate:model.EndDatetimeStr];
            NSLog(@"cc开始时间=%@  \n 结束时间=%@",starstr,endstr);
            cell.UPLabel.text = model.Subject;
            cell.DownLabel.frame = CGRectMake(16, 33, self.view.frame.size.width, 21);
            cell.DownLabel.text =[NSString stringWithFormat:@"%@. %@ - %@",model.StartDate,starstr,endstr];
            cell.LeftV.hidden = YES;
            cell.MeetNow.hidden = YES;
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
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


- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (ToDayArr.count == 0) {
            NSLog(@"没有数据");
        }else{
            MettingModel * model = ToDayArr[indexPath.row];
            NSArray * userarr = model.Users;
            NSMutableArray *userid=[[NSMutableArray alloc]init];
            
            for (NSDictionary * dic in userarr) {
                
                [userid addObject:[dic objectForKey:@"LoginName"]];
            }
            
            NSMutableArray * VideoUser = [[NSMutableArray alloc]init];
            NSString * myUser =[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *numTemp = [numberFormatter numberFromString:myUser];
            NSString * newtemp = [NSString stringWithFormat:@"%@",numTemp];
            
            [userid enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if (newtemp !=nil) {
                    if ([obj isEqualToString:newtemp]) {
                        *stop = YES;
                        if (*stop == YES) {
                            [userid removeObjectAtIndex:idx];
                        }
                    }
                    
                    if (*stop) {
                        NSLog(@"array is %@",userid);
                    }
                }
                
            }];
            
            
            for (int i=0; i<userid.count; i++) {
                
                [VideoUser addObject:[NSString stringWithFormat:@"%@@%@",userid[i],OpenFireHostName]];
            }
//            [VideoUser addObject:myUser];
            NSLog(@"==Meeting 视频会议人员 ==%@",VideoUser);
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
            NSString * sessionID = [NSString stringWithFormat:@"%@%f",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"],interval];
            NSString *string = [userid componentsJoinedByString:@"||"];
//            for (int i=0; i<VideoUser.count; i++) {
//                NSString * bodystr=  [NSString stringWithFormat:@"chatVideoUI//%@//%@",sessionID,string];
//                
//                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                // 设置时间格式
//                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                NSString *dateString = [formatter stringFromDate:[NSDate date]];
//                NSString * bodyStr=[NSString stringWithFormat:@"%@*%@",dateString,bodystr];
//                NSMutableString *soundString = [[NSMutableString alloc]initWithString:@"[/9]"];
//                [soundString appendString:bodyStr];
//                //    NSLog(@"发送的音频数据===%@",soundString);
//                //发送消息
//                //XMPPFramework主要是通过KissXML来生成XML文件
//                //生成<body>文档
//                NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//                [body setStringValue:soundString];
//                //生成XML消息文档
//                NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
//                //消息类型
//                [mes addAttributeWithName:@"type" stringValue:@"chat"];
//                //发送给谁
//                [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@",VideoUser[i]]];
//                //由谁发送
//                [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
//                //组合
//                [mes addChild:body];
//                NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
//                [mes addChild:received];
//                [[XMPPServer xmppStream] sendElement:mes];
//                NSLog(@"发起视频请求==%@  接收者==%@",soundString,VideoUser[i]);
//            }
            ZNManyPeopleVideoViewController * znm=[[ZNManyPeopleVideoViewController alloc]init];
            znm.videoapiKey=model.TokboxApiKey;
            znm.videosecert = model.TokboxSecret;
            znm.videoSeesion = model.TokboxSession;
            znm.mtarr = VideoUser;
            NSLog(@"修改后的参会人员==%@",VideoUser);
            [self presentViewController:znm animated:YES completion:nil];
        }

    }else if (indexPath.section ==1){
        if (ScheduleArr.count == 0) {
            NSLog(@"没有数据");
        }else{
            MettingModel * model = ScheduleArr[indexPath.row];
            NSString * starstr=[self getUTCFormateLocalDate:model.StartDatetimeStr];
            NSString * endstr = [self getUTCFormateLocalDate:model.EndDatetimeStr];
            MTitleViewController * mtitleV = [[MTitleViewController alloc]init];
            mtitleV.MeetingtitleStr = @"Meeting title";
            mtitleV.UserArr = model.Users;
            mtitleV.mettingTimeStr = [NSString stringWithFormat:@"%@. ",model.StartDate];//Meeting time:
            mtitleV.dourationStr = [NSString stringWithFormat:@"%@ - %@",starstr,endstr];//Duration:
            [self.navigationController pushViewController:mtitleV animated:YES];
        }
    }
    
}
#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView backgroundColorForHeaderInSection:(NSInteger)section
{
    
    return [UIColor whiteColor];
}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForTitleInSection:(NSInteger)section
{
    return  [UIColor colorWithRed:0.55 green:0.66 blue:0.79 alpha:1.00] ;
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
