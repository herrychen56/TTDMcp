//
//  proViewController.m
//  TTD
//
//  Created by quakoo on 2018/1/29.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "proViewController.h"

@interface proViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation proViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self CreateTabV];
    
}

-(void)CreateTabV {
    _tabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-125) style:UITableViewStylePlain];
    _tabV.dataSource = self;
    _tabV.delegate = self;
    [self.view addSubview:_tabV];
}
#pragma mark -TableDeleGate
//分组cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datasout.count;
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
    NSDictionary * dic = self.datasout[indexPath.row];

    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, SCREEN_WIDTH-25, 20)];
    UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(25, 25, SCREEN_WIDTH-25, 20)];
    [downlab setTextColor:[UIColor lightGrayColor]];
    lab.text = [dic objectForKey:@"Title"];
    NSString * infotext = [dic objectForKey:@"Info"];
    if (![infotext isKindOfClass:[NSNull class]]) {
        downlab.text = infotext;
    }else{
        downlab.text=@"";
    }
//
//    downlab.text = [dic objectForKey:@"Info"];
    [cell addSubview:lab];
    [cell addSubview:downlab];
    return cell;
}
//cell 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
