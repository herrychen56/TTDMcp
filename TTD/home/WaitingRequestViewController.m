//
//  WaitingRequestViewController.m
//  TTD
//
//  Created by andy on 13-9-24.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "WaitingRequestViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "URL.h"
#import "DataModel.h"
#import "RequestStudentInfoViewController.h"
#import "Photo.h"
@interface WaitingRequestViewController ()

@end

@implementation WaitingRequestViewController
@synthesize userHeadView;
@synthesize btnAccept;
@synthesize viewRequest;
@synthesize requestAllStudentInfotArray;
@synthesize requestInfotArray;
@synthesize lblfirstmeettime;
@synthesize lblnate;
@synthesize lblLocation;
@synthesize lblstuname;
@synthesize lblsubject;
@synthesize lblTutorRadio;
@synthesize reqestid;
@synthesize scrollerview;
@synthesize userFullName;
@synthesize userHead;
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
    //设置uiview的四个角，将尖角变为圆角
    userHeadView.layer.cornerRadius=10;
    btnAccept.layer.cornerRadius=10;
    viewRequest.layer.cornerRadius=10;
    [self loadRequestByRequestId];
    [self loadStudentByRequestId];
    scrollerview.contentSize= CGSizeMake(320, 1000);
    
    userFullName.text=SharedAppDelegate.currentUserInfo.userFullName;
    if(SharedAppDelegate.imageStr.length>0)
    {
    userHead.image=[Photo string2Image:SharedAppDelegate.imageStr];
    }
    
    [self updateTutorRequestReadState];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUserHeadView:nil];
    [self setBtnAccept:nil];

    [self setLblstuname:nil];
    [self setLblsubject:nil];
    [self setLblTutorRadio:nil];
    [self setLblLocation:nil];
    [self setLblfirstmeettime:nil];
    [self setLblnate:nil];
    [self setViewRequest:nil];
    [self setScrollerview:nil];
    [super viewDidUnload];
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
         
         lblfirstmeettime.text=selectRequestById.firstmeetingtime;
         lblsubject.text=selectRequestById.subjectName;
         lblnate.text=selectRequestById.note;
         
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
         NSMutableString *allStuName=[[NSMutableString alloc]init];
         
         for (int i=0; i<self.requestAllStudentInfotArray .count; i++) {
             SelecRequestStudentInfoByRequestId *selectStuByRequestId =[self.requestAllStudentInfotArray objectAtIndex:0];
             
            NSString *name=selectStuByRequestId.lastName;
             
             [allStuName appendString:selectStuByRequestId.firstName];
             
             [allStuName appendString:@" "];
             [allStuName appendString:selectStuByRequestId.lastName];
             [allStuName appendString:@" ("];
             [allStuName appendString:selectStuByRequestId.studentId];
             [allStuName appendString:@") "];
             if(i==0)
             {
                 location=selectStuByRequestId.locationName;
             }
             
         }
        
         
         lblstuname.text=allStuName;
         lblLocation.text=location;
         NSMutableString *radio=[[NSMutableString alloc]init];
         NSString *scount=[NSString stringWithFormat:@"%ld",self.requestAllStudentInfotArray.count];
         [radio appendString:scount];
         [radio appendString:@"-1"];
         lblTutorRadio.text=radio;
         
         
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

-(void)updateTutorAccept
{
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            reqestid, @"requestid",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:AcceptRequestByTutor parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         UpdateTutorAccept* res = [UpdateTutorAccept updateTutorAcceptWithDDXMLDocument:XMLDocument];
         //修改成功
         if([res.updateAcceptMessage isEqualToString:@"ok"])
         {
             //[self showAlertWithTitle:nil andMessage:@" sucess!"];
             //跳转页面
             
             RequestStudentInfoViewController *requestController=[[RequestStudentInfoViewController alloc]init];
             requestController.reqestid=self.reqestid;
             [self.navigationController pushViewController:requestController animated:YES];

         }
         else
         {
         //[self showAlertWithTitle:nil andMessage:@" Faire!"];
             RequestStudentInfoViewController *requestController=[[RequestStudentInfoViewController alloc]init];
             requestController.reqestid=self.reqestid;
             [self.navigationController pushViewController:requestController animated:YES];
         }
         [self hiddenHUD];
         
         
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

- (void)updateTutorRequestReadState
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            reqestid,@"requestid",nil];
    NSMutableURLRequest *request = [client requestWithFunction:UpdateTutorReadState parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     { NSLog(@"update read state is error");
              }];
    [operation start];
   // [self showHUD];
}


- (IBAction)btnAccept:(id)sender {
        [self updateTutorAccept];
    
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
