//
//  ExtrSectionViewController.m
//  TTD
//
//  Created by quakoo on 2018/1/30.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "ExtrSectionViewController.h"
#import "Photo.h"
#import "ZNAddVolunteerViewController.h"
@interface ExtrSectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableV;
@property (nonatomic,strong)NSMutableArray * onearr;
@property (nonatomic,strong)NSMutableArray * twoarr;
@property (nonatomic,strong)NSMutableArray * threearr;
@end

@implementation ExtrSectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = nil;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    // Do any additional setup after loading the view.
    _onearr = [[NSMutableArray alloc]init];
    _twoarr = [[NSMutableArray alloc]init];
    _threearr = [[NSMutableArray alloc]init];
    [self getALLEA];
}
-(void)getALLEA {
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            SharedAppDelegate.username, @"studentId",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_ALLEA parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         ZNgetALLEA * znallet = [ZNgetALLEA responseWithDDXMLDocument:XMLDocument];
         NSString * json = znallet.getALLEA;
         NSDictionary  * jsondic = [SharedAppDelegate dictionaryWithJsonString:json];
//         NSLog(@"===getALLEA === %@",jsondic);
         _onearr = [jsondic objectForKey:@"VolunteerCommunityList"];
         _twoarr = [jsondic objectForKey:@"WorkExperienceList"];
         _threearr = [jsondic objectForKey:@"ExtracurricularList"];
         
         [self createUI];
         [MBManager hideAlert];
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"getUPCOMINGMEETING失败===%@",error);
     }];
    [operation start];
}
-(void)refresh{
    _onearr = nil;
    _twoarr = nil;
    _threearr = nil;
    [self getALLEA];
}
#pragma mark - 顶部按钮
-(void)addbtn {
    
}

-(void)createUI {
    
    UIButton * addbut = [UIButton buttonWithType:UIButtonTypeCustom];
    addbut.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [addbut setTitle:@" Add Extracurricular Activity" forState:UIControlStateNormal];
    [addbut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addbut setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [addbut addTarget:self action:@selector(addbtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addbut];
    
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-100) style:UITableViewStyleGrouped];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [self.view addSubview:_tableV];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.cellnumber  isEqual: @1]) {
         return _onearr.count;
    }else if ([self.cellnumber  isEqual:@2]){
         return _twoarr.count;
    }else if ([self.cellnumber  isEqual:@3]){
        return _threearr.count;
    }
    return 0;
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
    }
    NSDictionary * dic = [[NSDictionary alloc]init];
    if ([self.cellnumber  isEqual: @1]) {
        dic = _onearr[indexPath.section];
    }else if ([self.cellnumber  isEqual:@2]){
        dic = _twoarr[indexPath.section];
    }else if ([self.cellnumber  isEqual:@3]){
        dic = _threearr[indexPath.section];
    }
    
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 50, 50)];
    imgV.layer.cornerRadius = 25;
    imgV.layer.masksToBounds = YES;
    UILabel * onelab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-80, 20)];
    UILabel * twolab = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, SCREEN_WIDTH-80, 20)];
    UILabel * threelab  = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, SCREEN_WIDTH-80, 20)];
    [threelab setTextColor:[UIColor blackColor]];
    [onelab setFont:[UIFont systemFontOfSize:17]];
    [twolab setFont:[UIFont systemFontOfSize:12]];
    [threelab setFont:[UIFont systemFontOfSize:12]];
    //属性➕值
    NSString * imgstr =[dic objectForKey:@"MCPShow_Photo"];
    if (imgstr.length<1) {
        imgV.backgroundColor = [UIColor lightGrayColor];
    }else{
        imgV.image =[Photo string2Image:[dic objectForKey:@"MCPShow_Photo"]];
    }
    
    onelab.text =[dic objectForKey:@"MCPShow_Name"];
    twolab.text =[dic objectForKey:@"MCPShow_Title1"];
    threelab.text =[dic objectForKey:@"MCPShow_Title2"];
    
    UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, SCREEN_WIDTH-20, 1)];
    downlab.backgroundColor = [UIColor colorWithRed:242/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    UILabel * textlab = [[UILabel alloc]initWithFrame:CGRectMake(150, 10, SCREEN_WIDTH-160, 30)];
    [textlab setTextColor:[UIColor grayColor]];
    [textlab setTextAlignment:NSTextAlignmentRight];
    textlab.text=@"Edit";
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15,85, SCREEN_WIDTH-30, 40)];
    NSString  * textstr =[NSString stringWithFormat:@"%@",[dic objectForKey:@"MCPShow_Description"]];
    if (textstr.length>1) {
        label.text =textstr;
    }else{
        label.text =@"No!";
    }
    
    //背景颜色为红色
    label.backgroundColor = [UIColor whiteColor];
    //设置字体颜色为白色
    label.textColor = [UIColor blackColor];
    //文字居中显示
    label.textAlignment = NSTextAlignmentLeft;
    //自动折行设置
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    
    UIButton * butone = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton * buttwo = [UIButton buttonWithType:UIButtonTypeCustom];
    butone.frame= CGRectMake(20, 130, 90, 30);
    buttwo.frame = CGRectMake(120, 130, 110, 30);
    [buttwo setTintColor:[UIColor whiteColor]];
    [butone setTintColor:[UIColor whiteColor]];
    buttwo.backgroundColor =[UIColor colorWithRed:83/255.0 green:194/255.0 blue:133/255.0 alpha:1 ];
    butone.backgroundColor = [UIColor colorWithRed:83/255.0 green:194/255.0 blue:133/255.0 alpha:1 ];
    buttwo.layer.cornerRadius  = 15;
    buttwo.layer.masksToBounds = YES;
    butone.layer.cornerRadius  = 15;
    butone.layer.masksToBounds = YES;
    buttwo.hidden = NO;
    butone.hidden = NO;
    [buttwo setTitle:@"Leadership" forState:UIControlStateNormal];
    [butone setTitle:@"Planned" forState:UIControlStateNormal];
    
    NSString * one =[NSString stringWithFormat:@"%@",[dic objectForKey:@"planned"]];
    NSString * two =[NSString stringWithFormat:@"%@",[dic objectForKey:@"leadership"]];
    
    if ([one isEqualToString:@"1"]) {
        butone.hidden = YES;
    }
    if ([two isEqualToString:@"1"]) {
        buttwo.hidden = YES;
    }
    
    
    //[cell addSubview:imgV];
    [cell addSubview:onelab];
    [cell addSubview:twolab];
    [cell addSubview:threelab];
    //[cell addSubview:textlab];
    [cell addSubview:downlab];
    [cell addSubview:label];
    [cell addSubview:buttwo];
    [cell addSubview:butone];

    return cell;
}
#pragma mark 第section组显示的头部标题
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 170;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    return  view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary * dic = [[NSDictionary alloc]init];
    if ([self.cellnumber  isEqual: @1]) {
        dic = _onearr[indexPath.section];
    }else if ([self.cellnumber  isEqual:@2]){
        dic = _twoarr[indexPath.section];
    }else if ([self.cellnumber  isEqual:@3]){
        dic = _threearr[indexPath.section];
    }
    
    ZNAddVolunteerViewController * addext = [[ZNAddVolunteerViewController alloc]init];
    addext.positionstr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"position"]];
    addext.activitystr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"eaName"]];
    addext.desciptionstr =[NSString stringWithFormat:@"%@",[dic objectForKey:@"description"]];
    addext.hrsstr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"hoursPerWeek"]];
    addext.butsectionstr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Grades"]];
    addext.planstr =[NSString stringWithFormat:@"%@",[dic objectForKey:@"planned"]];
    addext.lenstr =[NSString stringWithFormat:@"%@",[dic objectForKey:@"leadership"]];
    addext.activID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"activityID"]];
    [self.navigationController pushViewController:addext animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
