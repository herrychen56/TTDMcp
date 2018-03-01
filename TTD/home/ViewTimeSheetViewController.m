//
//  ViewTimeSheetViewController.m
//  TTD
//
//  Created by ZhangChuntao on 12/7/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import "ViewTimeSheetViewController.h"
#import "ViewTimeSheetCell.h"
#import "UserCell.h"
#import "NewSessionTrackerViewController.h"
#import "DataModel.h"
#import "UIImageView+AFNetworking.h"
#import "Photo.h"


#import "UIView+MJExtension.h"
#import "MJRefresh.h"

static const CGFloat MJDuration = 0.0;
@interface ViewTimeSheetViewController ()
{
    NSInteger currentPage;
    NSInteger PageCount;
    NSString* startPage;
    NSString* endPage;
}
@end

@implementation ViewTimeSheetViewController



@synthesize backButton;
@synthesize tableView=_tableView;
- (NSString*)iconImageName
{
    return @"tab_icon_query.png";
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadTimeSheetSummary
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            startPage,@"startPage",
                            endPage,@"endPage",nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_TIMESHEET_LISTPAGE parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         NSLog(@"doc:%@", [XMLDocument description]);
         [self hiddenHUD];
         self.timeSheetArray = [TimeSheetSummary timeSheetSummaryWithDDXMLDocument:XMLDocument];
         [self.tableView reloadData];
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         NSLog(@"error:%@", error);
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
}

- (void)initUserFullName
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentPage=1;
    PageCount=10;
    startPage=@"1";
    endPage=@"10";
    shouldReload = YES;
    ////1.注册
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MJTableViewCellIdentifierFooter];
    //2.下拉刷新
    [self addFooter];
    
}
- (void)addFooter
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置文字
    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor blackColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置header
    self.tableView.mj_header = header;
  
    //__unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    //self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
     //   [weakSelf loadNewData];
    //}];
    // 马上进入刷新状态
    //[self.tableView.mj_header beginRefreshing];
}
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    currentPage=currentPage+10;
    PageCount=PageCount+10;
    startPage=[NSString stringWithFormat:@"%ld",(long)currentPage];
    endPage=[NSString stringWithFormat:@"%lD",(long)PageCount];
    NSLog(@"startPage:%@", startPage);
    NSLog(@"endPage:%@", endPage);
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            startPage,@"startPage",
                            endPage,@"endPage",nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_TIMESHEET_LISTPAGE parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         NSLog(@"doc:%@", [XMLDocument description]);
         [self hiddenHUD];
         
         NSArray* timeSheetArray=[TimeSheetSummary timeSheetSummaryWithDDXMLDocument:XMLDocument];
         
         for (int i=0; i<timeSheetArray.count; i++) {
             NSLog(@"timeSheetArraycurrentPage:%lu", (unsigned long)self.timeSheetArray.count);
             [self.timeSheetArray insertObject:timeSheetArray[i] atIndex:self.timeSheetArray.count];
         }
         // 刷新表格
         [self.tableView reloadData];
         // 拿到当前的下拉刷新控件，结束刷新状态
         [self.tableView.mj_header endRefreshing];
         
         NSInteger rows = [self.tableView numberOfRowsInSection:1];
        
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         NSLog(@"error:%@", error);
         [self showAlertWithTitle:nil andMessage:@"No Network"];
         [self.tableView.mj_header endRefreshing];
     }];
    [operation start];
    [self showHUD];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initUserFullName) name:NOTIFICATION_LOAD_FULLNAME object:nil];
    if (shouldReload || SharedAppDelegate.shouldReloadTimeSheetList) {
        [self loadTimeSheetSummary];
        SharedAppDelegate.shouldReloadTimeSheetList = NO;
    }
    else {
        shouldReload = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    currentPage=1;
    PageCount=10;
    startPage=@"1";
    endPage=@"10";
    shouldReload = YES;
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clearCache
{
    [self.timeSheetArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return self.timeSheetArray.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UserCell*)userCellForTableView:(UITableView*)tableView
{
    static NSString *CellIdentifier = @"UserCell";
    
    UserCell *cell = (UserCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil];
		cell = [topLevelObjects objectAtIndex:0];
	}
    cell.usernameLabel.text = SharedAppDelegate.currentUserInfo.userFullName;
    //    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:SharedAppDelegate.currentUserInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_addPhoto.png"]];
    if(SharedAppDelegate.imageStr.length>0)
    {
        UIImage *pp=[Photo string2Image:SharedAppDelegate.imageStr];
        cell.avatarImageView.image=pp;
    }
    
    
    return cell;
}
- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    return kViewTimesheetCellHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        return [self userCellForTableView:tableView];
    }
    
    static NSString* identifier = @"ViewTimeSheetCell";
    ViewTimeSheetCell* cell = (ViewTimeSheetCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray* array = [[UINib nibWithNibName:@"ViewTimeSheetCell" bundle:nil] instantiateWithOwner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    TimeSheetSummary* info = [self.timeSheetArray objectAtIndex:indexPath.row];
    //    cell.nameLabel.text = info.students;
    NSString* studentString = [info.students stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    cell.nameLabel.text = studentString;
    cell.location.text = info.location;
    cell.calendar.text = info.timeSheetDate;
    [cell setTutoratio:info.timeSheetState];
    //NSLog(@"timeSheetId:%@", info.timeSheetId);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        return;
    }
    TimeSheetSummary* summary = [self.timeSheetArray objectAtIndex:indexPath.row];
    NewSessionTrackerViewController* controller = [[NewSessionTrackerViewController alloc] init];
    controller.isQuery = YES;
    controller.isSetStudent=YES;
    controller.timeSheetSummary = summary;
    
    //[SharedAppDelegate.navigationController pushViewController:controller animated:YES];
    [self.navigationController pushViewController:controller animated:YES];
    //shouldReload = NO;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
// Returns interface orientation masks.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
-(BOOL)shouldAutorotat
{
    return NO;
}
@end
