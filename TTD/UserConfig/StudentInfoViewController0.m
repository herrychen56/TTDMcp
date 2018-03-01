//
//  StudentInfoViewController0.m
//  TTD
//
//  Created by andy on 13-8-31.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "StudentInfoViewController0.h"
#import "StudentInfoCell0.h"
#import "URL.h"
#import "DataModel.h"
#import "Photo.h"
#import "DocumentsViewController.h"
#import "NSString+Base64Addition.h"

@interface StudentInfoViewController0 ()

@end

@implementation StudentInfoViewController0
@synthesize text;
@synthesize selectedCellIndexPath;
@synthesize arrbool;
@synthesize meetingminuteArray;
@synthesize tableview0=_tableview0;
@synthesize studentArray;
@synthesize studentid;
@synthesize lblStudentNameID;
@synthesize userPhoto;
@synthesize stuFullName;
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
   return @"tab_icon_create.png";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.meetingminuteArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize textsize;
     SelectMeetingMinuteByStudent *studetArray =[self.meetingminuteArray objectAtIndex:indexPath.section];
    text=studetArray.note;
   // if(selectedCellIndexPath!=nil)
    //{
    if(selectedCellIndexPath != nil && [selectedCellIndexPath compare:indexPath] == NSOrderedSame)
            {
        
        
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=6.0)
        {
            textsize=[text sizeWithFont:[UIFont systemFontOfSize:14]
                      constrainedToSize:CGSizeMake(220, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            
        }
        else
        {
            textsize=[text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(220, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            
            
        }
        
        
        
        return 151+textsize.height;
    }
       // else
       // {
        
       //     return 0;
       // }
    //}
	else
    {
       // return 151;
        return 120;

    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *idetifer=@"student0identifer";
    StudentInfoCell0 *cell=[tableView dequeueReusableCellWithIdentifier:idetifer];
    if(cell==nil)
    {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"StudentInfoCell0" owner:self options:nil]lastObject];
    }


 SelectMeetingMinuteByStudent *studetArray =[self.meetingminuteArray objectAtIndex:indexPath.section];
    text=[studetArray.note stripHTMLTagsFromString];
    cell.lblStuInfo.text=text;
    
    //cell.lblStuName.text=studetArray.studentId;
    cell.lblStuName.text=stuFullName;

    cell.lblStuInfo.numberOfLines=1;
    cell.lblTime.text=studetArray.interDate;
    //cell bei 被点击
   // if(selectedCellIndexPath != nil)
   // {
        if(selectedCellIndexPath != nil&&
       [selectedCellIndexPath compare:indexPath] == NSOrderedSame)
    {
        cell.lblStuInfo.numberOfLines=0;
        
        CGSize zize0;
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=6.0)
        {
            zize0=[text sizeWithFont:[UIFont systemFontOfSize:14]
                   constrainedToSize:CGSizeMake(220, 1500) lineBreakMode:NSLineBreakByWordWrapping];
            
        }
        else
        {
            zize0=[text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(220, 1500) lineBreakMode:UILineBreakModeWordWrap];
            
            
        }
        
        [cell.lblStuInfo setFrame:CGRectMake(10, 63, 220, zize0.height+20)];
        //[cell setFrame:CGRectMake(0, 0, 260, 400)];

    }
   // else
   // {
    
       // cell.hidden=YES;
       // cell.frame=CGRectMake(0, 0, 0, 0);
        
    //}
    //}
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if(arrbool.count>0)
//    {
//       
//        if([arrbool[indexPath.section] isEqualToString:@"yes"])
//        {
//            selectedCellIndexPath=nil;
//            arrbool[indexPath.section]=@"no";
//        }
//        
//        
//        else
//        {
//            selectedCellIndexPath = indexPath;
//            arrbool[indexPath.section]=@"yes";
//        }
//        
//    }
//
//    
//   [tableView reloadData];
    
    
    UIViewController *vc = [[UIViewController alloc] init];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:vc.view.frame];
    
    SelectMeetingMinuteByStudent *studentMM =[self.meetingminuteArray objectAtIndex:indexPath.section];
    [webView loadHTMLString:studentMM.note baseURL:nil];
    vc.title = [NSString stringWithFormat:@"%@ %@", lblStudentNameID.text, studentMM.interDate];
    [vc.view addSubview:webView];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadStudentByParent];
    self.tableview0.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    self.tableview0.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);

    //arrbool=[[NSMutableArray alloc]initWithObjects:@"no",@"no", nil];
        
           // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStudent:)];
    [tap setNumberOfTapsRequired:1];
    [self.lblStudentNameID addGestureRecognizer:tap];
    
}

- (void)tapStudent:(id)sender {
    // ((UITapGestureRecognizer *)sender).view.tag
    DocumentsViewController *vc = [[DocumentsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
   

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadStudentMeetingMinue
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            studentid,@"stuid",nil];
    NSMutableURLRequest *request = [client requestWithFunction:Func_GETMettingMinute_BY_STUDENT parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         NSLog(@"doc:%@", [XMLDocument description]);
         [self hiddenHUD];
         self.meetingminuteArray =[SelectMeetingMinuteByStudent  selectMeetingMinuteByStudentWithDDXMLDocument:XMLDocument];
       if(self.meetingminuteArray.count>0)
       {
         arrbool=[[NSMutableArray alloc]init];
           for (int i=0; i<self.meetingminuteArray.count; i++)
        {
             
             [arrbool addObject:@"no"];
         }

       }
         [self.tableview0 reloadData];
         
                 
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

- (void)loadStudentByParent
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:Func_STUDENTBY_PARENT parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         NSLog(@"doc:%@", [XMLDocument description]);
         [self hiddenHUD];
         self.studentArray =[SelectStudentByParent  selectStudentByParentWithDDXMLDocument:XMLDocument];
         
         if(self.studentArray.count>0)
         {
             SelectStudentByParent *selectStudentByParent=[self.studentArray objectAtIndex:0];
             
             studentid=selectStudentByParent.studentId;
             [self loadStudentMeetingMinue];
             
             stuFullName=[@"" stringByAppendingFormat:@"%@ %@",selectStudentByParent.firstName,selectStudentByParent.lastName];
             NSString *fullName=[stuFullName stringByAppendingFormat:@" (%@)",selectStudentByParent.studentId];
             lblStudentNameID.text=fullName;
             if(SharedAppDelegate.imageStr.length>0)
             {
                 
                 userPhoto.image=[Photo string2Image:SharedAppDelegate.imageStr];
             }
             
         }

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
    [self setTableview0:nil];
    [super viewDidUnload];
}
- (IBAction)btnPrevious:(id)sender {
    
    if(self.studentArray.count>1)
    {
        SelectStudentByParent *selectStudent;
        NSInteger next=self.studentArray.count-1;
        for (int i=0; i<self.studentArray.count; i++) {
            
            if(i!=0)
            {
                selectStudent=[self.studentArray objectAtIndex:i];
                
                if([selectStudent.studentId isEqualToString:self.studentid])
                {
                    next=i-1;
                    break;
                }
            }
            
        }
        
        selectStudent=[self.studentArray objectAtIndex:next];
        self.studentid=selectStudent.studentId;
        NSString *fullname=[@"" stringByAppendingFormat:@"%@%@ (%@)",selectStudent.firstName,selectStudent.lastName,selectStudent.studentId];
        lblStudentNameID.text=fullname;
        
        
        [self loadStudentMeetingMinue];
        
        
    }

}

- (IBAction)btnNext:(id)sender {
    if(self.studentArray.count>1)
    {
        SelectStudentByParent *selectStudent;
        NSInteger next=0;
        for (int i=0; i<self.studentArray.count; i++) {
            if(i!=self.studentArray.count-1)
            {
            
            
            selectStudent=[self.studentArray objectAtIndex:i];
            
            if([selectStudent.studentId isEqualToString:self.studentid])
            {
                next=i+1;
                break;
            }
            }
            
        }
        
        selectStudent=[self.studentArray objectAtIndex:next];
        self.studentid=selectStudent.studentId;
        NSString *fullname=[@"" stringByAppendingFormat:@"%@%@ (%@)",selectStudent.firstName,selectStudent.lastName,selectStudent.studentId];
        lblStudentNameID.text=fullname;

        
        [self loadStudentMeetingMinue];
        
    
    }
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
