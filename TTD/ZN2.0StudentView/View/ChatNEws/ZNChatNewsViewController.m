//
//  ZNChatNewsViewController.m
//  TTD
//
//  Created by 张楠 on 2018/1/31.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "ZNChatNewsViewController.h"
#import "NEwsTableViewCell.h"
#import "NewinfoViewController.h"
@interface ZNChatNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableV;

@end

@implementation ZNChatNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50) style:UITableViewStylePlain];
    _tableV.delegate=self;
    _tableV.dataSource=self;
    [_tableV registerNib:[UINib nibWithNibName:@"NEwsTableViewCell" bundle:[NSBundle mainBundle]]forCellReuseIdentifier:@"NewCell"];
    [self.view addSubview:_tableV];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasout.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NEwsTableViewCell *newcell = [tableView dequeueReusableCellWithIdentifier:@"NewCell"];
    NSDictionary * dic = self.datasout[indexPath.row];
    newcell.titlelab.text=[dic objectForKey:@"Title"];
    newcell.datalab.text=[dic objectForKey:@"Date"];
    [newcell.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"Image"]]]];
    [newcell.contentext setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"Introduction"]]];
    
    return newcell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 320;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = self.datasout[indexPath.row];
    NewinfoViewController * infv=[[NewinfoViewController alloc]init];
    infv.title = [dic objectForKey:@"Title"];
    infv.datestr =[dic objectForKey:@"Date"];
    infv.imagestr =[dic objectForKey:@"Image"];
    infv.infotext =[dic objectForKey:@"Info"];
    [self.navigationController pushViewController:infv animated:YES];
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
