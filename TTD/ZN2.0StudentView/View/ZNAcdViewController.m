//
//  ZNAcdViewController.m
//  TTD
//
//  Created by quakoo on 2018/1/30.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "ZNAcdViewController.h"

@interface ZNAcdViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableV;
@property (nonatomic,strong)NSMutableArray * dataSout;
@property (nonatomic,strong)NSMutableArray * dataarr;

@end

@implementation ZNAcdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"=====getStudentAcademicsResult========");
//       [MBManager showLoading];
    _dataarr = [[NSMutableArray alloc]init];
    _dataSout = [[NSMutableArray alloc]init];
    [self getStudentAcademicsResult];
}
-(void)viewWillDisappear:(BOOL)animated{
     [self getStudentAcademicsResult];
}

-(void)getStudentAcademicsResult {
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            SharedAppDelegate.username, @"userid",
                            SharedAppDelegate.role, @"usercurren",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_StudentAcademics parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         ZNgetStudentAcademics * znconstult = [ZNgetStudentAcademics responseWithDDXMLDocument:XMLDocument];
         NSString * json = znconstult.getStudentAcademics;
         NSDictionary * dic = [SharedAppDelegate dictionaryWithJsonString:json];
        
  
         for (NSArray * arr in dic) {
             [_dataSout addObject:arr];
//             _dataarr =[[NSMutableArray alloc]initWithArray:arr];
             
         }
       
     
         
        
         
         [self creaateUI];
         
          [MBManager hideAlert];
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"getConsultantThinktankLearningServic失败===%@",error);
     }];
    [operation start];
}
-(void)creaateUI {
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-150) style:UITableViewStyleGrouped];
    _tableV.dataSource =  self;
    _tableV.delegate = self;
    [self.view addSubview:_tableV];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return _dataSout.count;
    NSLog(@"分组个数===%lu",(unsigned long)_dataSout.count);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary * dic =  _dataSout[section];
    if (section ==0) {
        NSArray * arr = [dic objectForKey:@"GradeList"];
        return arr.count;
    }else if (section ==1){
        NSArray * arr = [dic objectForKey:@"GradeList"];
        return arr.count;
    }else if (section ==2){
        NSArray * arr = [dic objectForKey:@"SummerBeforeGradeList"];
        return arr.count;
    }else if (section ==3){
        NSArray * arr = [dic objectForKey:@"GradeList"];
        return arr.count;
    }else if (section ==4){
        NSArray * arr = [dic objectForKey:@"SummerBeforeGradeList"];
        return arr.count;
    }else if (section ==5){
        NSArray * arr = [dic objectForKey:@"GradeList"];
        return arr.count;
    }else if (section ==6){
        NSArray * arr = [dic objectForKey:@"SummerBeforeGradeList"];
        return arr.count;
    }else if (section ==7){
        NSArray * arr = [dic objectForKey:@"GradeList"];
        return arr.count;
    }else if (section ==8){
        NSArray * arr = [dic objectForKey:@"SummerBeforeGradeList"];
        return arr.count;
    }
    
  
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"mmcell%ld%ld",indexPath.section,indexPath.row];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel * uplab = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, SCREEN_WIDTH-25, 20)];
    UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(25, 25, SCREEN_WIDTH-25, 20)];
    [downlab setTextColor:[UIColor lightGrayColor]];
    [downlab setFont:[UIFont systemFontOfSize:13]];
    [cell addSubview:uplab];
    [cell addSubview:downlab];
    
    UILabel * onelab = [[UILabel alloc]init];
    UILabel * towlab = [[UILabel alloc]init];
    onelab.frame = CGRectMake(SCREEN_WIDTH-215, 10, 100, 30);
    towlab.frame = CGRectMake(SCREEN_WIDTH-110, 10,100, 30);
    onelab.layer.borderColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00].CGColor;
    onelab.layer.borderWidth = 1;
    towlab.layer.borderColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00].CGColor;
    towlab.layer.borderWidth = 1;
    
    onelab.layer.cornerRadius = 5;
    onelab.layer.masksToBounds = YES;
    towlab.layer.cornerRadius = 5;
    towlab.layer.masksToBounds = YES;
    
    [onelab setTextAlignment:NSTextAlignmentCenter];
    [towlab setTextAlignment:NSTextAlignmentCenter];
    onelab.backgroundColor = [UIColor whiteColor];
    towlab.backgroundColor = [UIColor whiteColor];
    [cell addSubview:onelab];
    [cell addSubview:towlab];
    NSDictionary * dic =  _dataSout[indexPath.section];
    if (indexPath.section ==0) {
        NSArray * arr = [dic objectForKey:@"GradeList"];
        NSDictionary * dic = arr[indexPath.row];
        uplab.text = [dic objectForKey:@"Course"];
        downlab.text = [dic objectForKey:@"SchoolName"];
        NSString * s2 =[dic objectForKey:@"S2"];
        NSString * s1 =[dic objectForKey:@"S1"];
        towlab.text = [NSString stringWithFormat:@"S2:%@", s2];
        onelab.text =[NSString stringWithFormat:@"S1:%@",s1];
        if (s1.length<1) {
            onelab.backgroundColor = [UIColor whiteColor];
        }
        if (s2.length<2) {
            towlab.backgroundColor =  [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
        }
       
    }else if (indexPath.section ==1){
        NSArray * arr = [dic objectForKey:@"GradeList"];
        NSDictionary * dic = arr[indexPath.row];
        uplab.text = [dic objectForKey:@"Course"];
        downlab.text = [dic objectForKey:@"SchoolName"];
        NSString * s2 =[dic objectForKey:@"S2"];
        NSString * s1 =[dic objectForKey:@"S1"];
        towlab.text = [NSString stringWithFormat:@"S2:%@", s2];
        onelab.text =[NSString stringWithFormat:@"S1:%@",s1];
        if (s1.length<1) {
            onelab.backgroundColor = [UIColor whiteColor];
        }
        if (s2.length<2) {
            towlab.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
        }
    }else if (indexPath.section ==2){
        NSArray * arr = [dic objectForKey:@"SummerBeforeGradeList"];
        NSDictionary * dic = arr[indexPath.row];
        uplab.text = [dic objectForKey:@"Course"];
        downlab.text = [dic objectForKey:@"Institution"];
        towlab.text = [NSString stringWithFormat:@"A+:%@", [dic objectForKey:@"Grade"]];
        onelab.layer.borderWidth = 0;
    }else if (indexPath.section ==3){
        NSArray * arr = [dic objectForKey:@"GradeList"];
        NSDictionary * dic = arr[indexPath.row];
        uplab.text = [dic objectForKey:@"Course"];
        downlab.text = [dic objectForKey:@"SchoolName"];
        NSString * s2 =[dic objectForKey:@"S2"];
        NSString * s1 =[dic objectForKey:@"S1"];
        towlab.text = [NSString stringWithFormat:@"S2:%@", s2];
        onelab.text =[NSString stringWithFormat:@"S1:%@",s1];
        if (s1.length<1) {
            onelab.backgroundColor = [UIColor whiteColor];
        }
        if (s2.length<2) {
            towlab.backgroundColor =  [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
        }
    }else if (indexPath.section ==4){
        NSArray * arr = [dic objectForKey:@"SummerBeforeGradeList"];
        NSDictionary * dic = arr[indexPath.row];
        uplab.text = [dic objectForKey:@"Course"];
        downlab.text = [dic objectForKey:@"Institution"];
         towlab.text = [NSString stringWithFormat:@"A+:%@", [dic objectForKey:@"Grade"]];
        onelab.layer.borderWidth = 0;
        
    }else if (indexPath.section ==5){
        NSArray * arr = [dic objectForKey:@"GradeList"];
        NSDictionary * dic = arr[indexPath.row];
        uplab.text = [dic objectForKey:@"Course"];
        downlab.text = [dic objectForKey:@"SchoolName"];
        NSString * s2 =[dic objectForKey:@"S2"];
        NSString * s1 =[dic objectForKey:@"S1"];
        towlab.text = [NSString stringWithFormat:@"S2:%@", s2];
        onelab.text =[NSString stringWithFormat:@"S1:%@",s1];
        if (s1.length<1) {
            onelab.backgroundColor = [UIColor whiteColor];
        }
        if (s2.length<2) {
            towlab.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
        }
    }else if (indexPath.section ==6){
        NSArray * arr = [dic objectForKey:@"SummerBeforeGradeList"];
    
        NSDictionary * dic = arr[indexPath.row];
        uplab.text = [dic objectForKey:@"Course"];
        downlab.text = [dic objectForKey:@"Institution"];
        towlab.text = [NSString stringWithFormat:@"A+:%@", [dic objectForKey:@"Grade"]];
        onelab.layer.borderWidth = 0;
    }else if (indexPath.section ==7){
        NSArray * arr = [dic objectForKey:@"GradeList"];
        NSDictionary * dic = arr[indexPath.row];
        uplab.text = [dic objectForKey:@"Course"];
        downlab.text = [dic objectForKey:@"SchoolName"];
        NSString * s2 =[dic objectForKey:@"S2"];
        NSString * s1 =[dic objectForKey:@"S1"];
        towlab.text = [NSString stringWithFormat:@"S2:%@", s2];
        onelab.text =[NSString stringWithFormat:@"S1:%@",s1];
        if (s1.length<1) {
            onelab.backgroundColor = [UIColor whiteColor];
        }
        if (s2.length<2) {
            towlab.backgroundColor =[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
        }
    }else if (indexPath.section ==8){
        NSArray * arr = [dic objectForKey:@"SummerBeforeGradeList"];
     
        NSDictionary * dic = arr[indexPath.row];
        uplab.text = [dic objectForKey:@"Course"];
        downlab.text = [dic objectForKey:@"Institution"];
        towlab.text = [NSString stringWithFormat:@"A+:%@", [dic objectForKey:@"Grade"]];
        onelab.layer.borderWidth = 0;
    }
    
    
    
    
    
    return cell;
}

#pragma mark 第section组显示的头部标题
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 50;
//}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//
//    NSDictionary * dic = _dataSout[section];
//    NSLog(@"======tititititititititit=========%@",[dic objectForKey:@"Title"]);
//    return [dic objectForKey:@"Title"];
//}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     NSDictionary * dic = _dataSout[section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];//
    
    //add your code behind
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 2.5, SCREEN_HEIGHT-25, 30)];
    [view addSubview:label];
    [label setTextColor:[UIColor lightGrayColor]];
    
    label.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Title"]];
    
    return view;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0 )];
    return view;
}


//自定义section头部的高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    
    return 30.0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


#pragma mark 第section组显示的尾部标题

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//}


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
