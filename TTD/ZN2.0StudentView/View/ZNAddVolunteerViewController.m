//
//  ZNAddVolunteerViewController.m
//  TTD
//
//  Created by quakoo on 2017/12/6.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "ZNAddVolunteerViewController.h"
#import "FZHPickerView.h"
@interface ZNAddVolunteerViewController ()<UITextFieldDelegate,FZHPickerViewDelegate>
{
    FZHPickerView *fzpickerView;
}
//记录状态的按钮
@property (strong,nonatomic)UIButton * tmpBtn;
//swith 选中内容
@property (nonatomic,strong)NSString *plannedstr;

@property (nonatomic,strong)NSString *leadershipstr;
//多选时间
@property (nonatomic,strong)NSString * onestr;
@property (nonatomic,strong)NSString * twostr;
@property (nonatomic,strong)NSString * threestr;
@property (nonatomic,strong)NSString * fourstr;
//coll 内容
@property (nonatomic,strong)NSString * collonestr;
@property (nonatomic,strong)NSString * colltwostr;
@property (nonatomic,strong)NSString * collthreestr;
//number 判断hours／years
@property (nonatomic,strong)NSString * numbstr;
//hours str
@property (nonatomic,strong)NSString * hoursstr;
//years str
@property (nonatomic,strong)NSString * yearstr;


@end

@implementation ZNAddVolunteerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //临时禁用删除
    self.delebutton.hidden=YES;
    // Do any additional setup after loading the view from its nib.
    // 选择框
    fzpickerView = [[FZHPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-300, SCREEN_WIDTH, 220)];
    // 显示选中框
    fzpickerView.backgroundColor=[UIColor whiteColor];
    fzpickerView.fzdelegate = self;
    NSMutableArray * pickarr=[[NSMutableArray alloc]init];
//    for (int i=1; i<=40; i++) {
//        [pickarr addObject:[NSString stringWithFormat:@"%d",i]];
//    }
//    fzpickerView.proTitleList = @[pickarr];
    if ([self.cellid isEqualToString:@"0"]) {
        self.duationlab.hidden=YES;
        self.duationone.hidden=YES;
        self.duationtwo.hidden=YES;
        self.duationthree.hidden=YES;
        self.duationfour.hidden=YES;
        self.duatlabone.hidden=YES;
        self.dualabtwo.hidden=YES;
        self.dualabthree.hidden=YES;
        for (int i=1; i<=40; i++) {
            [pickarr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        fzpickerView.proTitleList = @[pickarr];
    }else if ([self.cellid isEqualToString:@"1"]){
        self.duationlab.hidden=NO;
        self.duationone.hidden=NO;
        self.duationtwo.hidden=NO;
        self.duationthree.hidden=NO;
        self.duationfour.hidden=NO;
        self.duatlabone.hidden=NO;
        self.dualabtwo.hidden=NO;
        self.dualabthree.hidden=NO;
        for (int i=1; i<=40; i++) {
            [pickarr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        fzpickerView.proTitleList = @[pickarr];
        
    }else if ([self.cellid isEqualToString:@"2"]){
        self.duationlab.hidden=YES;
        self.duationone.hidden=YES;
        self.duationtwo.hidden=YES;
        self.duationthree.hidden=YES;
        self.duationfour.hidden=YES;
        self.duatlabone.hidden=YES;
        self.dualabtwo.hidden=YES;
        self.dualabthree.hidden=YES;
        for (int i=1; i<=52; i++) {
            [pickarr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        fzpickerView.proTitleList = @[pickarr];
    }
    
    
    
    
    self.navigationItem.titleView = nil;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"Add Volunteer & Commnuity Service";
    [title setFont:[UIFont systemFontOfSize:13]];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_white"] style:UIBarButtonItemStylePlain target:self action:@selector(navleft)];
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(navright)];
    
    
    
    
    
    
    [self createUI];
}

-(void)createUI {
    //year button
    [self.delebutton addTarget:self action:@selector(delcontent) forControlEvents:UIControlEventTouchUpInside];
      //9-12
    _onestr=@"0";
    _twostr=@"0";
    _threestr=@"0";
    _fourstr=@"0";
    _collthreestr=@"0";
    _colltwostr=@"0";
    _collonestr=@"0";
    [self.onebutton addTarget:self action:@selector(onebutton:) forControlEvents:UIControlEventTouchUpInside];
    self.onebutton.tag = 100;
    self.onebutton.selected = NO;
    [self.twobutton addTarget:self action:@selector(twobutton:) forControlEvents:UIControlEventTouchUpInside];
    self.twobutton.tag = 101;
    self.twobutton.selected = NO;
    [self.threebutton addTarget:self action:@selector(threebutton:) forControlEvents:UIControlEventTouchUpInside];
    self.threebutton.tag = 102;
    self.threebutton.selected = NO;
    [self.fourbutton addTarget:self action:@selector(fourbutton:) forControlEvents:UIControlEventTouchUpInside];
    self.fourbutton.tag = 103;
    self.fourbutton.selected = NO;
    //coller 1-3
    [self.collebtn1 addTarget:self action:@selector(collone:) forControlEvents:UIControlEventTouchUpInside];
    self.collebtn1.selected = NO;
    [self.collebtn2 addTarget:self action:@selector(colltwo:) forControlEvents:UIControlEventTouchUpInside];
    self.collebtn2.selected = NO;
    [self.collebtn3 addTarget:self action:@selector(collthree:) forControlEvents:UIControlEventTouchUpInside];
    self.collebtn3.selected = NO;
    //hour /year
    [self.hoursbtn addTarget:self action:@selector(hourbutton) forControlEvents:UIControlEventTouchUpInside];
    [self.yearbtn addTarget:self action:@selector(yearbutton) forControlEvents:UIControlEventTouchUpInside];
    
    //点击空白回收键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.hrstext.delegate = self;
    
       if ([self.planstr isEqualToString:@"1"]) {
                self.planned.on = YES;
            }else{
                self.planned.on = NO;
            }
            if ([self.lenstr isEqualToString:@"1"]) {
                self.leadership.on = YES;
            }else{
                self.leadership.on = NO;
            }
    
    [self.planned addTarget:self action:@selector(planswitchAction:) forControlEvents:UIControlEventValueChanged];
    _plannedstr=@"off";
    [self.leadership addTarget:self action:@selector(leadswitchAction:) forControlEvents:UIControlEventValueChanged];
    _leadershipstr=@"off";
    
    [self.positiontext setText:self.positionstr];
    [self.activitytext setText:self.activitystr];
    [self.desciptiontext setText:self.desciptionstr];
    [self.hrstext setText:self.hrsstr];
    
    if ([self.butsectionstr containsString:@"9"]) {
        self.onebutton.selected = YES;
    }
    if ([self.butsectionstr containsString:@"10"]) {
        self.twobutton.selected = YES;
    }
    if ([self.butsectionstr containsString:@"11"]) {
        self.threebutton.selected = YES;
    }
    if ([self.butsectionstr containsString:@"12"]) {
        self.fourbutton.selected = YES;
    }
    
    
    
    
}
-(void)planswitchAction:(UISwitch *)swit {
     [fzpickerView remove];
    UISwitch *switchButton = swit;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        _plannedstr= @"on";
    }else {
        _plannedstr = @"off";
    }
}
-(void)leadswitchAction:(UISwitch *)swit {
     [fzpickerView remove];
    UISwitch *switchButton = swit;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        _leadershipstr= @"on";
    }else {
       _leadershipstr= @"off";
    }
}
#pragma mark - 键盘回收
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.positiontext resignFirstResponder];
    [self.activitytext resignFirstResponder];
    [self.desciptiontext resignFirstResponder];
    [self.hrstext resignFirstResponder];
    
     [fzpickerView remove];
}
#pragma mark -year 按钮
-(void)onebutton:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        _onestr =@"1";
    }else{
        button.selected = NO;
        _onestr =@"0";
    }
}
-(void)twobutton:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        _twostr=@"1";
    }else{
        button.selected = NO;
        _twostr=@"0";
    }
}
-(void)threebutton:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        _threestr=@"1";
    }else{
        button.selected = NO;
        _threestr=@"0";
    }
}
-(void)fourbutton:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        _fourstr=@"1";
    }else{
        button.selected = NO;
        _fourstr=@"0";
    }
}
//coll 按钮
-(void)collone:(UIButton *)button{
    if (button.selected == NO) {
        button.selected = YES;
        _collonestr=@"1";
    }else{
        button.selected = NO;
        _collonestr=@"0";
    }
}
-(void)colltwo:(UIButton *)button{
    if (button.selected == NO) {
        button.selected = YES;
        _colltwostr=@"1";
    }else{
        button.selected = NO;
        _colltwostr=@"0";
    }
}
-(void)collthree:(UIButton *)button{
    if (button.selected == NO) {
        button.selected = YES;
        _collthreestr=@"1";
    }else{
        button.selected = NO;
        _collthreestr=@"0";
    }
}
//hours 按钮
-(void)hourbutton{
    _numbstr =@"1";
    [fzpickerView show:self.view];

}
//years 按钮
-(void)yearbutton{
    _numbstr =@"2";
    [fzpickerView show:self.view];

}
#pragma mark --- 代理方法
-(void)didSelectedPickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component RowText:(NSString *)text
{
    if ([_numbstr isEqualToString:@"1"]) {
        _hoursstr =[NSString stringWithFormat:@"%@",text];
        [self.hoursbtn setTitle:[NSString stringWithFormat:@"%@",text] forState:UIControlStateNormal];
    }else{
         _hoursstr =@"0";
    }
    if ([_numbstr isEqualToString:@"2"]){
          _yearstr =[NSString stringWithFormat:@"%@",text];
        [self.yearbtn setTitle:[NSString stringWithFormat:@"%@",text] forState:UIControlStateNormal];
    }else{
        _yearstr =@"0";
    }
}




#pragma mark - textfireddelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"点击了输入框");
     [fzpickerView remove];
}

#pragma mark - 导航左侧按钮
-(void)navleft {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 导航右侧
-(void)navright {
    NSLog(@"点击了Save按钮");
NSLog(@"1=%@\n2=%@\n3=%@\n4=%@\n5=%@\n6=%@\n7=%@\n8=%@\n9=%@\n10=%@\n11=%@\n12=%@\n13=%@\n14=%@",self.positiontext.text,self.activitytext.text,self.desciptiontext.text,_onestr,_twostr,_threestr,_fourstr,_collonestr,_colltwostr,_collthreestr,self.hoursbtn.titleLabel.text,self.yearbtn.titleLabel.text,_plannedstr,_leadershipstr);
    
    if ([self.cellid isEqualToString:@"0"]) {
        [self save];
    }else if ([self.cellid isEqualToString:@"1"]){
        [self savetwo];
    }else if ([self.cellid isEqualToString:@"2"]){
        [self seavethree];
    }
    
    
}

-(void)save {
    [MBManager showLoading];
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            SharedAppDelegate.username, @"studentId",
                            self.positiontext.text,@"position",
                            self.activitytext.text,@"ActivityName",
                            self.desciptiontext.text,@"Description",
                            self.hoursbtn.titleLabel.text,@"HoursPerWeek",
                            self.yearbtn.titleLabel.text,@"WeeksPerYear",
                            _onestr,@"Grade9",
                            _twostr,@"Grade10",
                            _threestr,@"Grade11",
                            _fourstr,@"Grade12",
                            _collonestr,@"ColleageC1",
                            _colltwostr,@"ColleageC2",
                            _collthreestr,@"ColleageC3",
                            _plannedstr,@"plannedstr",
                            _leadershipstr,@"leadership",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_AddExtracurricularActivitiesByVCS parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         [MBManager hideAlert];
         ZNAddExtracurricularActivitiesByVCS * znallet = [ZNAddExtracurricularActivitiesByVCS responseWithDDXMLDocument:XMLDocument];
         NSString * json = znallet.AddExtracurricularActivitiesByVCS;
         [LEEAlert alert].config
         .LeeTitle(@"Message")
         .LeeContent(json)
         .LeeAction(@"confirm", ^{
             
         })
         .LeeShow();
         
         
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"ZNAddExtracurricularActivitiesByVCS失败===%@",error);
     }];
    [operation start];
}

-(void)savetwo {
    [MBManager showLoading];
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            SharedAppDelegate.username, @"studentId",
                            self.positiontext.text,@"position",
                            self.activitytext.text,@"ActivityName",
                            self.desciptiontext.text,@"Description",
                            self.hoursbtn.titleLabel.text,@"HoursPerWeek",
                            self.yearbtn.titleLabel.text,@"WeeksPerYear",
                            _onestr,@"Grade9",
                            _twostr,@"Grade10",
                            _threestr,@"Grade11",
                            _fourstr,@"Grade12",
                            _collonestr,@"ColleageC1",
                            _colltwostr,@"ColleageC2",
                            _collthreestr,@"ColleageC3",
                            _plannedstr,@"plannedstr",
                            _leadershipstr,@"leadership",
                            self.duationone.text,@"DurationStartYears",
                            self.duationtwo.text,@"DurationStartMonths",
                            self.duationthree.text,@"DurationEndYears",
                            self.duationfour.text,@"DurationEndMonths",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_AddExtracurricularActivitiesByWE parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         [MBManager hideAlert];
         ZNAddExtracurricularActivitiesByWE * znallet = [ZNAddExtracurricularActivitiesByWE responseWithDDXMLDocument:XMLDocument];
         NSString * json = znallet.AddExtracurricularActivitiesByWE;
         [LEEAlert alert].config
         .LeeTitle(@"Message")
         .LeeContent(json)
         .LeeAction(@"confirm", ^{
             
         })
         .LeeShow();
         
         
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"ZNAddExtracurricularActivitiesByVCS失败===%@",error);
     }];
    [operation start];
}

-(void)seavethree {
    [MBManager showLoading];
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            SharedAppDelegate.username, @"studentId",
                            self.positiontext.text,@"position",
                            self.activitytext.text,@"ActivityName",
                            self.desciptiontext.text,@"Description",
                            self.hoursbtn.titleLabel.text,@"HoursPerWeek",
                            self.yearbtn.titleLabel.text,@"WeeksPerYear",
                            _onestr,@"Grade9",
                            _twostr,@"Grade10",
                            _threestr,@"Grade11",
                            _fourstr,@"Grade12",
                            _collonestr,@"ColleageC1",
                            _colltwostr,@"ColleageC2",
                            _collthreestr,@"ColleageC3",
                            _plannedstr,@"plannedstr",
                            _leadershipstr,@"leadership",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_AddExtracurricularActivitiesByEA parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         [MBManager hideAlert];
         ZNAddExtracurricularActivitiesByEA * znallet = [ZNAddExtracurricularActivitiesByEA responseWithDDXMLDocument:XMLDocument];
         NSString * json = znallet.AddExtracurricularActivitiesByEA;
         [LEEAlert alert].config
         .LeeTitle(@"Message")
         .LeeContent(json)
         .LeeAction(@"confirm", ^{
             
         })
         .LeeShow();
         
         
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"ZNAddExtracurricularActivitiesByVCS失败===%@",error);
     }];
    [operation start];
}

//del
-(void)delcontent {
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            SharedAppDelegate.username, @"acdivId",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_DEL_EAS parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         ZNDelEAs * znallet = [ZNDelEAs responseWithDDXMLDocument:XMLDocument];
         NSString * json = znallet.deleas;
         [LEEAlert alert].config
         .LeeTitle(@"Message")
         .LeeContent(json)
         .LeeAction(@"confirm", ^{
             
         })
         .LeeShow();
         
         
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"getUPCOMINGMEETING失败===%@",error);
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
