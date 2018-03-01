//
//  ZNVMListViewController.m
//  TTD
//
//  Created by quakoo on 2018/1/2.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "ZNVMListViewController.h"
#import "MessageUserListViewControllerCell.h"
#import "XMPPHelper.h"
#import "Statics.h"
#import "WCMessageObject.h"
#import "JSBadgeView.h"
#import "Photo.h"
#import "ZNLIistModel.h"

#import "ZNManyPeopleVideoViewController.h"//多少视频


@interface ZNVMListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isEditing;
    NSMutableArray * removearr;
    NSString * number;
    UILabel * numblab;
}
@property (nonatomic,strong)NSMutableArray * datasout;
@property (nonatomic,strong)UITableView * tableV;
@property (nonatomic,strong)NSMutableArray * enditarr;

@end

@implementation ZNVMListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    number = [[NSString alloc]init];
    // Do any additional setup after loading the view.
       _enditarr =[[NSMutableArray alloc]init];
    NSLog(@"视频房间传递过来的数据：\n房间号 = %@\n已参会人数 == %@",self.sessionID,self.selectedArr);
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topView.backgroundColor = [UIColor colorWithRed:0.71 green:0.15 blue:0.18 alpha:1.00];
    [self.view addSubview:topView];
    UILabel * titlelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [titlelab setText:@"New Message"];
    [titlelab setTextColor:[UIColor whiteColor]];
    [titlelab setTextAlignment:NSTextAlignmentCenter];
    [topView addSubview:titlelab];
    UIButton * leftBut = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBut.frame = CGRectMake(20, 30, 25, 25);
    [leftBut setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [leftBut addTarget:self action:@selector(leftBack) forControlEvents:UIControlEventTouchUpInside] ;
    [topView addSubview:leftBut];
    UIButton * rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(topView.frame.size.width-45, 30, 25, 25);
    [rightBut setTitle:@"OK" forState:UIControlStateNormal];
    rightBut.titleLabel.font = [UIFont systemFontOfSize: 18];
    [rightBut addTarget:self action:@selector(rightButOK) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBut];
    numblab = [[UILabel alloc]initWithFrame:CGRectMake(rightBut.frame.origin.x -24, 32, 18, 18)];
    numblab.backgroundColor = [UIColor whiteColor];
    [numblab setTextColor:[UIColor colorWithRed:0.71 green:0.15 blue:0.18 alpha:1.00]];
    numblab.layer.cornerRadius = 9;
     numblab.layer.masksToBounds = YES;
    [numblab setTextAlignment:NSTextAlignmentCenter];
    [topView addSubview:numblab];
    [numblab setText:[NSString stringWithFormat:@"%lu",self.selectedArr.count ]];
    
    
    [self createTab];
    
   
    
}
-(void)createTab {
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.editing = YES;
    _tableV.allowsMultipleSelectionDuringEditing = YES;
    isEditing = YES;
    [self.view addSubview:_tableV];
}
#pragma mark - tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasout.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"identifiersss";
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    ZNLIistModel * model =_datasout[indexPath.row];
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
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel * userid = [[UILabel alloc]initWithFrame:cell.frame];
    userid.hidden = YES;
    userid.text = model.userid;
    [cell addSubview:userid];
    
    //设置选中第一行
    
   
    for (int i=0; i<self.selectedArr.count; i++) {
        NSString * selename = [NSString stringWithFormat:@"%@",self.selectedArr[i]];
//        NSString * myname =[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
//        NSLog(@"我的ID==%@",myname);
//        if (selename.length<18) {
//            [self.selectedArr removeObject:selename];
//        }
        
        if ([userid.text containsString:selename]) {
            NSLog(@"应该选中==%ld",(long)indexPath.row);
            //设置选中第一行
            [self.tableV selectRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0]animated:YES scrollPosition:UITableViewScrollPositionTop];
            
            if ([self.tableV.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
                
            {
                
                [self.tableV.delegate tableView:self.tableV didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0]];
                
            }
    }
    
    }
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
    
      ZNLIistModel * mode =self.datasout[indexPath.row];
    if (isEditing)
    {
      
        [_enditarr addObject:mode.userid];
    }
    //数组驱重
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_enditarr count]; i++){
        
        if ([categoryArray containsObject:[_enditarr objectAtIndex:i]] == NO){
            
            [categoryArray addObject:[_enditarr objectAtIndex:i]];
            
        }
    }
    
//    NSString * name=[self.selectedArr lastObject];
//    NSString * newname =[NSString stringWithFormat:@"%@@%@",name,OpenFireHostName];
    for (int i=0; i<self.selectedArr.count; i++) {
       
        NSString * selename = [NSString stringWithFormat:@"%@",self.selectedArr[i]];
        
//        if ([mode.userid  containsString:selename]) {
//             [numblab setText:[NSString stringWithFormat:@"%ld", self.selectedArr.count ]];
//
//        }else{
//
//            if ([categoryArray containsObject:self.selectedArr[i]]) {
//                [categoryArray removeObject:self.selectedArr[i]];
////                if ([categoryArray containsObject:newname]) {
////                    [categoryArray removeObject:newname];
////                }
//          if (selename.length<18) {
//              [self.selectedArr removeObject:selename];
//            }
        for (int i=0; i<categoryArray.count; i++) {
            NSString * catename = [NSString stringWithFormat:@"%@",categoryArray[i]];
            if ([catename isEqualToString:selename]) {
                [categoryArray removeObject:catename];
            }
        }
        
                  [numblab setText:[NSString stringWithFormat:@"%ld",categoryArray.count+self.selectedArr.count]];
        
        }
 
    NSLog(@"选中的数据==%@",categoryArray);
    
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取反选中的单元格的内容
    ZNLIistModel * mode =self.datasout[indexPath.row];
    //判断删除数组中是否具有该元素 如果具有就移除
    if ([_enditarr containsObject:mode.userid])
    {
        [_enditarr removeObject:mode.userid];
    }
    //数组驱重
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_enditarr count]; i++){
        
        if ([categoryArray containsObject:[_enditarr objectAtIndex:i]] == NO){
            
            [categoryArray addObject:[_enditarr objectAtIndex:i]];
            
        }
    }
    
    
    
//    NSString * name=[self.selectedArr lastObject];
//    NSString * newname =[NSString stringWithFormat:@"%@@%@",name,OpenFireHostName];
    for (int i=0; i<self.selectedArr.count; i++) {
        
        NSString * selename = [NSString stringWithFormat:@"%@",self.selectedArr[i]];
//        if ([mode.userid  containsString:selename]) {
//            [numblab setText:[NSString stringWithFormat:@"%ld", self.selectedArr.count ]];
//
//        }else{
////            if ([categoryArray containsObject:newname]) {
////                [categoryArray removeObject:newname];
////            }
//            if ([categoryArray containsObject:self.selectedArr[i]]) {
//                [categoryArray removeObject:self.selectedArr[i]];
//        if (selename.length<18) {
//            [self.selectedArr removeObject:selename];
//
//            }
        for (int i=0; i<categoryArray.count; i++) {
            NSString * catename = [NSString stringWithFormat:@"%@",categoryArray[i]];
            if ([catename isEqualToString:selename]) {
                [categoryArray removeObject:catename];
            }
        }
                  [numblab setText:[NSString stringWithFormat:@"%ld",categoryArray.count+self.selectedArr.count]];
        
          
        }
        
    
    
        NSLog(@"最后选中的数据==%@",_enditarr);
}


#pragma  mark - dataSout
-(NSMutableArray *)datasout{
    if (!_datasout) {
        _datasout=[[NSMutableArray alloc]init];
        NSMutableArray * arry = [WCMessageObject fetchAllUserMessageInfo:SharedAppDelegate.username];;
        
        for (WCMessageObject * wcmes in arry) {
            ZNLIistModel * mode=[[ZNLIistModel alloc]init];
            [mode initWithid:wcmes];
            [_datasout addObject:mode];
            
        }
    }
    return _datasout;
}



#pragma mark - 左右按钮
-(void)leftBack {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)rightButOK {
    
   
    NSString * name=[self.selectedArr lastObject];
    NSString * newname =[NSString stringWithFormat:@"%@@%@",name,OpenFireHostName];

    NSArray *array = [NSArray array];
    array = self.selectedArr;
    
    NSMutableArray * dicarr = _enditarr;
    for (int i=0; i<self.selectedArr.count; i++) {
        [dicarr addObject:[NSString stringWithFormat:@"%@",self.selectedArr[i]]];
    }
    if ([dicarr containsObject:newname]) {
        [dicarr removeObject:newname];
    }
    
    
    NSDictionary * dic = @{@"number":dicarr};//最终所需人数
    NSString * endpersonStr=[_enditarr componentsJoinedByString:@"||"];
    NSLog(@"需要新增的邀请人数=%@",endpersonStr);
    [self sendChangeVideoUI];
      [[NSNotificationCenter defaultCenter]postNotificationName:@"increasePerson" object:nil userInfo: dic];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)sendChangeVideoUI {
    
   
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self.selectedArr];
    NSArray * filter = [_enditarr filteredArrayUsingPredicate:filterPredicate];
    NSLog(@"%@",filter);
    
//    NSLog(@"新加人员后的动态数据===%@",_enditarr);
    
    NSString * sessionid =[[NSString alloc]init];
    if (self.sessionID.length<1) {
        sessionid = SharedAppDelegate.myVideoRoom;
    }else{
        sessionid =[NSString stringWithFormat:@"%@",self.sessionID];
    }
    
    NSString * endpersonStr=[_enditarr componentsJoinedByString:@"||"];
    NSString * bodystr =[NSString stringWithFormat:@"newchatVideoUI//%@//%@",sessionid,endpersonStr];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString * bodyStr=[NSString stringWithFormat:@"%@*%@",dateString,bodystr];
    NSMutableString *soundString = [[NSMutableString alloc]initWithString:@"[/9]"];
    [soundString appendString:bodyStr];
    for (int i=0; i<_enditarr.count; i++) {
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
        NSLog(@"动态新增视频请求==%@  接收者==%@",soundString,_enditarr[i]);
    }
    
    
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
