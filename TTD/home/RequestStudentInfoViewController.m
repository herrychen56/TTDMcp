//
//  RequestStudentInfoViewController.m
//  TTD
//
//  Created by andy on 13-9-24.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "RequestStudentInfoViewController.h"
#import "URL.h"
#import "DataModel.h"
#import "StudentAndParentInfoCell.h"
#import "Photo.h"
@interface RequestStudentInfoViewController ()

@end

@implementation RequestStudentInfoViewController
@synthesize requestAllStudentInfotArray;
@synthesize requestInfotArray;
@synthesize reqestid;
@synthesize lblFirstMeetTime;
@synthesize lblLocation;
@synthesize lblNote;
@synthesize lblRadio;
@synthesize lblSubject;
@synthesize stuAndParentTableView;
@synthesize viewrequestinfo;
@synthesize scrollerview;
@synthesize subjectInfo;
@synthesize tutorInfo;

@synthesize userHeadImage;
@synthesize userName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self loadRequestByRequestId];
    [self loadStudentByRequestId];
    
  
    scrollerview.contentSize= CGSizeMake(320, 1000);
    
    userName.text=SharedAppDelegate.currentUserInfo.userFullName;
    if(SharedAppDelegate.imageStr.length>0)
    {
        userHeadImage.image=[Photo string2Image:SharedAppDelegate.imageStr];
    }

    subjectInfo.layer.masksToBounds = YES;
    subjectInfo.layer.cornerRadius = 6.0;
    subjectInfo.layer.borderWidth = 1.0;
    subjectInfo.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    tutorInfo.layer.masksToBounds = YES;
    tutorInfo.layer.cornerRadius = 6.0;
    tutorInfo.layer.borderWidth = 1.0;
    tutorInfo.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    stuAndParentTableView.layer.masksToBounds = YES;
    stuAndParentTableView.layer.cornerRadius = 6.0;
    stuAndParentTableView.layer.borderWidth = 1.0;
    stuAndParentTableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
      
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return WaitingRequestArray.count;
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count=0;
    count=self.requestAllStudentInfotArray.count;
    
        return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
            NSString *idetifer=@"studentandparentinfoidentifer";
        StudentAndParentInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:idetifer];
        if(cell==nil)
        {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"StudentAndParentInfoCell" owner:self options:nil]lastObject];
        }
        
        SelecRequestStudentInfoByRequestId *studentAndParentInfoArray =[self.requestAllStudentInfotArray objectAtIndex:indexPath.section];
    NSMutableString *allStuName=[[NSMutableString alloc]init];
      
    [allStuName appendString:studentAndParentInfoArray.firstName];
    
    [allStuName appendString:@" "];
    [allStuName appendString:studentAndParentInfoArray.lastName];
    [allStuName appendString:@" ("];
    [allStuName appendString:studentAndParentInfoArray.studentId];
    [allStuName appendString:@") "];
        cell.lblStuName.text=allStuName;
    cell.lblStuEmail.text=studentAndParentInfoArray.stuEmail;
     cell.lblGradSchool.text=studentAndParentInfoArray.stuGradSchool;
    cell.lblStuGradYear.text=studentAndParentInfoArray.stuGradYear;
    cell.lblStuPhone.text=studentAndParentInfoArray.stuPhone;
    cell.lblPName.text=studentAndParentInfoArray.parentName;
    cell.lblPEmail.text=studentAndParentInfoArray.parentEmail;
    cell.lblPContactPhone.text=studentAndParentInfoArray.contactPhone;
    cell.lblPHomePhone.text=studentAndParentInfoArray.homePhone;
     return cell;
        
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 301;
}

- (void)loadRequestByRequestId
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            reqestid,@"requestid",nil];
    NSMutableURLRequest *request = [client requestWithFunction:GetRequestInfoByRequestId parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         NSLog(@"doc:%@", [XMLDocument description]);
         [self hiddenHUD];
         self.requestInfotArray =[SelecRequestInfoByRequestId  SelecRequestInfoByRequestIdWithDDXMLDocument:XMLDocument];
         SelecRequestInfoByRequestId *selectRequestById =[self.requestInfotArray objectAtIndex:0];
         
         lblFirstMeetTime.text=selectRequestById.firstmeetingtime;
         lblSubject.text=selectRequestById.subjectName;
         lblNote.text=selectRequestById.note;
         
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

- (void)loadStudentByRequestId
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            reqestid,@"requestid",nil];
    NSMutableURLRequest *request = [client requestWithFunction:GetRequestStudentInfoByRequestId parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         NSLog(@"doc:%@", [XMLDocument description]);
         [self hiddenHUD];
         self.requestAllStudentInfotArray =[SelecRequestStudentInfoByRequestId  SelecRequestStudentInfoByRequestIdWithDDXMLDocument:XMLDocument];
         NSString *location=@"";
                 
           for (int i=0; i<self.requestAllStudentInfotArray .count; i++) {
                        if(i==0)
             {
                 SelecRequestStudentInfoByRequestId *selectStuByRequestId =[self.requestAllStudentInfotArray objectAtIndex:0];
                 

                 location=selectStuByRequestId.locationName;
             }
               break;
             
         }
         
         
        
         lblLocation.text=location;
         NSMutableString *radio=[[NSMutableString alloc]init];
         NSString *scount=[NSString stringWithFormat:@"%ld",self.requestAllStudentInfotArray.count];
         [radio appendString:scount];
         [radio appendString:@"-1"];
         lblRadio.text=radio;
         [self.stuAndParentTableView reloadData];

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

- (void)viewDidUnload {
    [self setStuAndParentTableView:nil];
    [self setLblSubject:nil];
    [self setLblRadio:nil];
    [self setLblLocation:nil];
    [self setLblFirstMeetTime:nil];
    [self setLblNote:nil];
    [self setViewrequestinfo:nil];
    [self setScrollerview:nil];

    [super viewDidUnload];
}
- (IBAction)btnBack:(id)sender {
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
