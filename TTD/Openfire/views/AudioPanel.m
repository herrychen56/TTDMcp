//
//  AudioPanel.m
//  AudioBarDemo
//
//  Created by LIKUN on 13-11-8.
//  Copyright (c) 2013年 LIKUN. All rights reserved.
//

#import "AudioPanel.h"

@implementation AudioPanel
@synthesize greenBar;
@synthesize time;
@synthesize timer;
@synthesize isPlaying;
@synthesize duration;
@synthesize isOver;
@synthesize delegate=_delegate;
@synthesize playBtn;
@synthesize grayBar;
@synthesize timeLabel;
- (id)initWithFrame:(CGRect)frame timeLength:(CGFloat)len playBtnTag:(int)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self layOutAudioPanelView:len buttonTag:tag];
    }
    return self;
}

- (void)setPlayBtnTag:(NSInteger)tag
{
    [self.playBtn setTag:tag];
}

//初始化View
- (void)layOutAudioPanelView:(CGFloat)timeLength  buttonTag:(NSInteger)tag
{
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setFrame:CGRectMake(10, 5, 30, 30)];
    playBtn.tag = tag;
    [playBtn setBackgroundImage:[UIImage imageNamed:@"97"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playBtn];
    
    self.grayBar = [[UIView alloc]initWithFrame:CGRectMake(40, 15, timeLength*secondLength, 10)];
    NSLog(@"timeLength*secondLength ===  %f",timeLength*secondLength);
    self.grayBar.backgroundColor = [UIColor whiteColor];
    self.grayBar.layer.cornerRadius = 8;
    [self addSubview:self.grayBar];
    //[self.grayBar release];
    
    self.greenBar = [[UIView alloc]initWithFrame:CGRectMake(40, 15, 0, 10)];
    self.greenBar.backgroundColor = [UIColor greenColor];
    self.greenBar.layer.cornerRadius = 8;
    [self addSubview:self.greenBar];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(timeLength*secondLength + 40 , 5, 40, 30)];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.text = [NSString stringWithFormat:@"%.0f",timeLength];
    [self addSubview:self.timeLabel];
   // [self.timeLabel release];
    
    self.time = timeLength;

}
//开启timer
- (void)playAudio:(UIButton *)sender
{
    [playBtn setBackgroundImage:[UIImage imageNamed:@"91"] forState:UIControlStateNormal];
    if (self.isOver) {
        NSLog(@"isover is %@",self.isOver?@"YES":@"NO");
        //播完了，重新播
        self.timer = [NSTimer scheduledTimerWithTimeInterval:Interval target:self selector:@selector(audioProcess) userInfo:nil repeats:YES];
        self.duration = 0.0;
        CGRect frame = self.greenBar.frame;
        frame.size.width=0;
        [self.greenBar setFrame:frame];
        //播放音频的代理
        [_delegate playAudioWithAudioFileTag:sender.tag];
        self.isOver = NO;
        NSLog(@"播放完了");
    }else{
        //没播完
        if (!self.isPlaying) {
            //没在播的时候，点击播放
            if (self.timer) {
                [self.timer setFireDate:[NSDate date]];   //继续
                [_delegate continueAudioPlay];
                NSLog(@"继续播放");
            }else{
                self.timer = [NSTimer scheduledTimerWithTimeInterval:Interval target:self selector:@selector(audioProcess) userInfo:nil repeats:YES];
                self.duration = 0.0;
                NSLog(@"没有播放完，但是去播放另一个");
                //播放音频的代理
                [_delegate playAudioWithAudioFileTag:sender.tag];
            }
        }else{
            //点击暂停
            [self.timer setFireDate:[NSDate distantFuture]];  //暂停
            [playBtn setBackgroundImage:[UIImage imageNamed:@"97"] forState:UIControlStateNormal];
            [_delegate pauseAudioPlay];
        }
        self.isPlaying = !self.isPlaying;
        NSLog(@"bu xiang tong ");
    }
}
// 绿条frame
- (void)audioProcess
{
    CGRect frame = self.greenBar.frame;
    //每一帧绿条宽度的变化
    //超过屏幕范围
    if(self.time>12)
    {
                
    frame.size.width+=(180/self.time) * Interval;
    }
    else
    {
    frame.size.width+=secondLength * Interval;
    }
    NSLog(@"audioProcess frame.size.width ===  %f  Interval ===  %f",frame.size.width,Interval);
    [self.greenBar setFrame:frame];
    //记录播放的总时间
    self.duration+=Interval;
    NSLog(@"总的播放时间是  %f",self.duration);
    //如果播放时间等于音频的时长，则停止
    if (self.duration>=self.time) {
        //停止timer
        [self.timer invalidate];
        self.timer = nil;
        self.isOver = YES;
        [self refreshAudioPanel];
        [_delegate stopAudioPlay];
    }
}
//根据时间得出语音bar的长度
- (void)setgraybarwithtimelength:(CGFloat)timelength
{
    CGRect frame = self.grayBar.frame;
    //超过屏幕能承受的宽度
    if(timelength>12)
    {
    frame.size.width = 180;
    }
    else
    {
    frame.size.width = secondLength *timelength;
    }
    [self.grayBar setFrame:frame];
    
    CGRect frameLabel = self.timeLabel.frame;
   // frameLabel.origin.x =secondLength *timelength + 40;
    frameLabel.origin.x =frame.size.width + 40;
    
    [self.timeLabel setFrame:frameLabel];
    self.timeLabel.text = [NSString stringWithFormat:@"%.0f",timelength];
    self.time = timelength;
}
//复原
- (void)refreshAudioPanel
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    CGRect frame = self.greenBar.frame;
    //每一帧绿条宽度的变化
    frame.size.width=0;
    NSLog(@"frame.size.width ===  %f  Interval ===  %f",frame.size.width,Interval);
    [self.greenBar setFrame:frame];
    self.duration = 0;
    [playBtn setBackgroundImage:[UIImage imageNamed:@"97"] forState:UIControlStateNormal];
    self.isPlaying = NO;
}
@end
