//
//  StudentRequestViewController.m
//  TTD
//
//  Created by andy on 13-9-23.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "StudentRequestViewController.h"
#import "StudentRequestCell.h"
#import "URL.h"
#import "DataModel.h"
#import "WaitingRequestViewController.h"
#import "MatchedStudentCell.h"
@interface StudentRequestViewController ()

@end

@implementation StudentRequestViewController
@synthesize WaitingRequestArray;
@synthesize stuRequestTableView;
@synthesize MatchedStudentArray;
@synthesize showOne;
@synthesize waitingRequestButtion;
@synthesize matchedStudentButtion;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSString*)iconImageName
{
    return @"tab_icon_request.png";
}

- (void)viewDidLoad
{     [super viewDidLoad];
   // [self loadWaitingRequestList];
   // [self loadMatchedStudentList];
    showOne=YES;
    [waitingRequestButtion setImage:[UIImage imageNamed:@"waitreqselected.png"] forState:UIControlStateNormal];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{

    [self loadWaitingRequestList];
    [self loadMatchedStudentList];
     showOne=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setStuRequestTableView:nil];
    [self setMatchedStudentButtion:nil];
    [self setWaitingRequestButtion:nil];

    [super viewDidUnload];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return WaitingRequestArray.count;
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count=0;
    if(showOne== YES)
    {
     count=WaitingRequestArray.count;
    
    }
    else
    {
    count=MatchedStudentArray.count;
    }
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //展示waiting request 模块
    if(showOne== YES)
    {

    NSString *idetifer=@"studentrequestidentifer";
    StudentRequestCell *cell=[tableView dequeueReusableCellWithIdentifier:idetifer];
    if(cell==nil)
    {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"StudentRequestCell" owner:self options:nil]lastObject];
    }
    
   SelectWaitingRequestBytutor *waitrequestArray =[self.WaitingRequestArray objectAtIndex:indexPath.section];
    NSMutableString *stuname = [[NSMutableString alloc] initWithString:waitrequestArray.studentName];
    //NSString *stuname=waitrequestArray.studentName;
    NSString *stuid=waitrequestArray.studentId;
    [stuname appendString:@"("];
    [stuname appendString:stuid];
    [stuname appendString:@")"];
    cell.lblStuName.text=stuname;

    cell.lblLocation.text=waitrequestArray.locationName;
  
    cell.lblSubject.text=waitrequestArray.subjectName;

        if ([waitrequestArray.isRead isEqualToString:@"Y"]) {
            cell.isNew.hidden=YES;
        }
        
    
    return cell;
   }
    //展示matched student 模块
    else
    {
        NSString *idetifer=@"matchedStudentidentifer";
        MatchedStudentCell *matchedStudentcell=[tableView dequeueReusableCellWithIdentifier:idetifer];
        if(matchedStudentcell==nil)
        {
            
            matchedStudentcell = [[[NSBundle mainBundle]loadNibNamed:@"MatchedStudentCell" owner:self options:nil]lastObject];
        }
        
        SelectMatchedStudentFortutor *matchedStudentArray =[self.MatchedStudentArray objectAtIndex:indexPath.section];
        NSMutableString *stuname = [[NSMutableString alloc] initWithString:matchedStudentArray.studentName];
        //NSString *stuname=waitrequestArray.studentName;
        NSString *stuid=matchedStudentArray.studentId;
        [stuname appendString:@"("];
        [stuname appendString:stuid];
        [stuname appendString:@")"];
        matchedStudentcell.lblStuName.text=stuname;
        
        matchedStudentcell.lblStuEmail.text=matchedStudentArray.email;
        
        matchedStudentcell.lblPhone.text=matchedStudentArray.phone;
        matchedStudentcell.lblGradSchool.text=matchedStudentArray.gradschool;
        matchedStudentcell.lblGradYear.text=matchedStudentArray.gradyear;
        return matchedStudentcell;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(showOne== YES)
    {
        SelectWaitingRequestBytutor *waitrequestArray =[self.WaitingRequestArray objectAtIndex:indexPath.section];

        NSString *requid=waitrequestArray.requestId;
    WaitingRequestViewController *waitReqstController=[[WaitingRequestViewController alloc]init];
        waitReqstController.reqestid=requid;
    [self.navigationController pushViewController:waitReqstController animated:YES];
              
    }
  }
//获取服务端数据
- (void)loadWaitingRequestList
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                           /* @"yang", @"username",
                            @"yang", @"password",
                            @"499",@"tutorid",nil];
                            */
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:Func_WaitingRequest_BY_Tutor parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         NSLog(@"doc:%@", [XMLDocument description]);
         [self hiddenHUD];
         self.WaitingRequestArray =[SelectWaitingRequestBytutor  SelectWaitingRequestBytutorWithDDXMLDocument:XMLDocument];
         [self.stuRequestTableView reloadData];
         
         
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
- (void)loadMatchedStudentList
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password"
                           ,nil];
    NSMutableURLRequest *request = [client requestWithFunction:Func_MatchedStudent_BY_Tutor parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         NSLog(@"doc:%@", [XMLDocument description]);
         [self hiddenHUD];
         self.MatchedStudentArray =[SelectMatchedStudentFortutor  SelectMatchedStudentFortutorWithDDXMLDocument:XMLDocument];
         [self.stuRequestTableView reloadData];
         
         
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

//显示MatchedStudent
- (IBAction)btnMatchedStudent:(id)sender {
    showOne=NO;
    [matchedStudentButtion setImage:[UIImage imageNamed:@"matchstuselected.png"] forState:UIControlStateNormal];
    [waitingRequestButtion setImage:[UIImage imageNamed:@"waitreq.png"] forState:UIControlStateNormal];
    [self.stuRequestTableView reloadData];

    
}
//显示btnWaitingRequest
- (IBAction)btnWaitingRequest:(id)sender {
    showOne=YES;
    [matchedStudentButtion setImage:[UIImage imageNamed:@"matchstu.png"] forState:UIControlStateNormal];
    [waitingRequestButtion setImage:[UIImage imageNamed:@"waitreqselected.png"] forState:UIControlStateNormal];
    [self.stuRequestTableView reloadData];


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
