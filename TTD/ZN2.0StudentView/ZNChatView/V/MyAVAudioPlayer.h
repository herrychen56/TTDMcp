//
//  MyAVAudioPlayer.h
//  FreeMusic
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MyAVAudioPlayer : AVAudioPlayer

@property(nonatomic,strong) AVAudioPlayer *player;

-(instancetype)init;
+(instancetype)sharedAVAudioPlayer;
//通过传递的歌曲名称进行播放
-(void)playMusicWithMusicName:(NSData *)musicName;
//开始或暂停
-(void)playOrStopMusic:(NSTimer *)timer;
//获取当前时间
-(NSTimeInterval)getCurTime;
//获取总时间
-(NSTimeInterval)getDuration;
//设置当前时间
-(void)setDuration:(float)sliderValue;
-(void)playStopMusic;
-(void)playMP3:(NSString *)Mp3Name;
@end
