//
//  WCChatSelectionView.m
//  微信
//
//  Created by Reese on 13-8-22.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "WCChatSelectionView.h"
#define CHAT_BUTTON_SIZE 70
#define INSETS 10


@implementation WCChatSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //写死面板的高度
        [self setBackgroundColor:[UIColor whiteColor]];
        
        
        // Initialization code
        _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setFrame:CGRectMake(INSETS, INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_photoButton setImage:[UIImage imageNamed:@"sharemore_pic"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(pickPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_photoButton];
        _lblPhoto=[[UILabel alloc]initWithFrame:CGRectMake(INSETS+15, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE-10, 30)];
        _lblPhoto.font=[UIFont systemFontOfSize:12];
        _lblPhoto.text=@"Photo";
        [self addSubview:_lblPhoto];
        _cameraButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setFrame:CGRectMake(90, INSETS+10, CHAT_BUTTON_SIZE-20 , CHAT_BUTTON_SIZE-20)];
        [_cameraButton setImage:[UIImage imageNamed:@"Comara"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(comaraPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cameraButton];
        _lblComara=[[UILabel alloc]initWithFrame:CGRectMake(90+5, INSETS+CHAT_BUTTON_SIZE-10, CHAT_BUTTON_SIZE-10, 30)];
        _lblComara.font=[UIFont systemFontOfSize:12];
        _lblComara.text=@"Camera";
        [self addSubview:_lblComara];

    }
    return self;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)pickPhoto
{
    [_delegate pickPhoto];
}
-(void)comaraPhoto
{
    [_delegate comaraPhoto];
}
//-(UIImage *)imageDidFinishPicking
//{
//    
//}
//-(UIImage *)cameraDidFinishPicking
//{
//    
//}
//-(CLLocation *)locationDidFinishPicking
//{
//    
//}
-(void)dealloc
{
    //[super dealloc];
    
}

@end
