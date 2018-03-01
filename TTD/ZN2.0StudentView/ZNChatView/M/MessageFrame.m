//
//  MessageFrame.m
//  QQChatDemo
//
//  Created by hellovoidworld on 14/12/8.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import "MessageFrame.h"
#import "NSString+Extension.h"

@implementation MessageFrame

/** 设置message，计算位置尺寸 */
- (void)setMessage:(Message *)message {
    _message = message;

    // 间隙
    CGFloat padding = 10;
    
    // 1.发送时间
    if (NO == message.hideTime) {
        CGFloat timeWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat timeHeight = 40;
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        _timeFrame = CGRectMake(timeX, timeY, timeWidth, timeHeight);
    }
    
    // 2.头像
    CGFloat iconWidth = 40;
    CGFloat iconHeight = 40;
    
    // 2.1 根据信息的发送方调整头像位置
    CGFloat iconX;
    if (MessageTypeMe == message.type) {
        // 我方，放在右边
        iconX = [UIScreen mainScreen].bounds.size.width - padding - iconWidth;
    } else {
        // 对方，放在左边
        iconX = padding;
    }
    
    CGFloat iconY = CGRectGetMaxY(_timeFrame) + padding;
    _iconFrame = CGRectMake(iconX, iconY, iconWidth, iconHeight);
    
    
    if (message.modetype == MessageTextType) {
        // 3.信息，尺寸可变
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        // 3.1 设置文本最大尺寸
        CGSize textMaxSize = CGSizeMake(screenWidth - iconWidth - padding * 10, MAXFLOAT);
        // 3.2 计算文本真实尺寸
        CGSize textRealSize = [message.text sizeWithFont:MESSAGE_TEXT_FONT maxSize:textMaxSize];
        
        // 3.3 按钮尺寸
        CGSize btnSize = CGSizeMake(textRealSize.width + TEXT_INSET*2, textRealSize.height + TEXT_INSET*2);
        
        // 3.4 调整信息的位置
        CGFloat textX;
        if (MessageTypeMe == message.type) {
            // 我方，放在靠右
            textX = CGRectGetMinX(_iconFrame) - btnSize.width - padding;
        } else {
            // 对方，放在靠左
            textX = CGRectGetMaxX(_iconFrame) + padding;
        }
        
        CGFloat textY = iconY;
        _textFrame = CGRectMake(textX, textY, btnSize.width, btnSize.height);
        
        // 4.cell的高度
        CGFloat iconMaxY = CGRectGetMaxY(_iconFrame);
        CGFloat textMaxY = CGRectGetMaxY(_textFrame);
        _cellHeight = MAX(iconMaxY, textMaxY) + padding;

    }else if (message.modetype ==MessagePicvType) {

        CGSize imgRealSize = CGSizeMake(100, 160);
        
        // 3.3 按钮尺寸
        CGSize btnSize = CGSizeMake(imgRealSize.width + TEXT_INSET*2, imgRealSize.height + TEXT_INSET*2);
        
        // 3.4 调整信息的位置
        CGFloat imgX;
        if (MessageTypeMe == message.type) {
            // 我方，放在靠右
            imgX = CGRectGetMinX(_iconFrame) - btnSize.width - padding;
        } else {
            // 对方，放在靠左
            imgX = CGRectGetMaxX(_iconFrame) + padding;
        }
        
        CGFloat imgY = iconY;
        _imgFrame = CGRectMake(imgX, imgY, btnSize.width, btnSize.height);
        
        // 4.cell的高度
        CGFloat iconMaxY = CGRectGetMaxY(_iconFrame);
        CGFloat imgMaxY = CGRectGetMaxY(_imgFrame);
        _cellHeight = MAX(iconMaxY, imgMaxY) + padding;
    
    }else if (message.modetype ==MessageAviTyer) {
        NSLog(@" 语音长度===%@",message.audtime);
        
//        // 3.信息，尺寸可变
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//        // 3.1 设置文本最大尺寸
//        CGSize textMaxSize = CGSizeMake(screenWidth - iconWidth - padding * 10, MAXFLOAT);
        NSInteger w=[message.audtime integerValue];
        CGSize imgRealSize = CGSizeMake(130, 20);
        
        // 3.3 按钮尺寸
        CGSize btnSize = CGSizeMake(imgRealSize.width + TEXT_INSET*2, imgRealSize.height + TEXT_INSET*2);
        
        // 3.4 调整信息的位置
        CGFloat imgX;
        if (MessageTypeMe == message.type) {
            // 我方，放在靠右
            imgX = CGRectGetMinX(_iconFrame) - btnSize.width - padding;
        } else {
            // 对方，放在靠左
            imgX = CGRectGetMaxX(_iconFrame) + padding;
        }
        
        CGFloat imgY = iconY;
        _aviFrame = CGRectMake(imgX, imgY, btnSize.width, btnSize.height);
        
        // 4.cell的高度
        CGFloat iconMaxY = CGRectGetMaxY(_iconFrame);
        CGFloat imgMaxY = CGRectGetMaxY(_imgFrame);
        _cellHeight = MAX(iconMaxY, imgMaxY) + padding+10;

        
    }
    
}


@end
