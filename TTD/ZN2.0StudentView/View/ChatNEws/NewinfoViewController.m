//
//  NewinfoViewController.m
//  TTD
//
//  Created by 张楠 on 2018/1/31.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "NewinfoViewController.h"

@interface NewinfoViewController ()

@end

@implementation NewinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.titleView = nil;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    // Do any additional setup after loading the view.
    
    UIScrollView * scroll =[[UIScrollView alloc]init];
    scroll.backgroundColor=[UIColor whiteColor];
    scroll.bounces=NO;
    scroll.alwaysBounceVertical=YES;
    scroll.scrollEnabled = YES;
    UILabel * titlab=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-20, 40)];
    titlab.text=self.title;
    [scroll addSubview:titlab];
    UILabel * datalab = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, SCREEN_WIDTH-20, 30)];
    [datalab setTextColor:[UIColor grayColor]];
    datalab.text=self.datestr;
    [scroll addSubview:datalab];
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 110, SCREEN_WIDTH-40, 260)];
    [image sd_setImageWithURL:[NSURL URLWithString:self.imagestr]];
    [scroll addSubview:image];
    
    UILabel *textLabel = [[UILabel alloc] init];
    
    textLabel.font = [UIFont systemFontOfSize:16];
    
    NSString *str = self.infotext;
    
    textLabel.text = str;
    
//    textLabel.backgroundColor = [UIColor redColor];
    
    textLabel.numberOfLines = 0;//根据最大行数需求来设置
    
    textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH-40, 9999);//labelsize的最大值
    
    //关键语句
    
    CGSize expectSize = [textLabel sizeThatFits:maximumLabelSize];
    
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    
    textLabel.frame = CGRectMake(20, 380, expectSize.width, expectSize.height);
    
    [scroll addSubview:textLabel];

    
    scroll.showsVerticalScrollIndicator = NO;
    scroll.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60);
//    scroll.contentOffset = CGPointMake(0, -100);
    scroll.directionalLockEnabled = YES;
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH,titlab.frame.size.height + datalab.frame.size.height + image.frame.size.height + textLabel.frame.size.height+200);
        
    
    
   
  
    
    [self.view addSubview:scroll];
    
    
    
    
    
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
