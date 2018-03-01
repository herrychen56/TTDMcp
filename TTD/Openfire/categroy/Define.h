//
//  Define.h
//  BaseProject
//
//  Created by Huan Cho on 13-8-5.
//  Copyright (c) 2013年 ch. All rights reserved.
//

#ifndef BaseProject_Define_h
#define BaseProject_Define_h



#endif
//
//NSURL *url = [NSURL URLWithString:SERVER_URL];
//AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
//NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:nil];
//NSMutableURLRequest *request = [client requestWithFunction:FUNC_USERPHOTO parameters:params];
//AFKissXMLRequestOperation *operation =
//[AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)reqandyuest
//                                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
// {
//     OpengfireServerInfo* res = [OpengfireServerInfo OpengfireServerInfoWithDDXMLDocument:XMLDocument];
//     
//     [self hiddenHUD];
// }
//                                                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
// {
//     
//     NSLog(@"error:%@", error);
//     [self hiddenHUD];
// }];
//[operation start];
//[self showHUD];

//Test 服务器 ip
//#define OpenFireUrl @"192.168.1.9"
//Test 服务器 域
//#define OpenFireHostName @"web-c-2"

//US Test
//服务器 ip
//#define OpenFireUrl @"test.ttlhome.com"
//服务器 域
//#define OpenFireHostName @"test-u-1.thinktank.com"


//TokBox 视频
////APIKEY
//#define TokBoxAPIKey @"46010342"
////sessionID
//#define TokBoxSession @"SECRETc5da1fa32e2e49d7221e3781c11386f62ad67117"
////Token
//#define TokBoxToken @""


//US
//服务器 ip
#define OpenFireUrl @"ttlhome.com"
//服务器 域
#define OpenFireHostName @"ttlhome.com"

//China
//服务器 ip
//#define OpenFireUrl @"ttd.ttlearning.com.cn"
//服务器 域
//#define OpenFireHostName @"web-c-1"


//通知栏
#define kXMPPNewMsgNotifaction @"xmppNewMsgNotifaction"

//FMDB
#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

#define DATABASE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingString:@"/weChat.sqlite"]
