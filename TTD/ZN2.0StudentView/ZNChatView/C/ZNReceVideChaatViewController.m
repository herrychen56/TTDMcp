//
//  ZNReceVideChaatViewController.m
//  TTD
//
//  Created by quakoo on 2017/12/19.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "ZNReceVideChaatViewController.h"
#import "MyAVAudioPlayer.h"
#import "NSData+Base64.h"
#import <OpenTok/OpenTok.h>
#import "ZNVideoWaitingViewController.h"//单人视频聊天
#import "ZNManyPeopleVideoViewController.h" //多人视频聊天

@interface ZNReceVideChaatViewController ()
@end

@implementation ZNReceVideChaatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"发送人姓名====%@",self.nametext);
    NSLog(@"人数===%@",self.numberstr);
    NSLog(@"1-2修改后动态人数=%lu",self.otherArr.count);
   NSArray *strs=[self.nametext componentsSeparatedByString:@"@"];
    [self.namelab setText:[NSString stringWithFormat:@"%@",strs[0]]];
//    [self.otherArr addObject:[NSString stringWithFormat:@"%@",strs[0]]];
    self.answerbtn.layer.cornerRadius = 25;
    self.answerbtn.layer.masksToBounds = YES;
    self.rejectbtn.layer.cornerRadius = 25;
    self.rejectbtn.layer.masksToBounds = YES;
    [self.answerbtn addTarget:self action:@selector(answervideochat) forControlEvents:UIControlEventTouchUpInside];
    [self.rejectbtn addTarget:self action:@selector(rejectvideochat) forControlEvents:UIControlEventTouchUpInside];
    
    [[MyAVAudioPlayer sharedAVAudioPlayer]playMP3:@"VideoSound"];
    //收到挂断通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(disconnectV:) name:@"disconnectVideo" object:nil];
    
}
#pragma mark - 挂断视频通知
-(void)disconnectV:(NSNotification *)notif {
    [[MyAVAudioPlayer sharedAVAudioPlayer].player stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -拒绝接听
-(void)rejectvideochat {
//    [[MyAVAudioPlayer sharedAVAudioPlayer]playStopMusic];
    [[MyAVAudioPlayer sharedAVAudioPlayer].player stop];
    [self dismissViewControllerAnimated:YES completion:nil];
//     [[NSNotificationCenter defaultCenter]postNotificationName:@"RejectVRideoequestCoseView" object:nil];
    [self RejectVideoRequests];
}
#pragma mark -同意接听
-(void)answervideochat {
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    app.isvideochat = [NSNumber numberWithInt:1];
    app.isvideo = YES;
     [[MyAVAudioPlayer sharedAVAudioPlayer].player stop];
    
    if ([self.reqname isEqualToString:@"twopersonvideo"]) {
        //两人视频
        ZNVideoWaitingViewController * TwoPersonVideoChat = [[ZNVideoWaitingViewController alloc]init];
        TwoPersonVideoChat.IsCalled=YES;
        [self presentViewController:TwoPersonVideoChat animated:YES completion:nil];
        
    }else if ([self.reqname isEqualToString:@"chatVideoUI"]){
        //多人视频
        ZNManyPeopleVideoViewController * znmaypeople =[[ZNManyPeopleVideoViewController alloc]init];
        NSLog(@"接听页面收到的参会人员数据==%@",self.numberstr);
        znmaypeople.getvideoarr = self.numberstr;
        znmaypeople.alluesrArr = self.otherArr;
        znmaypeople.SessionID = self.VsessionID;
        [self presentViewController:znmaypeople animated:YES completion:nil];
    }
    
    
   

    
    
   
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)RejectVideoRequests{
    NSArray *strs=[self.nametext componentsSeparatedByString:@"/"];
    NSString * bodystr =@"receVideo";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString * bodyStr=[NSString stringWithFormat:@"%@*%@",dateString,bodystr];
    NSMutableString *soundString = [[NSMutableString alloc]initWithString:@"[/9]"];
    [soundString appendString:bodyStr];
    //发送消息
    //XMPPFramework主要是通过KissXML来生成XML文件
    //生成<body>文档
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:soundString];
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:self.nametext];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    //组合
    [mes addChild:body];
    NSXMLElement *received = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [mes addChild:received];
    [[XMPPServer xmppStream] sendElement:mes];
    NSLog(@"发送拒绝接收消息。内容 =%@,接收者=%@",soundString,strs[0]);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
