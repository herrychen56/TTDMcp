//
//  TodotaskViewController.m
//  TTD
//
//  Created by quakoo on 2018/1/29.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "TodotaskViewController.h"

@interface TodotaskViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *taskarr;
@property (nonatomic,strong)NSMutableArray * newdataarr;
@end

@implementation TodotaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _taskarr=[[NSMutableArray alloc]init];
    _newdataarr = [[NSMutableArray alloc]init];
    [MBManager showLoading];
    [self getStudentTasks];
}
#pragma mark - GET StudentTasks
-(void)getStudentTasks {
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_CGET_StudentTasks parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         ZNgetStudentTasks * znconstult = [ZNgetStudentTasks responseWithDDXMLDocument:XMLDocument];
         NSString * json = znconstult.getStudentTasks;
//                         NSLog(@"StudentTasks成功===%@",json);
         NSDictionary * dic = [SharedAppDelegate dictionaryWithJsonString:json];
         //         _photoarr = [dic objectForKey:@"taskPhotoModel"];
         _taskarr = [dic objectForKey:@"tasksModel"];
//                  NSLog(@"===StudentTasks === %@",dic);
         
         //         [self createtableV];
          [self CreateTabV];
         [MBManager hideAlert];
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"StudentTasks失败===%@",error);
     }];
    [operation start];
}
-(void)CreateTabV {
    NSDictionary * dic = _taskarr[self.intg];
    _newdataarr = [dic objectForKey:@"StudentTaskList"];
    _tabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-125) style:UITableViewStylePlain];
    _tabV.dataSource = self;
    _tabV.delegate = self;
    [self.view addSubview:_tabV];
}
#pragma mark -TableDeleGate
//分组cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _newdataarr.count;
}
//cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
//cell样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NSString *name = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:name];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:name];;
    }
    NSDictionary * dic = _newdataarr[indexPath.row];
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 30, 30)];
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 30, 30)];
    NSString * labStr  =  [dic objectForKey:@"TaskID"];
    NSString * iscomp = [dic objectForKey:@"IsComplete"];
    if ([iscomp isEqualToString:@"N"]) {
        imageV.image = [UIImage imageNamed:@"ToDoquan"];
    }else{
        imageV.image = [UIImage imageNamed:@"redyes"];
    }
    lab.text  = [NSString stringWithFormat:@"%@",labStr];
    [cell addSubview:imageV];
    [cell addSubview:lab];
    return cell;
}
//cell 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     NSDictionary * dic = _newdataarr[indexPath.row];
    NSString * TaskID  =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"TaskID"]];
     NSString * iscomp = [dic objectForKey:@"IsComplete"];
    NSString * status = [[NSString alloc]init];
    if ([iscomp isEqualToString:@"N"]) {
        status =@"Y";
    }else{
        status =@"N";
    }
    [MBManager showLoading];
    [self setToDotask:TaskID status:status];
}
-(void)setToDotask:(NSString *)taskId status:(NSString *)status{
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            SharedAppDelegate.username, @"studentId",
                            taskId,@"taskID",
                            status,@"status",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_setToDoTasks parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         ZNsetToDoTasks * znconstult = [ZNsetToDoTasks responseWithDDXMLDocument:XMLDocument];
         NSString * json = znconstult.setToDoTasks;
         [LEEAlert alert].config
         .LeeTitle(@"Message")
         .LeeContent(json)
         .LeeAction(@"confirm", ^{
             
         })
         .LeeShow();
        
         [MBManager hideAlert];
         [self getStudentTasks];
         
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"FUNC_GET_setToDoTasks失败===%@",error);
     }];
    [operation start];
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
