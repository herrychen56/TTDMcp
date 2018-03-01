//
//  AudioPanel.h
//  AudioBarDemo
//
//  Created by LIKUN on 13-11-8.
//  Copyright (c) 2013年 LIKUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

#define secondLength 15     //对应时长  ，每一秒时长的像素（width）13s则宽度为 13*secondLength
#define Interval 1/30.0         //timer的时间间隔

@protocol AudioPanelDelegate <NSObject>

- (void)playAudioWithAudioFileTag:(int)fileTag;                                                    //播放音频的代理
- (void)pauseAudioPlay;                                                                //暂停音频的代理
- (void)continueAudioPlay;                                                            //继续播放的代理
- (void)stopAudioPlay;                                                                  //停止播放

@end


@interface AudioPanel : UIView
{
    @private
    id<AudioPanelDelegate> _delegate;
}
@property (nonatomic)id<AudioPanelDelegate> delegate;
@property (nonatomic, retain)UIView *greenBar;
@property (nonatomic, retain)UIView *grayBar;
@property (nonatomic, retain)UILabel *timeLabel;
@property (nonatomic, assign)float time;                                       //时长
@property (nonatomic, retain)NSTimer *timer;
@property (nonatomic, assign)BOOL isPlaying;                            //是否在播放的bool    YES:在播放   NO:没播放
@property (nonatomic, assign)float duration;                                //播放的时间
@property (nonatomic, assign)BOOL isOver;                               //是否播放完了            YES:播完了   NO:没播完
@property (nonatomic, retain)UIButton *playBtn;

- (id)initWithFrame:(CGRect)frame timeLength:(CGFloat)len playBtnTag:(int)tag;
- (void)refreshAudioPanel;
- (void)setPlayBtnTag:(NSInteger)tag;
- (void)setgraybarwithtimelength:(CGFloat)timelength;
@end
