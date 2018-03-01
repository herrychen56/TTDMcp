//
//  DocumentDetailViewController.m
//  TTD
//
//  Created by Mark Hao on 8/21/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "DocumentDetailViewController.h"

@interface DocumentDetailViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation DocumentDetailViewController

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
    }
    return _webView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self downloadDocument];
    self.webView.delegate = self;
}

- (void)downloadDocument {
    
    NSURL *url = [NSURL URLWithString:ZNWEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            [self.document.docID stringValue], @"documentid", nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_DOWNLOAD_DOCUMENT_FILE parameters:params];
    
    __weak typeof(self) wself = self;
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         NSData *fileData = [TTDDocument documentDataWithDDXMLDocument:XMLDocument];
         NSString *extension = [[self.document.documentName componentsSeparatedByString:@"."] lastObject];
         NSString *fileType =nil;

         if ([extension isEqualToString:@"docx"] )
         {
             extension = @"vnd.openxmlformats-officedocument.wordprocessingml.document";
             fileType = [NSString stringWithFormat:@"application/%@", [extension lowercaseString]];
         }
         else if ([extension isEqualToString:@"doc"] )
         {
             extension = @"msword";
             fileType = [NSString stringWithFormat:@"application/%@", [extension lowercaseString]];
         }
         else if ([extension isEqualToString:@"ppt"] )
         {
             extension = @"vnd.ms-powerpoint";
             fileType = [NSString stringWithFormat:@"application/%@", [extension lowercaseString]];
         }
         else if ([extension isEqualToString:@"pptx"] )
         {
             extension = @"vnd.openxmlformats-officedocument.presentationml.presentation";
             fileType = [NSString stringWithFormat:@"application/%@", [extension lowercaseString]];
         }
         else if([extension isEqualToString:@"txt"]||[extension isEqualToString:@"text"])
         {
             fileType = [NSString stringWithFormat:@"text/plain"];
         }
         else if([extension isEqualToString:@"png"]||[extension isEqualToString:@"bmp"]||[extension isEqualToString:@"jpe"]||[extension isEqualToString:@"jpeg"]||[extension isEqualToString:@"jpg"]||[extension isEqualToString:@"gif"])
         {
             fileType = [NSString stringWithFormat:@"image/%@", [extension lowercaseString]];
         }
        
         else
         {
             fileType = [NSString stringWithFormat:@"application/%@", [extension lowercaseString]];
         }
        
         
//         NSString *docsDir;
//         NSArray *dirPaths;
//         
//         dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//         docsDir = [dirPaths objectAtIndex:0];
//         NSString *filePath = [docsDir stringByAppendingPathComponent:self.document.documentName];
//         [fileData writeToFile:filePath atomically:YES];
//         
//         NSLog(@"filePath:%@", filePath);
         
         dispatch_async(dispatch_get_main_queue(), ^{
             wself.webView.scalesPageToFit = YES;
             [wself.webView loadData:fileData MIMEType:fileType textEncodingName:@"utf-8" baseURL:[NSURL URLWithString:@""]];
         });
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    
    if (HUD) {
        [self hiddenHUD];
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.dimBackground = NO;
    HUD.delegate=self;
    HUD.mode=MBProgressHUDModeIndeterminate;
    HUD.labelText=@"Loading...";
    [HUD show:YES];
    //[self showHUD];
    //[self showLoadingViewWithMessage:@"Loading..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView.isLoading)
        return;
    
    [self hiddenHUD];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [self hiddenHUD];
    
}
//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request navigationType:(UIWebViewNavigationType)navigationType {
//    
//    if (navigationType==UIWebViewNavigationTypeFormSubmitted)
//    {
//      
//        return NO;
//        
//    }
//    else
//    {
//        return YES;
//    }
//}
//-(void)Fileconnection:(NSURLRequest *)_request
//{
//    conn=[NSURLConnection connectionWithRequest:_request delegate:self];
//    [conn start];
//}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    NSLog(@"Error Message: %@", error.localizedFailureReason);
//}
////当接收到服务器的数据时会调用（可能会被调用多次，每次只传递部分数据）
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    filecurrentLength +=[data length];
//    HUD.progress=(CGFloat)filecurrentLength/(CGFloat)filesumLength;
//    
//}
////当接收到服务器的响应（连通了服务器）时会调用
//-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    filecurrentLength=0;
//    fileMB=(CGFloat)filesumLength/(1024.0*1024.0);
//}
////请求错误（失败）的时候调用（请求超时\断网\没有网\，一般指客户端错误）
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    [self hiddenHUD];
//}
//
//#pragma mark 进度
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//
//{
//    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
//        
//        NSProgress *progress = (NSProgress *)object;
//        HUD.progress = progress.fractionCompleted;
//    }
//}
//#pragma mark -
@end
