//
//  ZNextractivitiesController.m
//  TTD
//
//  Created by quakoo on 2017/12/6.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "ZNextractivitiesController.h"
#import "ZNAddExtracurriController.h"
#import "ExtrSectionViewController.h"
@interface ZNextractivitiesController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableV;
@property (nonatomic,strong)NSMutableArray * onearr;
@property (nonatomic,strong)NSMutableArray * twoarr;
@property (nonatomic,strong)NSMutableArray * threearr;
@end

@implementation ZNextractivitiesController

- (void)viewDidLoad {
    [super viewDidLoad];
    _onearr = [[NSMutableArray alloc]init];
    _twoarr = [[NSMutableArray alloc]init];
    _threearr = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIButton  * but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame=CGRectMake(0, 0,self.view.frame.size.width, 50);
    [but setTitle:@"Add Extracurricular Activity" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [but addTarget: self action:@selector(hidbutton:) forControlEvents:UIControlEventTouchUpInside];
    but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    but.titleEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
    but.imageEdgeInsets = UIEdgeInsetsMake(10, 50, 10,10);
    [self.view addSubview:but];
   [MBManager showLoading];
    [self getALLEA];
}
-(void)hidbutton:(UIButton *)sender {
    ZNAddExtracurriController * addext = [[ZNAddExtracurriController alloc]init];
    
    [self.navigationController pushViewController:addext animated:YES];
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
         NSLog(@"===getALLEA === %@",jsondic);
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
-(void)createUI {
    _tableV =[[UITableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-210) style:UITableViewStylePlain];
    _tableV.dataSource = self;
    _tableV.delegate = self;
    _tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [self.view addSubview: _tableV];
}
#pragma mark -tableviewDelegate
//分组个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
//分组cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section ==0) {
        if (_onearr.count>=2) {
            return 3;
        }else{
            return _onearr.count+1;
        }

    }else if (section ==1) {
        if (_twoarr.count>=2) {
            return 3;
        }else{
        return _twoarr.count+1;
        }
    }else if (section ==2) {
        if (_threearr.count>=2) {
            return 3;
        }else{
        return _threearr.count+1;
        }
    }
    
}
//cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        if (indexPath.row ==0) {
            return 50;
        }else{
            return 70;
        }
    }else if (indexPath.section ==1){
        if (indexPath.row ==0) {
            return 50;
        }else{
            return 70;
        }
    }else if (indexPath.section ==2){
        if (indexPath.row ==0) {
            return 50;
        }else{
            return 70;
        }
    }
     return 0;
}

//cell样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:name];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:name];;
    }
    UILabel * onelab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-10, 20)];
    UILabel * twolab = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, SCREEN_WIDTH-10, 20)];
    UILabel * threelab  = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, SCREEN_WIDTH-10, 20)];
    [threelab setTextColor:[UIColor lightGrayColor]];
    [onelab setFont:[UIFont systemFontOfSize:17]];
    [twolab setFont:[UIFont systemFontOfSize:12]];
    [threelab setFont:[UIFont systemFontOfSize:12]];
    
    
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            UILabel * lab =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 270, 20)];
//            lab.backgroundColor = [UIColor redColor];
            [lab setTextColor:[UIColor lightGrayColor]];
            //arrow_black
            lab.text = @" Volunteer  & Community Service";
            UIImageView * imgv=[[UIImageView alloc]initWithFrame:CGRectMake(lab.frame.size.width, 10, 20, 20)];
            imgv.image = [UIImage imageNamed:@"rightjt.png"];
            [cell addSubview:imgv];
            
            [cell addSubview:lab];
        }else{
            if (_onearr.count>=2) {
                if (indexPath.row ==1) {
                    NSDictionary * dic = _onearr[0];
                    onelab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"MCPShow_Name"]];
                    twolab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title1"]];
                    threelab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title2"]];
                }else if (indexPath.row ==2 ){
                    NSDictionary * dic = _onearr[1];
                    onelab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"MCPShow_Name"]];
                    twolab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title1"]];
                    threelab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title2"]];
                }else{
                    
                }
            }else{
                NSDictionary * dic = _onearr[indexPath.row-1];
                onelab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"MCPShow_Name"]];
                twolab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title1"]];
                threelab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title2"]];
            }
            
           
        }
       
        
    }else if (indexPath.section == 1) {
        if (indexPath.row ==0) {
            UILabel * lab =[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 175, 20)];
            [lab setTextColor:[UIColor lightGrayColor]];
//            lab.backgroundColor = [UIColor redColor];
            lab.text = @" Working Experience";
            UIImageView * imgv=[[UIImageView alloc]initWithFrame:CGRectMake(lab.frame.size.width, 15, 20, 20)];
            imgv.image = [UIImage imageNamed:@"rightjt.png"];
            [cell addSubview:imgv];
            [cell addSubview:lab];
        }else{
            if (_twoarr.count>=2) {
                if (indexPath.row ==1) {
                    NSDictionary * dic = _twoarr[0];
                    onelab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"MCPShow_Name"]];
                    twolab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title1"]];
                    threelab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title2"]];
                }else if (indexPath.row==2){
                    NSDictionary * dic = _twoarr[1];
                    onelab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"MCPShow_Name"]];
                    twolab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title1"]];
                    threelab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title2"]];
                }else{
                    
                }
            }else{
                NSDictionary * dic = _twoarr[indexPath.row-1];
                onelab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"MCPShow_Name"]];
                twolab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title1"]];
                threelab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title2"]];
            }

        }
        
        
    }else if (indexPath.section ==2) {
        if (indexPath.row ==0) {
            UILabel * lab =[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 210, 20)];
            [lab setTextColor:[UIColor lightGrayColor]];
//            lab.backgroundColor = [UIColor redColor];
            lab.text = @" Extracurricular activities";
            UIImageView * imgv=[[UIImageView alloc]initWithFrame:CGRectMake(lab.frame.size.width, 15, 20, 20)];
            imgv.image = [UIImage imageNamed:@"rightjt.png"];
            [cell addSubview:imgv];
            [cell addSubview:lab];
        }else{
            
            if (_threearr.count>=2) {
                if (indexPath.row ==1) {
                    NSDictionary * dic = _threearr[0];
                    onelab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"MCPShow_Name"]];
                    twolab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title1"]];
                    threelab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title2"]];
                }else if (indexPath.row==2){
                    NSDictionary * dic = _threearr[1];
                    onelab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"MCPShow_Name"]];
                    twolab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title1"]];
                    threelab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title2"]];
                }else{
                    
                }
            }else{
            NSDictionary * dic = _threearr[indexPath.row-1];
            onelab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"MCPShow_Name"]];
            twolab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title1"]];
            threelab.text = [NSString stringWithFormat:@" %@",[dic objectForKey:@"MCPShow_Title2"]];
            }
        }
        
    }
    
    [cell addSubview:onelab];
    [cell addSubview:twolab];
    [cell addSubview:threelab];
    
    return cell;
}

//cell 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ExtrSectionViewController * extrV = [[ExtrSectionViewController alloc]init];
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
//            NSDictionary * dic =_onearr[indexPath.row-1];
            extrV.cellnumber =@1;
            extrV.title =@"Volunteer  & Community Service";
            [self.navigationController pushViewController:extrV animated:YES];
        }else{
            
        }
    }else if (indexPath.section ==1){
        if (indexPath.row ==0) {
//            NSDictionary * dic =_twoarr[indexPath.row-1];
            extrV.cellnumber =@2;
            extrV.title =@"Working Experience";
            [self.navigationController pushViewController:extrV animated:YES];
        }else{
            
        }
    }else if (indexPath.section ==2){
        if (indexPath.row ==0) {
//            NSDictionary * dic = _threearr[indexPath.row-1];
            extrV.cellnumber =@3;
            extrV.title =@"Extracurricular activities";
            [self.navigationController pushViewController:extrV animated:YES];
        }else{
            
        }
    }
    
}

//分组头
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 50)];
//    customView.backgroundColor = [UIColor  clearColor];
//    UILabel * headerlab = [[UILabel alloc]initWithFrame:CGRectZero];
//    headerlab.backgroundColor = [UIColor clearColor];
//    headerlab.textColor = [UIColor greenColor];
//    headerlab.font = [UIFont boldSystemFontOfSize:18];
//    headerlab.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, 40);
//
//    if (section ==0) {
//          headerlab.text =@" Volunteer  & Community Service";
//    }else if (section ==1) {
//           headerlab.text =@" Working Experience";
//    }else if (section ==2) {
//           headerlab.text =@" Extracurricular activities";
//    }
//
//    [customView addSubview:headerlab];
//    return customView;
//
//}
//分组头间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
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
