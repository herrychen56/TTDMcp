//
//  SatIILIstViewController.m
//  TTD
//
//  Created by quakoo on 2018/1/26.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "SatIILIstViewController.h"

@interface SatIILIstViewController ()

@end

@implementation SatIILIstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    
}
-(void)createUI {
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200) style:UITableViewStyleGrouped];
    _tableV.delegate =self;
    _tableV.dataSource = self;
    if ([_datasout isKindOfClass:[NSNull class]]) {
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2-50, SCREEN_WIDTH, 50)];
        [lab setTextColor:[UIColor lightGrayColor]];
        lab.text =@"No Data";
        [lab setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:lab];
    }else{
        [self.view addSubview:_tableV];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if ([_datasout isKindOfClass:[NSNull class]]) {
        return 1;
    }else{
        return _datasout.count;
    }
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
    }
    
    UILabel * uplab = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, SCREEN_WIDTH-25, 30)];
    //    UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(25, 25, SCREEN_WIDTH-25, 20)];
    //    [downlab setTextColor:[UIColor lightGrayColor]];
    //    [downlab setFont:[UIFont systemFontOfSize:13]];
    [cell addSubview:uplab];
    //    [cell addSubview:downlab];
    UILabel * onelab = [[UILabel alloc]init];
    UILabel * towlab = [[UILabel alloc]init];
    //    onelab.frame = CGRectMake(SCREEN_WIDTH-215, 10, 100, 30);
    towlab.frame = CGRectMake(SCREEN_WIDTH-110, 10,100, 30);
    //    onelab.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    onelab.layer.borderWidth = 1;
    towlab.layer.borderColor = [UIColor lightGrayColor].CGColor;
    towlab.layer.borderWidth = 1;
    towlab.layer.cornerRadius = 5;
    towlab.layer.masksToBounds = YES;
    //    [onelab setTextAlignment:NSTextAlignmentCenter];
    [towlab setTextAlignment:NSTextAlignmentCenter];
    //    onelab.backgroundColor = [UIColor whiteColor];
    towlab.backgroundColor = [UIColor whiteColor];
    //    [cell addSubview:onelab];
    [cell addSubview:towlab];
    if ( [_datasout isKindOfClass:[NSNull class]]) {
        return cell;
    }else{
        
        
        NSDictionary * dic =  _datasout[indexPath.section];
        if (indexPath.row==0) {
            if([[dic objectForKey:@"DateTaken"] isEqual:[NSNull null]])
            {
                uplab.text=[NSString stringWithFormat:@"TestTime:"];
                
            }else
            {
            //删除字符串
            NSString *DateTaken = [[dic objectForKey:@"DateTaken"] stringByReplacingOccurrencesOfString:@"T" withString:@""];
            NSString *DateTaken1 = [DateTaken stringByReplacingOccurrencesOfString:@"00:00:00" withString:@""];
            NSLog(@"DateTaken1:%@",DateTaken1);
            
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"MMMM dd,yyyy"];
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
            [formatter1 setDateFormat:@"yyyy-MM-dd"];
            NSDate *resDate = [formatter1 dateFromString:DateTaken1];
            NSString *currentDateStr = [dateFormatter stringFromDate:resDate];
            //输出格式为：2018-10-27 10:22:13
            NSLog(@"%@",currentDateStr);
            
            uplab.text=[NSString stringWithFormat:@"TestTime:  %@",currentDateStr];
            }
            towlab.layer.borderWidth = 0;
        }else if (indexPath.row ==1){
            uplab.text =@"Student ID";
            towlab.text =[NSString stringWithFormat:@"%@", [dic objectForKey:@"StudentID"]];
        }else if (indexPath.row==2){
            uplab.text =@"Score";
            towlab.text =[NSString stringWithFormat:@"%@", [dic objectForKey:@"Score"]];
//        }else if (indexPath.row ==3){
//            uplab.text = @"SubjectID";
//            towlab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SubjectID"]];
//        }
//        else if (indexPath.row ==5){
//            uplab.text = @"Score";
//            towlab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Score"]];
//        }
        }
    }
    return cell;
}

#pragma mark 第section组显示的头部标题
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if ( [_datasout isKindOfClass:[NSNull class]]) {
//        return @"";
//    }else{
//        NSDictionary * dic = _datasout[section];
//        return [NSString stringWithFormat:@"%@",[dic objectForKey:@"StudentID"]];
//    }
//
//}
@end
