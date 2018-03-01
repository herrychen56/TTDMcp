//
//  ZNListViewController.m
//  TTD
//
//  Created by quakoo on 2017/12/26.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "ZNListViewController.h"
#import "MessageUserListViewControllerCell.h"
#import "XMPPHelper.h"
#import "Statics.h"
#import "WCMessageObject.h"
#import "JSBadgeView.h"
#import "Photo.h"
#import "ZNLIistModel.h"
//#import "ZNXMPPRoom.h"//群聊
#import "ZNManyPeopleVideoViewController.h"//多少视频
#import "ZNGroupChatViewController.h"//群聊

@interface ZNListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isEditing;
     NSMutableArray * removearr;
    UILabel * numblab;
    XMPPRoom *room;
}
@property (nonatomic,strong)NSMutableArray * datasout;
@property (nonatomic,strong)UITableView * tableV;
@property (nonatomic,strong)NSMutableArray * enditarr;

@property (nonatomic,strong)NSMutableArray * arr1;
@property (nonatomic,strong)NSMutableArray * arr2;
@property (nonatomic,strong)NSMutableArray * arr3;
@property (nonatomic,strong)NSMutableArray * arr4;


@end

@implementation ZNListViewController

- (void)viewDidLoad {
    self.tabBarController.tabBar.hidden = YES;
    _enditarr =[[NSMutableArray alloc]init];
    [super viewDidLoad];
    
    
    
    _arr1 = [[NSMutableArray alloc]init];
    _arr2 = [[NSMutableArray alloc]init];
    _arr3 = [[NSMutableArray alloc]init];
    _arr4 = [[NSMutableArray alloc]init];
    NSMutableArray * arry = [WCMessageObject fetchAllUserMessageInfo:SharedAppDelegate.username];;
    
    for (WCMessageObject * wcmes in arry) {
        ZNLIistModel * mode=[[ZNLIistModel alloc]init];
        [mode initWithid:wcmes];
        
        if ([mode.group  isEqualToString:@"Manager"]) {
            [_arr1 addObject:mode];
        }else if ([mode.group isEqualToString:@"Consultant"]){
            [_arr2 addObject:mode];
        }else if ([mode.group isEqualToString:@"Student"]){
            [_arr3 addObject:mode];
        }else if ([mode.group isEqualToString:@"Parent"]){
            [_arr4 addObject:mode];
        }
    }
    
    
    NSLog(@"多选页面收到数据==%@  名字==%@",self.numbStr,self.personArr);
    
    // Do any additional setup after loading the view.
//    [self datasout];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(Multiplerequests)];
//    numblab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width -24, 32, 18, 18)];
//    numblab.backgroundColor = [UIColor whiteColor];
//    [numblab setTextColor:[UIColor colorWithRed:0.71 green:0.15 blue:0.18 alpha:1.00]];
//    numblab.layer.cornerRadius = 9;
//    numblab.layer.masksToBounds = YES;
//    [numblab setTextAlignment:NSTextAlignmentCenter];
//    [self.view addSubview:numblab];
//    [numblab setText:[NSString stringWithFormat:@"%",@"1"]];
    
    [self createTab];
}

-(void)gobbback{
    [MBManager hideAlert];
    [[XMPPServer sharedServer]getExistRoom];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 导航按钮
-(void)Multiplerequests {
    NSLog(@"发送人员==%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]);
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString * sessionID = [NSString stringWithFormat:@"%@%f",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"],interval];
    
    
    NSString * sendname = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    if (![_enditarr containsObject:sendname]) {
        [_enditarr addObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]]];
    }
    //发起多人视频请求
//    NSLog(@"需要邀请的人员=%@",_enditarr);
    if (_enditarr.count>8) {
        
        [LEEAlert alert].config
        .LeeTitle(@"warning")
        .LeeContent(@"The maximum number of meetings is 9 ！")
        .LeeAction(@"confirm", ^{
            
        })
        .LeeShow();
    }else{
     
        if ([self.Roomtype  isEqual:@1]) {
            
            
            __block UITextField *tf = nil;
            
            [LEEAlert alert].config
            .LeeTitle(@"New Group Chat")
            .LeeAddTextField(^(UITextField *textField) {
                
                // 这里可以进行自定义的设置
                
                textField.placeholder = @"Enter A Room Nickname";
                
                textField.textColor = [UIColor darkGrayColor];
                
                tf = textField; //赋值
            })
            .LeeAction(@"Confirm", ^{
                
                NSString * str = tf.text;
                NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
                NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
                NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
                NSString * groupName = [NSString stringWithFormat:@"%@%@",str,timeString];
                NSLog(@"新建群聊名称==%@",groupName);
                //创建群组聊天
                [[XMPPServer sharedServer]CreateRoomWithRoomName:[NSString stringWithFormat:@"%@",groupName] WithPerson:_enditarr];
                
                [tf resignFirstResponder];
                [MBManager showLoading];
                 [self performSelector:@selector(gobbback) withObject:nil afterDelay:4.0];
                
            })
            .LeeCancelAction(@"Cancel", nil) // 点击事件的Block如果不需要可以传nil
            .LeeShow();
            
            
            
           
            
        }else{
            //创建多人视频
            NSString *string = [_enditarr componentsJoinedByString:@"||"];
            for (int i=0; i<_enditarr.count; i++) {
//                NSString * bodystr =[NSString stringWithFormat:@"%@//%@",@"multiplesendVideo",string];
               NSString * bodystr=  [NSString stringWithFormat:@"chatVideoUI//%@//%@",sessionID,string];
                SharedAppDelegate.myVideoRoom = sessionID;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString * bodyStr=[NSString stringWithFormat:@"%@*%@",dateString,bodystr];
                NSMutableString *soundString = [[NSMutableString alloc]initWithString:@"[/9]"];
                [soundString appendString:bodyStr];
                //    NSLog(@"发送的音频数据===%@",soundString);
                //发送消息
                //XMPPFramework主要是通过KissXML来生成XML文件
                //生成<body>文档
                NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
                [body setStringValue:soundString];
                //生成XML消息文档
                NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
                //消息类型
                [mes addAttributeWithName:@"type" stringValue:@"chat"];
                //发送给谁
                [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@",_enditarr[i]]];
                //由谁发送
                [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
                //组合
                [mes addChild:body];
                NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
                [mes addChild:received];
                [[XMPPServer xmppStream] sendElement:mes];
                NSLog(@"发起视频请求==%@  接收者==%@",soundString,_enditarr[i]);
            }
            ZNManyPeopleVideoViewController * znm=[[ZNManyPeopleVideoViewController alloc]init];
            znm.mtarr = _enditarr;
            [self presentViewController:znm animated:YES completion:nil];
        }
    }
}



-(void)createTab {
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.editing = YES;
    _tableV.allowsMultipleSelectionDuringEditing = YES;
    isEditing = YES;
    [self.view addSubview:_tableV];
}
#pragma mark - tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return _arr1.count;
    }else if (section ==1){
        return _arr2.count;
    }else if (section ==2){
        return _arr3.count;
    }else if (section ==3){
        return _arr4.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"identifiersss";
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    ZNLIistModel * model=[[ZNLIistModel alloc]init];
    if (indexPath.section == 0) {
         model =_arr1[indexPath.row];
    }else if (indexPath.section ==1){
        model =_arr2[indexPath.row];
    }else if (indexPath.section ==2){
        model =_arr3[indexPath.row];
    }else if (indexPath.section ==3){
        model =_arr4[indexPath.row];
    }
    
    
    
    NSString * imgstr = model.imageName;
    UIImage * imge=[[UIImage alloc]init];
    if ([imgstr isKindOfClass:[NSNull class]]) {
        imge =[UIImage imageNamed:@"defaultUSerImage"];
    }else{
        imge=[ Photo string2Image:imgstr];
    }
    
    CGSize itemSize = CGSizeMake(50, 50);//固定图片大小为36*36
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);//*1
    CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    [imge drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();//*2
    UIGraphicsEndImageContext();//*3

    cell.imageView.layer.cornerRadius = 25;
    cell.imageView.layer.masksToBounds = YES;
    cell.textLabel.text = model.nameStr;
//    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:YES];
    isEditing=!isEditing;
    //如果表格处于不可编辑的状态 需要将编辑状态下选中的单元格内容从数组中删除
    if (isEditing==NO)
    {
        [_enditarr removeAllObjects];
    }
    
    [_tableV setEditing:isEditing animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
    if (isEditing)
    {
        ZNLIistModel * model=[[ZNLIistModel alloc]init];
        if (indexPath.section == 0) {
            model =_arr1[indexPath.row];
        }else if (indexPath.section ==1){
            model =_arr2[indexPath.row];
        }else if (indexPath.section ==2){
            model =_arr3[indexPath.row];
        }else if (indexPath.section ==3){
            model =_arr4[indexPath.row];
        }
        [_enditarr addObject:model.userid];
    }
    NSLog(@"选中的数据==%@",_enditarr);
    
  [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];

}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ZNLIistModel * model=[[ZNLIistModel alloc]init];
    if (indexPath.section == 0) {
        model =_arr1[indexPath.row];
    }else if (indexPath.section ==1){
        model =_arr2[indexPath.row];
    }else if (indexPath.section ==2){
        model =_arr3[indexPath.row];
    }else if (indexPath.section ==3){
        model =_arr4[indexPath.row];
    }
    //判断删除数组中是否具有该元素 如果具有就移除
    if ([_enditarr containsObject:model.userid])
    {
        [_enditarr removeObject:model.userid];
    }
    NSLog(@"最后选中的数据==%@",_enditarr);
}


#pragma  mark - dataSout
-(NSMutableArray *)datasout{
    if (!_datasout) {
        _datasout=[[NSMutableArray alloc]init];
        _arr1 = [[NSMutableArray alloc]init];
        _arr2 = [[NSMutableArray alloc]init];
        _arr3 = [[NSMutableArray alloc]init];
        _arr4 = [[NSMutableArray alloc]init];
        NSMutableArray * arry = [WCMessageObject fetchAllUserMessageInfo:SharedAppDelegate.username];;
        
        for (WCMessageObject * wcmes in arry) {
            ZNLIistModel * mode=[[ZNLIistModel alloc]init];
            [mode initWithid:wcmes];
            
            if ([mode.group  isEqualToString:@"Manager"]) {
                [_arr1 addObject:mode];
            }else if ([mode.group isEqualToString:@"Consultant"]){
                [_arr2 addObject:mode];
            }else if ([mode.group isEqualToString:@"Student"]){
                [_arr3 addObject:mode];
            }else if ([mode.group isEqualToString:@"Parent"]){
                [_arr4 addObject:mode];
            }
            
            [_datasout addObject:mode];
           
        }
    }
    return _datasout;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];//
    
    //add your code behind
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 2.5, SCREEN_HEIGHT-25, 30)];
    [view addSubview:label];
    [label setTextColor:[UIColor lightGrayColor]];
    if (section ==0) {
         label.text =@"Manager";
    }else if (section ==1){
        label.text =@"Consultant";
    }else if (section ==2){
        label.text =@"Student";
    }else if (section ==3){
         label.text =@"Parent";
    }
   
    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

 
 -(void)CreateRoom{
 
 XMPPRoomCoreDataStorage *rosterstorage = [[XMPPRoomCoreDataStorage alloc] init];
 //  room = [[XMPPRoom alloc] initWithRoomStorage:rosterstorage jid:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@test-u-1.thinktank.com",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]]] dispatchQueue:dispatch_get_main_queue()];
 room=[[XMPPRoom alloc] initWithRoomStorage:rosterstorage jid:[XMPPJID jidWithString:@"zn-testRoom"] dispatchQueue:dispatch_get_main_queue()];
 //    [rosterstorage release];
 XMPPStream *stream = [XMPPServer xmppStream];
 [room activate:stream];
 [room joinRoomUsingNickname:@"smith" history:nil];
 [room configureRoomUsingOptions:nil];
 [room addDelegate:self delegateQueue:dispatch_get_main_queue()];
 NSLog(@"创建了一个群聊房间");
 //    [self cofigNewRoom];
 }
 -(void)cofigNewRoom {
 NSXMLElement * x =[NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
 NSXMLElement * p;
 p = [NSXMLElement elementWithName:@"field"];
 [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_persistentroom"];//永久房间
 [p addChild:[NSXMLElement elementWithName:@"value" xmlns:@"1"]];
 [x addChild:p];
 
 p = [NSXMLElement elementWithName:@"field" ];
 [p addAttributeWithName:@"var"stringValue:@"muc#roomconfig_maxusers"];//最大用户
 [p addChild:[NSXMLElement elementWithName:@"value"stringValue:@"10000"]];
 [x addChild:p];
 
 p = [NSXMLElement elementWithName:@"field" ];
 [p addAttributeWithName:@"var"stringValue:@"muc#roomconfig_changesubject"];//允许改变主题
 [p addChild:[NSXMLElement elementWithName:@"value"stringValue:@"1"]];
 [x addChild:p];
 
 p = [NSXMLElement elementWithName:@"field" ];
 [p addAttributeWithName:@"var"stringValue:@"muc#roomconfig_publicroom"];//公共房间
 [p addChild:[NSXMLElement elementWithName:@"value"stringValue:@"1"]];
 [x addChild:p];
 
 p = [NSXMLElement elementWithName:@"field" ];
 [p addAttributeWithName:@"var"stringValue:@"muc#roomconfig_allowinvites"];//允许邀请
 [p addChild:[NSXMLElement elementWithName:@"value"stringValue:@"1"]];
 [x addChild:p];
 [room configureRoomUsingOptions:x];
 }
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
