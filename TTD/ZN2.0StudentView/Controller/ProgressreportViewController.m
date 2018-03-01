//
//  ProgressreportViewController.m
//  TTD
//
//  Created by quakoo on 2017/12/5.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "ProgressreportViewController.h"
#import "Photo.h"
#import "ReportViewController.h"
@interface ProgressreportViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * rosterJids;
@property (nonatomic,strong)UITableView * tabV;

@property (nonatomic,strong)NSMutableArray * photoarr;
@property (nonatomic,strong)NSMutableArray * taskarr;
@end

@implementation ProgressreportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = nil;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"Progress Report";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;

    // Do any additional setup after loading the view.
    
    self.rosterJids = [NSMutableArray array];
 
    _photoarr = [[NSMutableArray alloc]init];
    _taskarr = [[NSMutableArray alloc]init];
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
//                NSLog(@"StudentTasks成功===%@",json);
        NSDictionary * dic = [SharedAppDelegate dictionaryWithJsonString:json];
         _photoarr = [dic objectForKey:@"taskPhotoModel"];
         _taskarr = [dic objectForKey:@"tasksModel"];
//         NSLog(@"===StudentTasks === %@",dic);
         
         [self createtableV];
           [MBManager hideAlert];
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"StudentTasks失败===%@",error);
     }];
    [operation start];
}

-(void)createtableV {
    self.tabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50) style:UITableViewStyleGrouped];
    //    self.tabV.backgroundView=[UIColor grayColor];
    self.tabV.delegate = self;
    self.tabV.dataSource = self;
    self.tabV.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tabV.tableFooterView = [UIView new];
      self.tabV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    if (self.taskarr.count ==0) {
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, SCREEN_HEIGHT/2-50, SCREEN_WIDTH, 50)];
        [lab setTextColor:[UIColor lightGrayColor]];
        lab.text = @"No Progress Report";
        [self.view addSubview:lab];
    }else{
        [self.view addSubview:self.tabV];
    }
    

    
    
    
    
}
-(void)refresh{
    _taskarr = nil;
    [self getStudentTasks];
}

#pragma mark - TableDelegate
//分组个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _taskarr.count;
}
//分组cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
//cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
//cell样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:name];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:name];;
    }
     NSDictionary * taskdic = _taskarr[indexPath.section];
    
   
    if (indexPath.row ==0) {
        UIImageView * icon =[[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 30, 30)];
        icon.layer.cornerRadius = 15;
        icon.layer.masksToBounds = YES;
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, SCREEN_WIDTH, 30)];
        
        lab.text = [taskdic objectForKey:@"Name"];
        NSString * imageID =[taskdic objectForKey:@"PhotoId"];
        NSString * imageStr = [[NSString alloc]init];
         NSDictionary *dict =[[NSDictionary alloc]init];
        for (int i=0; i<_photoarr.count; i++) {
            dict =_photoarr[i];
            if([[dict allValues] containsObject:imageID]){
                NSLog(@"==头像 == %@ ",[dict objectForKey:@"Photo"]);
                imageStr= [dict objectForKey:@"Photo"];
                icon.image =[Photo string2Image:imageStr];
                NSLog(@"头像 == %@ ",imageStr);
            }else{
                icon.image = [UIImage imageNamed:@"defaultUSerImage"];
                NSLog(@"没有头像");
            }
        }
        
        [cell addSubview:icon];
        [cell addSubview:lab];
    }else{
        
        UILabel * uplab = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, SCREEN_WIDTH, 20)];
        UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(25, 25, SCREEN_WIDTH, 20)];
        [downlab setFont:[UIFont systemFontOfSize:13]];
        [downlab setTextColor:[UIColor lightGrayColor]];
        UILabel * rightlab = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH-125, 30)];
        [rightlab setTextAlignment:NSTextAlignmentRight];
        [rightlab setFont:[UIFont systemFontOfSize:14]];
        [rightlab setTextColor:[UIColor colorWithRed:0.92 green:0.27 blue:0.30 alpha:1.00]];
        
       
       
        if (indexPath.row ==1) {
            uplab.text = [taskdic objectForKey:@"Tasks"];
            downlab.text = [taskdic objectForKey:@"TasksBy"];
            NSString * completedCount = [taskdic objectForKey:@"completedCount"];
            NSString * Count = [taskdic objectForKey:@"Count"];
            if(completedCount ==Count){
                 [rightlab setTextColor:[UIColor colorWithRed:0.28 green:0.46 blue:0.67 alpha:1.00]];
            }
            rightlab.text =[taskdic objectForKey:@"Completed"];
        }else if (indexPath.row ==2){
            uplab.text = [taskdic objectForKey:@"ProgressReport"];
            downlab.text = [taskdic objectForKey:@"ProgressReportBy"];
            rightlab.text =@"";
        }

        [cell addSubview:uplab];
        [cell addSubview:downlab];
        [cell addSubview:rightlab];
        
    }
    
    
    
    return cell;
}

//cell 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      NSDictionary * taskdic = _taskarr[indexPath.section];
        NSString * name = [taskdic objectForKey:@"Name"];
    NSString * rigstr = [taskdic objectForKey:@"ProgressReportBy"];
    NSString * imgstr = [[NSString alloc]init];
    NSDictionary *dict =[[NSDictionary alloc]init];
    NSString * imageID =[taskdic objectForKey:@"PhotoId"];
    for (int i=0; i<_photoarr.count; i++) {
        dict =_photoarr[i];
        if([[dict allValues] containsObject:imageID]){
            imgstr= [dict objectForKey:@"Photo"];

        }else{
            imgstr =@"";

        }
    }
//    if (indexPath.row == 2) {
        ReportViewController * perpotV = [[ReportViewController alloc]init];
        perpotV.name = name;
        perpotV.rigstr = rigstr;
        perpotV.icon = imgstr;
        perpotV.todoarr = [taskdic objectForKey:@"StudentTaskList"];
        perpotV.repotarr = [taskdic objectForKey:@"ProgressReportInfoList"];
        perpotV.indpath = indexPath.section;
        [self.navigationController pushViewController:perpotV animated:YES];
//    }
    
    
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
