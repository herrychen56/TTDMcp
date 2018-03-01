//
//  ChatSelectionView.m
//  TTD
//
//  Created by andy on 13-12-25.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "ChatSelectionView.h"
#define CHAT_BUTTON_SIZE 70
#define INSETS 10
@implementation ChatSelectionView
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
        
    }
    return self;
}
-(void)pickPhoto
{
    [_delegate pickPhoto];
}
-(void)dealloc
{
    [super dealloc];
    
}
@end
