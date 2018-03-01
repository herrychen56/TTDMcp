//
//  HomeViewController.m
//  TTD
//
//  Created by ZhangChuntao on 12/7/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import "HomeViewController.h"
#import "SmoothLineView.h"
#import "DataModel.h"
#import "NewSessionTrackerViewController.h"
#import "ViewTimeSheetViewController.h"

@implementation HomeViewController
//herry
@synthesize outletTotalHours;
@synthesize outletTotalPayment;
- (NSString*)iconImageName
{
    //return @"tab_icon_home.png";
    return @"tab_icon_timesheet.png";
}

- (void)resetViews
{
    [self loadNeededInfo];
}

- (void)loadNeededInfo
{
    [self loadDurationInfo];
    [self loadUserInfo];
    [self loadRatioInfo];
    [self loadLocationInfo];
    [self loadSubjectInfo];
    //herry
    //[self loadTutorPaymentAndTutorHour];
    //[self loadUpdateInfo];
}
- (void)loadStudentInfo
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password", nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_TIMESHEET_STUDENT parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         SharedAppDelegate.studentArray = [StudentInfo studentsArrayWithDDXMLDocument:XMLDocument];
         
         if (SharedAppDelegate.studentArray.count>1) {
             for(int i=0;i<SharedAppDelegate.studentArray.count;i++)
             {
                 StudentInfo *studentinfo=[SharedAppDelegate.studentArray objectAtIndex:i];
                 if(studentinfo.studentId<0)
                 {
                     [SharedAppDelegate.studentArray removeObjectAtIndex:i];
                 }
                 
             }
         }
 
        
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
     }];
    [operation start];
    [self showHUD];
}

- (void)loadUserInfo
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"tutor",                   @"currentrole",
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password", nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_USER_INFO parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         //NSLog(@"doc:%@", XMLDocument);
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOAD_FULLNAME object:nil];
         SharedAppDelegate.currentUserInfo = [UserInfo userInfoWithDDXMLDocument:XMLDocument];
         NSLog(@"userinfo:%@, %@, %@", SharedAppDelegate.currentUserInfo.avatarUrl, SharedAppDelegate.currentUserInfo.firstName, SharedAppDelegate.currentUserInfo.lastName);
         [self hiddenHUD];
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
}

- (void)loadUpdateInfo
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],    @"Version", nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_UPDATE_INFO parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         NSLog(@"%@", XMLDocument);
         SharedAppDelegate.updateInfo = [UpdateInfo updateInfoWithDDXMLDocument:XMLDocument];
         if (SharedAppDelegate.updateInfo.hasNewVersion) {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Version" message:@"New version available, would you like to update?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
             [alert show];
         }
         [self hiddenHUD];
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         NSLog(@"error:%@", error);
     }];
    [operation start];
    [self showHUD];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SharedAppDelegate.updateInfo.updateUrl]];
    }
}

- (void)loadLocationInfo
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password", nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_LOCATION parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         SharedAppDelegate.locationArray = [LocationInfo locationArrayWithXMLDocument:XMLDocument];
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOAD_LOCATION object:nil];
         
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
}

- (void)loadRatioInfo
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password", nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_TIMESHEET_TOTIO parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         SharedAppDelegate.totioArray = [RatioInfo arrayWithXMLDocument:XMLDocument];
         [self hiddenHUD];
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOAD_TOTIO object:nil];
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         NSLog(@"result, error:%@",error);
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
}

- (void)loadDurationInfo
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password", nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_TIMESHEET_DURATION parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         SharedAppDelegate.durationArray = [DurationInfo arrayWithXMLDocument:XMLDocument];
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOAD_DURATION object:nil];
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         NSLog(@"result, error:%@",error);
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
}

- (void)loadSubjectInfo
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password", nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_TIMESHEET_SUBJECT parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         NSLog(@"%@", XMLDocument);
         SharedAppDelegate.subjectArray = [SubjectInfo subjectsArrayWithXMLDocument:XMLDocument];
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOAD_SUBJECT object:nil];
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         NSLog(@"result, error:%@",error);
     }];
    [operation start];
}

- (void)loadTutorPaymentAndTutorHour
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password", nil];
    NSMutableURLRequest *request = [client requestWithFunction:GetTutorRecentPaymentAndTutorTotalHour parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         //NSLog(@"%@", XMLDocument);
         NSString *info = [GetTutorPaymentAndTotalHour tutorPaymentAndTotalHourWithDDXMLDocument:XMLDocument];
         
         NSRange range=[info rangeOfString:@"|"];
         if(range.length==1)
         {
         if(range.location>=1)
         {
             outletTotalPayment.text=[info substringToIndex:range.location];
         }
             outletTotalHours.text=[[info substringFromIndex:range.location+1]stringByAppendingString:@" hrs"];
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOAD_SUBJECT object:nil];
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         NSLog(@"result, error:%@",error);
     }];
    [operation start];
}

- (IBAction)createTimeSheet:(id)sender
{
   // [SharedAppDelegate setSelectedTab:1];
    //herry20140701
    NewSessionTrackerViewController *createController=[[NewSessionTrackerViewController alloc] init];
    
    [self.navigationController pushViewController:createController animated:YES];
}

- (IBAction)viewTimeSheet:(id)sender
{
   // [SharedAppDelegate setSelectedTab:2];
    ViewTimeSheetViewController *viewController=[[ViewTimeSheetViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)logout:(id)sender
{
    [self loginoutsave];
    [SharedAppDelegate showLogin:NO animated:YES];
    [SharedAppDelegate clearAllCache];
}

- (void)loginoutsave
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            @"ios",@"source",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:User_LoginOut parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         UserLoginOutResponse* res = [UserLoginOutResponse userLoginOutResponseWithDDXMLDocument:XMLDocument];
         if (!res.userLoginOutMessage) {
             NSLog(@"退出日志写入失败");
             }
         else
         {
             if ([res.userLoginOutMessage isEqualToString:@"true"]) {
                 
                 NSLog(@"退出日志写入成功");
             }
             else
             {
              NSLog(@"退出日志写入失败");
             }
         }
         
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         NSLog(@"result, error:%@",error);
     }];
    [operation start];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initSubviews
{
    SharedAppDelegate.shouldReloadMutableData = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSubviews];
    [self loadStudentInfo];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
