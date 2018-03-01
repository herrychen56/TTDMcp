//
//  MessageCell.m
//  QQChatDemo
//
//  Created by hellovoidworld on 14/12/8.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import "MessageCell.h"
#import "MessageFrame.h"
#import "UIImage+Extension.h"
//#import "UIImageView+WebCache.h"
#import "XWScanImage.h"
//#import "AFNetworking.h"
#import "NSVoiceConverter.h"

#import "ZNImageV.h"
#include "Photo.h"
#import "NSData+Base64.h"

#import "MyAVAudioPlayer.h"


@interface MessageCell()

// 定义cell内的子控件，用于保存控件，然后进行数据和位置尺寸的计算
/** 发送时间 */
@property(nonatomic, weak) UILabel *timeLabel;

/** 头像 */
@property(nonatomic, weak) UIImageView *iconView;

/** 信息 */
@property(nonatomic, weak) UIButton *textView;

/** 图片消息 */
@property(nonatomic,weak) UIImageView * imgView;
@property(nonatomic,weak) UIButton * imgbtn;

/** 音频消息 */
@property(nonatomic,weak) UIButton *audbuton;
@property(nonatomic,weak)UIImageView * audimgve;
@property(nonatomic,weak)UILabel *audtime;

@property (nonatomic,weak) NSString * avistr;

//消息唯一码
@property (nonatomic,weak) NSString * messageiD;

/**
 发送状态
 */
@property (nonatomic,weak)UIImageView * StateImage;
@property (nonatomic,weak) UIImage * SSImage;

@end

@implementation MessageCell

//- (void)awakeFromNib {
//    // Initialization code
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 构造方法
// 自定义构造方法
+ (instancetype) cellWithTableView:(UITableView *) tableView {
    static NSString *ID = @"message";
    
    // 使用缓存池
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//   AVAudioPlayer * avplayers = [[AVAudioPlayer alloc]init];
    // 创建一个新的cell
    if (nil == cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}
// 重写构造方法，创建cell中的各个子控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopaplay) name:@"stopavplay" object:nil];
    self.messageiD = [[NSString alloc]init];
    // 设置cell的背景色
    self.backgroundColor = BACKGROUD_COLOR;
    
    // 1.发送时间
    UILabel *timeLabel = [[UILabel alloc] init];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLabel setFont:MESSAGE_TIME_FONT];
    [timeLabel setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    //发送状态
    UIImageView * statimg = [[UIImageView alloc]init];
    [self.contentView addSubview:statimg];
    self.StateImage = statimg;
    
    // 2.头像
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    //图片信息
    UIImageView *viewimg =[[UIImageView alloc]init];
   
    self.imgView.hidden=YES;
//    [self.imgbtn addTarget:self action:@selector(scanBigImageClick:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
    [viewimg addGestureRecognizer:tapGestureRecognizer1];
    //设置圆角
    viewimg.layer.cornerRadius = 4;
    [viewimg.layer setMasksToBounds:YES];
    
    
    //让UIImageView和它的父类开启用户交互属性
    [viewimg setUserInteractionEnabled:YES];
    self.imgView  = viewimg;
    UIButton * imgb =[[UIButton alloc]init];
    self.imgbtn = imgb;
    [self.imgbtn addSubview:viewimg];
    [self.contentView addSubview:imgb];
    
    //音频消息
    
    UIImageView *voice = [[UIImageView alloc]init];
    self.audimgve = voice;
    UIButton * audbtn =[[UIButton alloc]init];
    self.audbuton = audbtn;
    self.audimgve.hidden=YES;
    [audbtn addTarget:self action:@selector(playaudio) forControlEvents:UIControlEventTouchUpInside];
    [self.audbuton addSubview:self.audimgve];
    [self.contentView addSubview:self.audbuton];
    
    UILabel *lab=[[UILabel alloc]init];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [lab setFont:MESSAGE_AUDTIME_FONT];
    [lab setTextColor:[UIColor grayColor]];
    self.audtime=lab;
    [self.contentView addSubview:self.audtime];
    
    // 3.信息
    UIButton *textView = [[UIButton alloc] init];
    [textView setTitle:@"" forState:UIControlStateNormal];
    [textView.titleLabel setFont:MESSAGE_TEXT_FONT];
    
    // 3.1 如果是浅色背景，记得设置字体颜色，因为按钮的字体颜色默认是白色
    [textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [textView.titleLabel setNumberOfLines:0]; // 设置自动换行
    // 3.2 调整文字的内边距
    textView.contentEdgeInsets = UIEdgeInsetsMake(TEXT_INSET, TEXT_INSET, TEXT_INSET, TEXT_INSET);
    
    
    [self.contentView addSubview:textView];
    self.textView = textView;

    // 根据类型显示。
    if (_messageFrame.message.modetype == 0)
    {// 文本消息
        NSLog(@"判断为文本消息");
//        self.textView.hidden = NO;
//        self.imgbtn.hidden = YES;
//        self.audbuton.hidden = YES;
        
    }else if (_messageFrame.message.modetype == 1)
    {//图片消息
        NSLog(@"判断为图片信息");
//        self.imgView.hidden=NO;
//        self.textView.hidden = YES;
//        self.audbuton.hidden = YES;
        
    }else if (_messageFrame.message.modetype == 2)
    {//音频消息
        NSLog(@"判读为音频消息");
//        self.audimgve.hidden=NO;
//        self.textView.hidden = YES;
//        self.imgbtn.hidden = YES;
    }
    
   
    
    return self;
}

#pragma mark - 加载数据
// 加载frame，初始化cell中子控件的数据、位置尺寸
- (void)setMessageFrame:(MessageFrame *) messageFrame {
    _messageFrame = messageFrame;
    
    //消息唯一码
    self.messageiD = messageFrame.message.messageId;
    
    // 1.发送时间
   
    if (messageFrame.message.hideTime ==YES) {
         self.timeLabel.text =@"";
    }else{
         self.timeLabel.text = messageFrame.message.time;
    }
    self.timeLabel.frame = messageFrame.timeFrame;
    
    // 2.头像
    NSString *icon = (messageFrame.message.type == MessageTypeMe)? messageFrame.message.myicon:messageFrame.message.outhericon;
    if (icon .length<1) {
        self.iconView.image=[UIImage imageNamed:@"defaultUSerImage"];
    }else{
         self.iconView.image = [Photo string2Image:icon];
    }
    self.iconView.frame = messageFrame.iconFrame;
    self.iconView.layer.cornerRadius = 20;
    self.iconView.layer.masksToBounds = YES;
  
    // 3.信息
    NSLog(@"加载数据为文本消息%@",messageFrame.message.text);
    [self.textView setTitle:messageFrame.message.text forState:UIControlStateNormal];
    self.textView.frame = messageFrame.textFrame;
    //3.1 图片消息
//    [self.imgView sd_setImageWithURL:[NSURL URLWithString:messageFrame.message.imgurl]];
    self.imgView.image =[Photo string2Image:messageFrame.message.imgurl];
    self.imgView.frame=CGRectMake(15, 13, messageFrame.imgFrame.size.width-30, messageFrame.imgFrame.size.height-26);
    self.imgbtn.frame =messageFrame.imgFrame;
   
    
    // 3.1 设置聊天框
    NSString *chatImageNormalName;
    NSString *chatImageHighlightedName;
    if (MessageTypeMe == messageFrame.message.type) {
        chatImageNormalName = @"chat_send_nor.jpg";
        chatImageHighlightedName = @"chat_send_press_pic";
    } else {
        chatImageNormalName = @"chat_receive_nor.jpg";
        chatImageHighlightedName = @"chat_receive_press_pic";
    }
    
    UIImage *chatImageNormal = [UIImage resizableImage:chatImageNormalName];
    UIImage *chatImageHighlighted = [UIImage resizableImage:chatImageHighlightedName];
    
   
    if (messageFrame.message.modetype == MessageTextType) {
     
        [self.textView setBackgroundImage:chatImageNormal forState:UIControlStateNormal];
        [self.textView setBackgroundImage:chatImageHighlighted forState:UIControlStateHighlighted];

        self.textView.frame = messageFrame.textFrame;
        NSLog(@"加载数据为文本消息");
        self.textView.hidden = NO;
        self.audimgve.hidden=YES;
        self.imgView.hidden = YES;
        self.audtime.hidden = YES;
        self.audbuton.hidden= YES;
        
        
          self.StateImage.frame = CGRectMake(messageFrame.textFrame.origin.x - 50, messageFrame.textFrame.origin.y+12, 30, 30);
        //image 等待图片
        if (messageFrame.message.state == 1) {
//            //发送中动画
//            self.StateImage.animationImages = [NSArray arrayWithObjects:
//                                               [UIImage imageNamed:@"DD1"],
//                                               [UIImage imageNamed:@"DD2"],
//                                               [UIImage imageNamed:@"DD3"],
//                                               [UIImage imageNamed:@"DD4"],nil];
//            [self.StateImage setAnimationDuration:1];
//            [self.StateImage startAnimating];
        }else if (messageFrame.message.state ==2){
//            self.StateImage.image=[UIImage imageNamed:@"jinggao.png"];
//            [self.StateImage setUserInteractionEnabled:YES];
//            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//            [self.StateImage addGestureRecognizer:singleTap];
        }
        
        
        
    }else if (messageFrame.message.modetype == MessagePicvType) {
        NSLog(@"加载消息为图片消息");
        self.audimgve.hidden=YES;
        self.imgView.hidden = NO;
        self.textView.hidden = YES;
        self.audtime.hidden = YES;
        self.audbuton.hidden= YES;
        //取消图片边框
//        [self.imgbtn setBackgroundImage:chatImageNormal forState:UIControlStateNormal];
//        [self.imgbtn setBackgroundImage:chatImageHighlighted forState:UIControlStateHighlighted];
        
        self.imgbtn.frame = messageFrame.imgFrame;
        
        //image 等待图片
        self.StateImage.frame = CGRectMake(messageFrame.textFrame.origin.x - 50, messageFrame.textFrame.origin.y+12, 30, 30);
        if (messageFrame.message.state == 1) {
            //发送中动画
//            self.StateImage.animationImages = [NSArray arrayWithObjects:
//                                               [UIImage imageNamed:@"DD1"],
//                                               [UIImage imageNamed:@"DD2"],
//                                               [UIImage imageNamed:@"DD3"],
//                                               [UIImage imageNamed:@"DD4"],nil];
//            [self.StateImage setAnimationDuration:1];
//            [self.StateImage startAnimating];
        }else if (messageFrame.message.state ==2){
//            self.StateImage.image=[UIImage imageNamed:@"jinggao.png"];
//            [self.StateImage setUserInteractionEnabled:YES];
//            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//            [self.StateImage addGestureRecognizer:singleTap];
        }
        
        

    }else if (messageFrame.message.modetype ==MessageAviTyer) {
        NSLog(@"加载消息为语音消息");
        
        self.audbuton.hidden=NO;
        self.audimgve.hidden=NO;
        self.audtime.hidden = NO;
        self.imgView.hidden = YES;
        self.textView.hidden = YES;
        
        if (MessageTypeMe == messageFrame.message.type) {
            chatImageNormalName = @"chat_send_nor.jpg";
            chatImageHighlightedName = @"chat_send_press_pic.jpg";
            //3.2音频消息
            self.audimgve.frame=CGRectMake(23, 20, 130, 20);
            //动画未开始前的图片
            self.audimgve.image = [UIImage imageNamed:@"tmyp1"];
            //进行动画效果的3张图片（按照播放顺序放置）
            self.audimgve.animationImages = [NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"tmyp2"],
                                             [UIImage imageNamed:@"tmyp3"],
                                             [UIImage imageNamed:@"tmyp4"],
                                             [UIImage imageNamed:@"tmyp5"],nil];
            //3.3语音消息
            self.audbuton.frame = messageFrame.aviFrame;
            self.audtime.frame = CGRectMake(messageFrame.aviFrame.origin.x-20, messageFrame.aviFrame.origin.y+15, 25, 30);
//            self.audtime.backgroundColor=[UIColor redColor];
            [self.audtime setText:messageFrame.message.audtime];
            NSLog(@"语音长度==%@",self.audtime);
            
        } else {
            chatImageNormalName = @"chat_receive_nor.jpg";
            chatImageHighlightedName = @"chat_receive_press_pic.jpg";
            
            self.audimgve.frame=CGRectMake(23, 20, 130, 20);
            //动画未开始前的图片
            self.audimgve.image = [UIImage imageNamed:@"tmyp1"];
            //进行动画效果的3张图片（按照播放顺序放置）
            self.audimgve.animationImages = [NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"tmyp2"],
                                             [UIImage imageNamed:@"tmyp3"],
                                             [UIImage imageNamed:@"tmyp4"],
                                             [UIImage imageNamed:@"tmyp5"],nil];
            //3.3语音消息
            self.audbuton.frame = messageFrame.aviFrame;
            self.audtime.frame = CGRectMake(messageFrame.aviFrame.size.width+55, messageFrame.aviFrame.origin.y+15, 25, 30);
//            self.audtime.backgroundColor=[UIColor redColor];
            [self.audtime setText:messageFrame.message.audtime];
        }
        //设置动画间隔
        self.audimgve.animationDuration = 1;
        self.audimgve.animationRepeatCount = 0;
        self.audimgve.userInteractionEnabled = NO;
        self.audimgve.backgroundColor = [UIColor clearColor];
        
        [self.audbuton setBackgroundImage:chatImageNormal forState:UIControlStateNormal];
        [self.audbuton setBackgroundImage:chatImageHighlighted forState:UIControlStateHighlighted];
        
        self.audbuton.frame = messageFrame.aviFrame;

        //image 等待图片
        self.StateImage.frame = CGRectMake(messageFrame.textFrame.origin.x - 50, messageFrame.textFrame.origin.y+12, 30, 30);
        if (messageFrame.message.state == 1) {
            //发送中动画
//            self.StateImage.animationImages = [NSArray arrayWithObjects:
//                                               [UIImage imageNamed:@"DD1"],
//                                               [UIImage imageNamed:@"DD2"],
//                                               [UIImage imageNamed:@"DD3"],
//                                               [UIImage imageNamed:@"DD4"],nil];
//            [self.StateImage setAnimationDuration:1];
//            [self.StateImage startAnimating];
        }else if (messageFrame.message.state ==2){
//            self.StateImage.image=[UIImage imageNamed:@"jinggao.png"];
//            [self.StateImage setUserInteractionEnabled:YES];
//            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//            [self.StateImage addGestureRecognizer:singleTap];
        }
    }
    
    
}
#pragma mark - 浏览大图点击事件

-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    NSLog(@"点击图片");
    UIImageView *clickedImageView = (UIImageView *)tap.view;
//    [XWScanImage scanBigImageWithImageView:clickedImageView];
 
//    [_delegate Clickimage:clickedImageView.image];
    [_delegate CllickImageIndex:_messageFrame.message.messageId];
}
-(void)handleSingleTap:(UITapGestureRecognizer *)atp {
    
    
    
    [_delegate errorChageYes:_messageFrame.message];
}

#pragma mark - 处理近距离监听触发事件

-(void)sensorStateChange:(NSNotificationCenter *)notification;

{
    
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    
    if ([[UIDevice currentDevice] proximityState] == YES)//黑屏
    {
        NSLog(@"听筒播放");
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }
    
    else//没黑屏幕
        
    {
        
        NSLog(@"扬声器播放");
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        if (![_player isPlaying]) {//没有播放了，也没有在黑屏状态下，就可以把距离传感器关了
            
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
            
        }
        
    }
    
}
#pragma mark -播放声音
-(void)playaudio
{
    NSLog(@"点击了播放按钮=%@", self.audtime);

    [[UIDevice currentDevice]setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
        NSLog(@"有距离传感器");
        [self audioplay:_messageFrame.message.audio];
        
    }else{
        NSLog(@"没有有距离传感器");

    }
    
    //删除近距离事件监听
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
   
}

-(void)audioplay:(NSString *)filename {
    
//    NSLog(@"播放的文件===%@",filename);
    NSData * avidata=[[NSData alloc]init];
   avidata = [NSData dataWithBase64EncodedString:filename];

    [[MyAVAudioPlayer sharedAVAudioPlayer] playMusicWithMusicName:avidata];

    [self.audimgve startAnimating];
//    [_player play];
    NSTimeInterval playtime =[[MyAVAudioPlayer sharedAVAudioPlayer] getDuration];
    NSLog(@"播放时长==%f",playtime);

    [self performSelector:@selector(methodName) withObject:self afterDelay:playtime];
    
}

-(void)methodName
{
    [[MyAVAudioPlayer sharedAVAudioPlayer].player stop];
    NSLog(@"播放完成");
     [self.audimgve stopAnimating];

}

-(void)avplay {
     NSLog(@"收到通知，关闭播放！！");
    [_player stop];
    _player.currentTime = 0;
    
    [self.audimgve stopAnimating];

}


@end
