//
//  ManagerHomeViewController.m
//  TTD
//
//  Created by quakoo on 2018/1/24.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "ManagerHomeViewController.h"

@interface ManagerHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableV;
@property (nonatomic,strong)NSMutableArray * oldonearr;
@property (nonatomic,strong)NSMutableArray * oldtwoarr;
@property (nonatomic,strong)NSMutableArray * oldthreearr;
@property (nonatomic,strong)NSMutableArray * newonearr;
@property (nonatomic,strong)NSMutableArray * newtwoarr;
@property (nonatomic,strong)NSMutableArray * newthreearr;
@property (nonatomic,assign) BOOL isManager;
@end

@implementation ManagerHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.   TABRELOAD
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    NSString * styr=SharedAppDelegate.role;
    if ([styr isEqualToString:@"manager"]) {
        //经理
        _isManager = YES;
    }
    
    
    
    
    
    self.navigationItem.titleView = nil;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"ThinkTank Learning";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    _oldonearr = [[NSMutableArray alloc]init];
    _oldtwoarr = [[NSMutableArray alloc]init];
    _oldthreearr = [[NSMutableArray alloc]init];
    _newonearr = [[NSMutableArray alloc]init];
    _newtwoarr = [[NSMutableArray alloc]init];
    _newthreearr = [[NSMutableArray alloc]init];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(superreloadview) name:@"TABRELOAD" object:nil];
    //
    [self getConsultantThinktankLearningServic];
}
//
//-(void)superreloadview {
//    [self getConsultantThinktankLearningServic];
//}

#pragma mark - getConsultantThinktankLearningServic
-(void)getConsultantThinktankLearningServic {
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_ConsultantThinkTankLearningService parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         ZNgetConsultantThinktanKlearningService * znconstult = [ZNgetConsultantThinktanKlearningService responseWithDDXMLDocument:XMLDocument];
         NSString * json = znconstult.getconstultant;
         //         NSLog(@"成功===%@",json);
         NSDictionary  * jsondic = [SharedAppDelegate dictionaryWithJsonString:json];
         NSLog(@"===getConsultantThinktankLearningServic === %@",jsondic);
         for (NSDictionary * dic in jsondic) {
             //             NSLog(@"dic===%@",[dic objectForKey:@"Title"]);
             [_oldonearr addObject:dic];
         }
         
         [self getAllToDoTasks];
         
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"getConsultantThinktankLearningServic失败===%@",error);
     }];
    [operation start];
}

#pragma mark - AllToDoTasks
-(void)getAllToDoTasks {
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_AllToDoTasks parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         ZNgetAllToDoTasks * znalltodotasks = [ZNgetAllToDoTasks responseWithDDXMLDocument:XMLDocument];
         NSString * json = znalltodotasks.getAllToDoTasks;
         //         NSLog(@"成功===%@",json);
         NSDictionary  * jsondic = [SharedAppDelegate dictionaryWithJsonString:json];
         NSLog(@"===AllToDoTasks === %@",jsondic);
         for (NSDictionary * dic in jsondic) {
             [_oldtwoarr addObject:dic];
         }
         [self getUPCOMINGMEETING];
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"AllToDoTasks失败===%@",error);
     }];
    [operation start];
}

#pragma mark -getUPCOMINGMEETING
-(void)getUPCOMINGMEETING {
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_UPCOMINGMEETING parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         ZNgetUPCOMINGMEETING * znupcoming = [ZNgetUPCOMINGMEETING responseWithDDXMLDocument:XMLDocument];
         NSString * json = znupcoming.getupcomingmetting;
         
         NSLog(@"成功===%lu",(unsigned long)json.length);
         NSDictionary  * jsondic = [SharedAppDelegate dictionaryWithJsonString:json];
         NSLog(@"===getUPCOMINGMEETING === %@",jsondic);
         //NSDictionary * updic =@{@"upss":@"znup"};
         //NSDictionary * down  =@{@"upss":@"zndown"};
         //NSDictionary * conten=@{@"upss":@"znno"};
         //[_oldthreearr addObject:updic];
         //[_oldthreearr addObject:conten];
         //[_oldthreearr addObject:jsondic];
         _oldthreearr =jsondic;
         if(_oldthreearr.count==0)
         {
             NSDictionary *NoMeeting =@{@"Name":@"NoMeeting"};
             [_oldthreearr addObject:NoMeeting];
         }
         [self createUI];
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"getUPCOMINGMEETING失败===%@",error);
     }];
    [operation start];
}




-(void)createUI {
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50) style:UITableViewStyleGrouped];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //    if(@available(iOS 11.0,*))
    //    {
    //        _tableV.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    //    }else
    //    {
    //        self.automaticallyAdjustsScrollViewInsets=NO;
    //    }
    //    _tableV.estimatedRowHeight=0;
    //    _tableV.estimatedSectionHeaderHeight=0;
    //    _tableV.estimatedSectionFooterHeight=0;
    [self.view addSubview:_tableV];
}

#pragma mark - TableDelegate
//分组个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
//分组cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_isManager == YES) {
        if (section ==0) {
            return _oldtwoarr.count+1;
        }else if (section ==1){
            return _oldthreearr.count+1;
        }
    }else{
        if (section ==0) {
            
            return _oldonearr.count+1;
        }else if (section ==1) {
            return _oldtwoarr.count+1;
        }else if (section == 2) {
            //        return _threearr.count;
            return _oldthreearr.count+1;
        }
    }
    return 0;
}
//cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isManager == YES)
    {
        if (indexPath.section==0)
        {
            //临时禁用 all to-do list
            return 0;
        }
    }
    else
    {
        if (indexPath.section==1)
        {
            //临时禁用顾问 all to-do list
            return 0;
        }
    }
    return 50;
    
}
////分组头间距
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    if (_isManager == YES)
//    {
//        if (section==0)
//        {
//            //临时禁用 all to-do list
//            return 0.01;
//        }
//    }
//    else
//    {
//        if (section==1)
//        {
//            //临时禁用顾问 all to-do list
//            return 0.01;
//        }
//    }
//    return 0.01;
//}
////分组尾部间距
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (_isManager == YES)
//    {
//        if (section==1)
//        {
//            //临时禁用 all to-do list
//            return 0.01;
//        }
//    }
//    else
//    {
//        if (section==2)
//        {
//            //临时禁用顾问 all to-do list
//            return 0.01;
//        }
//    }
//    return 0.01;
//}
////分组头
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//   
//    if (_isManager == YES)
//    {
//        if (section==1)
//        {
//            //临时禁用 all to-do list
//            return nil;
//        }
//    }
//    else
//    {
//        if (section==2)
//        {
//            //临时禁用顾问 all to-do list
//            return nil;
//        }
//    }
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
//    return view;
//}
////分组尾
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//    if (_isManager == YES)
//    {
//        if (section==1)
//        {
//            //临时禁用 all to-do list
//            return nil;
//        }
//    }
//    else
//    {
//        if (section==2)
//        {
//            //临时禁用顾问 all to-do list
//            return nil;
//        }
//    }
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
//    return view;
//}

//cell样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:name];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:name];;
    }
    
    if (_isManager == YES) {
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 25, 20)];
                imageV.image = [UIImage imageNamed:@"ToDoTask"];
                UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 49.5, SCREEN_WIDTH-20, 1)];
                downlab.backgroundColor = [UIColor colorWithRed:0.92 green:0.27 blue:0.30 alpha:1.00];
                UILabel * lab  = [[UILabel alloc]init];
                lab .frame=CGRectMake(60, 10, SCREEN_WIDTH, 30);
                [lab setTextColor:[UIColor colorWithRed:0.92 green:0.27 blue:0.30 alpha:1.00]];
                lab.text =@"ALL TO-DO TASKS";
                //[cell addSubview:imageV];
                //[cell addSubview:lab];
                //[cell addSubview:downlab];
            }else{
                NSDictionary * sectiondic = _oldtwoarr[indexPath.row-1];
                UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 25, 25)];
                UILabel * uplab = [[UILabel alloc]init];
                UILabel * downlab = [[UILabel alloc]init];
                //                NSString * str=[NSString stringWithFormat:@"%@",[sectiondic objectForKey:@"ComplateDate"]];
                NSString * str=@"Assigned by Andy";
                NSString * NorY=[NSString stringWithFormat:@"%@",[sectiondic objectForKey:@"IsComplete"]];
                uplab.text = [sectiondic objectForKey:@"Content"];
                downlab.text = str;
                [downlab setTextColor:[UIColor lightGrayColor]];
                
                if ([str isEqualToString:@"ZNUP"]) {
                    imageV.image = [UIImage imageNamed:@"ToDoTask"];
                    uplab.frame =CGRectMake(20, 10, SCREEN_WIDTH, 30);
                }else if ([str isEqualToString:@"ZNDOWN"]){
                    UIButton  *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but .frame = CGRectMake(20, 10, SCREEN_WIDTH, 30);
                    [but setTitle:@"See More" forState:UIControlStateNormal];
                    [cell addSubview:but];
                }
                
                uplab.frame =CGRectMake(50, 5, SCREEN_WIDTH, 20);
                downlab.frame = CGRectMake(50, 25, SCREEN_WIDTH, 20);
                if ([NorY isEqualToString:@"N"]) {
                    imageV.image = [UIImage imageNamed:@"ToDoquan"];
                }else{
                    imageV.image = [UIImage imageNamed:@"ToDoTask"];
                }
                //[cell addSubview:downlab];
                //[cell addSubview:imageV];
                //[cell addSubview:uplab];
            }
            
        }else if (indexPath.section ==1){
            if (indexPath.row == 0) {
                UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 20, 20)];
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
                NSDictionary * dic = _oldthreearr[indexPath.row-1];
                NSString *NoMeeting = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Name"]];
                if([NoMeeting isEqualToString:@"NoMeeting"])
                {
                    UILabel * onelab = [[UILabel alloc]initWithFrame:CGRectMake(25, 15, SCREEN_WIDTH-10, 20)];
                    [onelab setFont:[UIFont systemFontOfSize:12]];
                    [onelab setTextColor:[UIColor lightGrayColor]];
                    onelab.text=@"No Meeting";
                    [cell addSubview:onelab];
                }
                else
                {
                    NSString * name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Subject"]];
                    NSString * startim =[NSString stringWithFormat:@"%@",[dic objectForKey:@"StartDatetimeStr"]];
                    NSString * endtime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"EndDatetimeStr"]];
                    NSString * newstar = [self getUTCFormateLocalDate:startim];
                    NSString * newed = [self getUTCFormateLocalDate:endtime];
                    
                    UILabel * onelab = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, SCREEN_WIDTH-10, 20)];
                    UILabel * twolab = [[UILabel alloc]initWithFrame:CGRectMake(25, 25, SCREEN_WIDTH-10, 20)];
                    onelab.text=name;
                    twolab.text = [NSString stringWithFormat:@"%@,%@ - %@",[dic objectForKey:@"StartDate"],newstar,newed];
                    [onelab setTextColor:[UIColor blackColor]];
                    [twolab setTextColor:[UIColor lightGrayColor]];
                    [onelab setFont:[UIFont systemFontOfSize:17]];
                    [twolab setFont:[UIFont systemFontOfSize:12]];
                    [cell addSubview:onelab];
                    [cell addSubview:twolab];
                }
                
            }
            
        }
        
        
    }else{
        if (indexPath.section == 0) {
            if (indexPath.row ==0) {
                UILabel * labe=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH, 30)];
                labe.text = @"THINKTANK LEARNING SERVICE";
                UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 49.5, SCREEN_WIDTH-20, 1)];
                downlab.backgroundColor = [UIColor grayColor];
                [cell addSubview:downlab];
                [cell addSubview:labe];
            }else{
                NSDictionary * sectiondic = _oldonearr[indexPath.row-1];
                UILabel * lab = [[UILabel alloc]init];
                UILabel * olab = [[UILabel alloc]init];
                lab.textAlignment = NSTextAlignmentRight;
                lab.text = [sectiondic objectForKey:@"Value"];
                [lab setTextColor:[UIColor blackColor]];
                olab.text = [sectiondic objectForKey:@"Title"];
                [olab setTextColor:[UIColor blackColor]];
                lab.frame=CGRectMake(SCREEN_WIDTH-100, 10, 80, 30);
                olab .frame=CGRectMake(20, 10, SCREEN_WIDTH-100, 30);
                [cell addSubview:lab];
                [cell addSubview:olab];
            }
            
        }else if (indexPath.section ==1){
            
            if (indexPath.row == 0) {
                UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 25, 20)];
                imageV.image = [UIImage imageNamed:@"ToDoTask"];
                UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 49.5, SCREEN_WIDTH-20, 1)];
                downlab.backgroundColor = [UIColor colorWithRed:0.92 green:0.27 blue:0.30 alpha:1.00];
                UILabel * lab  = [[UILabel alloc]init];
                lab .frame=CGRectMake(60, 10, SCREEN_WIDTH, 30);
                [lab setTextColor:[UIColor colorWithRed:0.92 green:0.27 blue:0.30 alpha:1.00]];
                lab.text =@"ALL TO-DO TASKS";
                //临时禁用 All to-do tasks
                //[cell addSubview:imageV];
                //[cell addSubview:lab];
                //[cell addSubview:downlab];
            }else{
                NSDictionary * sectiondic = _oldtwoarr[indexPath.row-1];
                UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 25, 25)];
                UILabel * uplab = [[UILabel alloc]init];
                UILabel * downlab = [[UILabel alloc]init];
                NSString * str=[NSString stringWithFormat:@"%@",[sectiondic objectForKey:@"ComplateDate"]];
                NSString * NorY=[NSString stringWithFormat:@"%@",[sectiondic objectForKey:@"IsComplete"]];
                uplab.text = [sectiondic objectForKey:@"Content"];
                downlab.text = str;
                [downlab setTextColor:[UIColor lightGrayColor]];
                
                if ([str isEqualToString:@"ZNUP"]) {
                    imageV.image = [UIImage imageNamed:@"ToDoTask"];
                    uplab.frame =CGRectMake(20, 10, SCREEN_WIDTH, 30);
                }else if ([str isEqualToString:@"ZNDOWN"]){
                    UIButton  *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but .frame = CGRectMake(20, 10, SCREEN_WIDTH, 30);
                    [but setTitle:@"See More" forState:UIControlStateNormal];
                    [cell addSubview:but];
                }
                
                uplab.frame =CGRectMake(50, 5, SCREEN_WIDTH, 20);
                downlab.frame = CGRectMake(50, 25, SCREEN_WIDTH, 20);
                if ([NorY isEqualToString:@"N"]) {
                    imageV.image = [UIImage imageNamed:@"ToDoquan"];
                }else{
                    imageV.image = [UIImage imageNamed:@"ToDoTask"];
                }
                //临时禁用 All to-do tasks
                //[cell addSubview:downlab];
                //[cell addSubview:imageV];
                //[cell addSubview:uplab];
            }
            
        }else if (indexPath.section ==2){
            if (indexPath.row == 0) {
                UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 25, 20)];
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
                
                NSDictionary * dic = _oldthreearr[indexPath.row-1];
                NSString *NoMeeting = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Name"]];
                if([NoMeeting isEqualToString:@"NoMeeting"])
                {
                    UILabel * onelab = [[UILabel alloc]initWithFrame:CGRectMake(25, 15, SCREEN_WIDTH-10, 20)];
                    [onelab setFont:[UIFont systemFontOfSize:12]];
                    [onelab setTextColor:[UIColor lightGrayColor]];
                    onelab.text=@"No Meeting";
                    [cell addSubview:onelab];
                }
                else
                {
                    NSString * name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Subject"]];
                    NSString * startim =[NSString stringWithFormat:@"%@",[dic objectForKey:@"StartDatetimeStr"]];
                    NSString * endtime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"EndDatetimeStr"]];
                    NSString * newstar = [self getUTCFormateLocalDate:startim];
                    NSString * newed = [self getUTCFormateLocalDate:endtime];
                    
                    UILabel * onelab = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, SCREEN_WIDTH-10, 20)];
                    UILabel * twolab = [[UILabel alloc]initWithFrame:CGRectMake(25, 25, SCREEN_WIDTH-10, 20)];
                    onelab.text=name;
                    twolab.text = [NSString stringWithFormat:@"%@,%@ - %@",[dic objectForKey:@"StartDate"],newstar,newed];
                    [onelab setTextColor:[UIColor blackColor]];
                    [twolab setTextColor:[UIColor lightGrayColor]];
                    [onelab setFont:[UIFont systemFontOfSize:17]];
                    [twolab setFont:[UIFont systemFontOfSize:12]];
                    [cell addSubview:onelab];
                    [cell addSubview:twolab];
                }
            }
            
        }
        
    }
    
    
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

//cell 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isManager == YES) {
        if (indexPath.section ==0) {
            if (indexPath.row==0) {
                
            }else{
                
            }
            
        }else if (indexPath.section ==1){
            if (indexPath.row==0) {
                
            }else{
                
            }
        }
        
    }else{
        if (indexPath.section ==1) {
            if (indexPath.row>0) {
                NSDictionary * sectiondic = _oldtwoarr[indexPath.row-1];
                [LEEAlert alert].config
                .LeeTitle(@"")
                .LeeContent([NSString stringWithFormat:@"%@",sectiondic])
                .LeeAction(@"确认", ^{
                    
                })
                .LeeShow();
            }
        }
    }
    
    
    
}




//分组头
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 50)];
//    customView.backgroundColor = [UIColor  clearColor];
//
//
//
//    UILabel * headerlab = [[UILabel alloc]initWithFrame:CGRectZero];
//    headerlab.backgroundColor = [UIColor blueColor];
//    headerlab.text =@" 分组头";
//    headerlab.textColor = [UIColor redColor];
//    headerlab.font = [UIFont boldSystemFontOfSize:18];
//    headerlab.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, 40);
//    headerlab.layer.cornerRadius = 15;
//    headerlab.layer.masksToBounds = YES;
//    [customView addSubview:headerlab];
//    return customView;
//
//}
////分组尾
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    footview.backgroundColor = [UIColor whiteColor];
//    UILabel * footlab = [[UILabel alloc]initWithFrame:CGRectZero];
//    footlab.backgroundColor = [UIColor whiteColor];
//    footlab.textColor = [UIColor blueColor];
//    footlab.text =@"尾部";
//    footlab.font = [UIFont boldSystemFontOfSize:15];
//    footlab.frame = CGRectMake(20, 0, SCREEN_WIDTH, 30);
//    [footview addSubview:footlab];
//
//    return footview;
//}
////分组头间距
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}
////分组尾部间距
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 100;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
