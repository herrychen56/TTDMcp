//
//  ZNNOtificViewController.m
//  TTD
//
//  Created by 张楠 on 2018/2/3.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "ZNNOtificViewController.h"

@interface ZNNOtificViewController ()

@end

@implementation ZNNOtificViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = nil;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"Message Notification";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
     self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    
    //判断是否有铃声
    NSString* isvoice=[[NSUserDefaults standardUserDefaults] objectForKey:CHAT_VOICE];
    if(isvoice==nil||[isvoice isEqualToString:@"YES"])
    {
        
        [self.sound setOn:YES];
    }
    else
    {
        [self.sound setOn:NO];
    }
    
    NSString* isVibrations=[[NSUserDefaults standardUserDefaults] objectForKey:CHAT_VIBRATIONS];
    
    if(isVibrations==nil||[isVibrations isEqualToString:@"OK"])
    {
        [self.vibra setOn:YES];
    }
    else
    {
        [self.vibra setOn:NO];
        
    }
    if([SharedAppDelegate.role isEqualToString:@"consultant"]||[SharedAppDelegate.role isEqualToString:@"student"]||[SharedAppDelegate.role isEqualToString:@"manager"])
    {
        [self.vibra setHidden:NO];
    }
    else
    {
        [self.vibra setHidden:YES];
    }
 
}

- (IBAction)soundbtn:(id)sender {
    BOOL isSetVoice=[self.sound isOn];
    
    if(isSetVoice)
    {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:CHAT_VOICE];
        
    }
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:CHAT_VOICE];
        
    }
}

- (IBAction)vibrabtn:(id)sender {
    BOOL isVibrations=[self.vibra isOn];
    
    if(isVibrations)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"OK" forKey:CHAT_VIBRATIONS];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"NOOK" forKey:CHAT_VIBRATIONS];
    }
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
