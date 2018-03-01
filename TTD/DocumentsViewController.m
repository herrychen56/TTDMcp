//
//  DocumentsViewController.m
//  TTD
//
//  Created by Mark Hao on 8/15/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "DocumentsViewController.h"
#import "AFKissXMLRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "TTDDocument.h"
#import "DocumentListCell.h"
#import "DocumentDetailViewController.h"
#import "ViewStudentsUpDocumentViewController.h"
#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width
@interface DocumentsViewController () <UITableViewDelegate, UITableViewDataSource, UploadDocumentDelegate>
@property (weak, nonatomic) IBOutlet UITableView *documentTableView;
@property (strong, nonatomic) NSArray *documents;
@end
@implementation DocumentsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self performSelector:@selector(createUI) withObject:nil afterDelay:2.0];
    [self createUI];
}

-(void)createUI {
    [self getDocumentList];
    if (self.studentDetail.stu_id && ![SharedAppDelegate.role isEqualToString:@"parent"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(uploadNewDocument)];
    }
    self.documentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.documentTableView registerNib:[UINib nibWithNibName:@"DocumentListCell" bundle:nil] forCellReuseIdentifier:@"DocumentListCell"];
    [self.AddButton addTarget:self action:@selector(uploadNewDocument) forControlEvents:UIControlEventTouchUpInside];
  
}
#pragma mark - ZN-加号按钮
-(void)addExtracurricular {
    
    ViewStudentsUpDocumentViewController *updocument=[[ViewStudentsUpDocumentViewController alloc] initWithNibName:@"ViewStudentsUpDocumentViewController" bundle:nil ];
    updocument.view.frame=CGRectMake(0, 0, Screen_width, Screen_height - 50);
    updocument.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self addChildViewController:updocument];
    [self.view  addSubview:updocument.view];
    updocument.studentDetail=self.studentDetail;
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [updocument.view setFrame:CGRectMake(0,0, Screen_width, Screen_height - 50)];
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    
//    [LEEAlert actionsheet].config
//    .LeeAddAction(^(LEEAction *action) {
//
//        action.type = LEEActionTypeDefault;
//
//        action.title = @"Upload Files";
//
//        action.titleColor = [UIColor blackColor];
//
//        action.image = [UIImage imageNamed:@"uploadfile"];
//
//        action.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
//
////        action.positionType = LEECustomViewPositionTypeLeft;
//
//
//        action.height = 60.0f;
//
//        action.clickBlock = ^{
//
//            // 点击事件Block
//        };
//
//    })
//    .LeeAddAction(^(LEEAction *action) {
//
//        action.type = LEEActionTypeDefault;
//
//        action.title = @"Upload Photos";
//
//        action.titleColor = [UIColor blackColor];
//
//        action.image = [UIImage imageNamed:@"uploadphoto"];
//
//
//        action.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
//
//        action.height = 60.0f;
//
//        action.clickBlock = ^{
//
//            // 点击事件Block
//        };
//
//    })
//
//    .LeeAddAction(^(LEEAction *action) {
//
//        action.type = LEEActionTypeCancel;
//
//        action.title = @"Cancel";
//
//        action.titleColor = [UIColor blackColor];
//
//        action.image = [UIImage imageNamed:@"smile"];
//
//        action.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
//
//        action.height = 60.0f;
//
//        action.clickBlock = ^{
//
//            // 点击事件Block
//        };
//
//    })
//    .LeeShow();
}
- (void)uploadNewDocument {
    ViewStudentsUpDocumentViewController *updocument=[[ViewStudentsUpDocumentViewController alloc] initWithNibName:@"ViewStudentsUpDocumentViewController" bundle:nil];
    updocument.delegate = self;
    updocument.view.frame=CGRectMake(0, 0, Screen_width, Screen_height - 50);
    updocument.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self addChildViewController:updocument];
    [self.view addSubview:updocument.view];
    updocument.studentDetail = self.studentDetail;
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [updocument.view setFrame:CGRectMake(0,0, Screen_width, Screen_height - 50)];
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)uploadCompleted {
    [self getDocumentList];
}

- (void)loadDocumentThumbnail: (TTDDocument *)document indexPath: (NSIndexPath *)indexPath {
    NSURL *url = [NSURL URLWithString:ZNWEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            [document.docID stringValue], @"documentid", nil];
//    NSDictionary * params = @{@"username":SharedAppDelegate.username,@"password":SharedAppDelegate.password,@"documentid": [document.docID stringValue]};
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_LOAD_DOCUMENT_THUMBNAIL parameters:params];
    __weak typeof(self) wself = self;
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
         
         NSData *imageData = [TTDDocument documentThumbnailWithDDXMLDocument:XMLDocument];
         document.fileThumbnail = imageData;
         dispatch_async(dispatch_get_main_queue(), ^{
             [wself.documentTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
         });
         
     }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
        
//         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
}

- (void)getDocumentList {
    NSURL *url = [NSURL URLWithString:ZNWEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    if ([SharedAppDelegate.role isEqualToString:@"consultant"] || [SharedAppDelegate.role isEqualToString:@"manager"]|| [SharedAppDelegate.role isEqualToString:@"parent"]) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                SharedAppDelegate.username, @"username",
                                SharedAppDelegate.password, @"password",
                                self.selectRow_StudentId, @"studentId",
                                nil];
        NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_DOCUMENT_LIST_By_Student parameters:params];
        
        __weak typeof(self) wself = self;
        AFKissXMLRequestOperation *operation =
        [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
         {
             dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                 NSArray *jsonArray = [TTDDocument documentsListByStudentWithDDXMLDocument:XMLDocument];
                 NSError *error;
                 NSArray *parsedArray = [MTLJSONAdapter modelsOfClass:[TTDDocument class] fromJSONArray:jsonArray error:&error];
                 if (error != nil) {
                     NSLog(@"Error parsing documents: %@", error.localizedDescription);
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self hiddenHUD];
                     });
                 } else {
                     wself.documents = parsedArray;
                     int i = 0;
                     for (TTDDocument *document in wself.documents) {
                        
                        
                              NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 // 更新界面
                                   [wself loadDocumentThumbnail:document indexPath:indexpath];
                                 
                             });
                
                        i++;
                       
                     }
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [wself.documentTableView reloadData];
                         [self hiddenHUD];
                     });
                 }
             });
             
         }
                                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
         {
             [self hiddenHUD];
             [self showAlertWithTitle:nil andMessage:@"No Network"];
         }];
        [operation start];

    }
    else if([SharedAppDelegate.role isEqualToString:@"student"]) {
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                SharedAppDelegate.username, @"username",
                                //@"adityashah01", @"username", // for demo only; TODO: fix this when the GetDoculemtList API is changed to accept a student id.
                                SharedAppDelegate.password, @"password", nil];
        NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_DOCUMENT_LIST parameters:params];
        
        __weak typeof(self) wself = self;
        AFKissXMLRequestOperation *operation =
        [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
         {
             dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                 NSArray *jsonArray = [TTDDocument documentsWithDDXMLDocument:XMLDocument];
                 NSError *error;
                 NSArray *parsedArray = [MTLJSONAdapter modelsOfClass:[TTDDocument class] fromJSONArray:jsonArray error:&error];
                 if (error != nil) {
                     NSLog(@"Error parsing documents: %@", error.localizedDescription);
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self hiddenHUD];
                     });
                 } else {
                     wself.documents = parsedArray;
                     int i = 0;
                     for (TTDDocument *document in wself.documents) {
                    
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                                 [wself loadDocumentThumbnail:document indexPath:indexpath];
                                 
                             });
                         
                       i++;
                     }
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [wself.documentTableView reloadData];
                         [self hiddenHUD];
                     });
                 }
             });
             
         }
                                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
         {
             [self hiddenHUD];
             [self showAlertWithTitle:nil andMessage:@"No Network"];
         }];
        [operation start];

    }
    [self showHUD];
    [self showLoadingViewWithMessage:@"Loading Document List..."];
    
    //User photo
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:USER_PHOTO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSURL *Photourl = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* Photoclient = [[AFHTTPClient alloc] initWithBaseURL:Photourl];
    NSDictionary *Photoparams = [NSDictionary dictionaryWithObjectsAndKeys:
                                 SharedAppDelegate.username, @"username",
                                 nil];
    //NSLog(@"UserPhotoSet-studentname - %@",UserArrayName);
    NSMutableURLRequest *Photorequest = [Photoclient requestWithFunction:FUNC_USERPHOTO parameters:Photoparams];
    AFKissXMLRequestOperation *Photooperation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)Photorequest
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         UserPhoto* res = [UserPhoto UserPhotoWithDDXMLDocument:XMLDocument];
         NSString *aStr=res.photo;
         if(aStr.length>0)
         {
             [[NSUserDefaults standardUserDefaults] setValue:res.photo forKey:USER_PHOTO];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }else
         {
             [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:USER_PHOTO];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"error:%@", error);
     }];
    [Photooperation start];
    
}


#pragma mark - UITableView Delegate & Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.documents ? self.documents.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocumentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocumentListCell" forIndexPath:indexPath];
    
    TTDDocument *document = [self.documents objectAtIndex:indexPath.row];
    [cell setupCellWith:document];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TTDDocument *document = [self.documents objectAtIndex:indexPath.row];
    DocumentDetailViewController *vc = [[DocumentDetailViewController alloc] init];
    vc.document = document;
    vc.selectRow_StudentId=self.selectRow_StudentId;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
