//
//  MyAVAudioPlayer.m
//  FreeMusic
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MyAVAudioPlayer.h"

@implementation MyAVAudioPlayer

static NSMutableDictionary *_players;

-(instancetype)init{
    if (self == [super init]) {
        
    }
    return self;
}
#pragma mark 单例模式(避免同时播放多首歌)
+(instancetype)sharedAVAudioPlayer{
    static MyAVAudioPlayer *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
#pragma mark 通过音乐名称播放音乐
-(void)playMusicWithMusicName:(NSData *)musicName{

//    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:musicName withExtension:@"mp3"];
    NSData * data = musicName;
    if (data == nil) return;
    NSError * error;
    // 2.2.创建对应的播放器
    _player = [[AVAudioPlayer alloc] initWithData:musicName error:&error];//AVFileTypeWAVE 为音频格式
    if (error) {
        NSLog(@"音频播放失败原因=%@",error);
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [_player prepareToPlay];

        dispatch_async(dispatch_get_main_queue(), ^{
           [_player play];
        });
  
    
    
}
-(void)playerdidend:(NSNotification *)notf {
    NSLog(@"监听播放完毕");
}
-(void)playOrStopMusic:(NSTimer *)timer{
    if ([_player isPlaying]) {
        [timer setFireDate:[NSDate distantFuture]];
        [_player pause];
        return;
    }
    [timer setFireDate:[NSDate date]];
    [_player play];
}
//获取当前时间
-(NSTimeInterval)getCurTime{
    NSTimeInterval curTime = [_player currentTime];
    return curTime;
}
//获取总时间长
-(NSTimeInterval)getDuration{
    NSTimeInterval duration = [_player duration];
    return duration;
}
//设置当前时间
-(void)setDuration:(float)sliderValue{
    float b = sliderValue * _player.duration;
    _player.currentTime = b;
}
-(void)playStopMusic {
    if ([_player isPlaying])
    {
         [_player stop];
           return;
    }
        [_player play];
         
}
//播放mp3 音乐
-(void)playMP3:(NSString *)Mp3Name {
    NSString *string = [[NSBundle mainBundle] pathForResource:Mp3Name ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:string];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.numberOfLoops =-1;
    [_player prepareToPlay];
    
    
    [_player play];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


@end
