//
//  Message.m
//  QQChatDemo
//
//  Created by hellovoidworld on 14/12/8.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import "Message.h"

@implementation Message

- (instancetype) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super init]) {
//        [self setValuesForKeysWithDictionary:dictionary];
//        NSLog(@"=====setvalue ===%@",[dictionary allValues]);
        //时间
        NSString * timeString = [dictionary objectForKey:@"time"];
        
        NSTimeInterval time=[timeString doubleValue];//因为时差问题要加8小时 == 28800 sec 如果不准确则不加
        
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        
//        NSLog(@"date:%@",[detaildate description]);
        
        //实例化一个NSDateFormatter对象
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        //设定时间格式,这里可以设置成自己需要的格式
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
        
        // 毫秒值转化为秒
//        NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
//        NSString* timestr = [formatter stringFromDate:date];
        
        NSNumber * typenumber = [dictionary objectForKey:@"type"];
        int typeInt = [typenumber  intValue ] ;
        
        //发送方
        int motpe;
        NSString * motp=[dictionary objectForKey:@"state"];
        if ([motp isEqualToString:@"1"]) {
            motpe =1;
        }else{
            motpe = 0;
        }
        
        
        if (typeInt ==0) {
            //文字
            self.text =[dictionary objectForKey:@"content"];
            self.modetype = 0;
            self.imgurl =@"";
            self.audio =@"";
        }else if (typeInt ==1){
            //图片
            self.imgurl = [dictionary objectForKey:@"content"];
            self.modetype = 1;
            self.text=@"";
            self.audio=@"";
        }else if (typeInt ==2){
            //语音
            self.audio =[dictionary objectForKey:@"content"];
            self.modetype = 2;
            self.text=@"";
            self.imgurl =@"";
        }
        
        self.time = currentDateStr;
        self.type = motpe;
        self.myicon =[dictionary objectForKey:@"myicon"];
        self.outhericon = [dictionary objectForKey:@"outhericon"];
        self.messageId = [dictionary objectForKey:@"messageId"];
        NSString * statestr =[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"messagesendType"]];
        if ([statestr isEqualToString:@"<null>"]) {
            self.state =0;
        }else{
        
        self.state = [[dictionary objectForKey:@"messagesendType"]intValue];
        }
    }
    
    return self;
}


-(NSInteger)moviePlayTime:(NSURL *)movieStr {           //视频的时长
    NSURL    *movieURL = movieStr;
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];  // 初始化视频媒体文件
    //int minute = 0,
    NSInteger second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    if (second >= 60) {
        second=60;
    }
    return second;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"过滤掉的key==%@",key);
}


+ (instancetype) messageWithDictionary:(NSDictionary *) dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

+ (instancetype) message {
    return [self messageWithDictionary:nil];
}

@end
