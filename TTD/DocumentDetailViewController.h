//
//  DocumentDetailViewController.h
//  TTD
//
//  Created by Mark Hao on 8/21/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDDocument.h"

@interface DocumentDetailViewController : BaseViewController<UIWebViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,NSURLConnectionDataDelegate>
{
   NSURLConnection *conn;
   NSURLRequest *fileRequest;
   NSString *MIMEType;
   CGFloat fileMB;
   long long filecurrentLength;
   long long filesumLength;
}

@property (nonatomic, strong) TTDDocument *document;
@property (strong, nonatomic) NSString* selectRow_StudentId;
@end
