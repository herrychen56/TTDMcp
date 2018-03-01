//
//  ChTabBarItem.m
//  WeiBo
//
//  Created by ch on 13-6-5.
//  Copyright (c) 2013年 ch. All rights reserved.
//

#import "ChTabBarItem.h"

@implementation ChTabBarItem

#pragma mark 根据标题、普通图片、高亮图片初始化按钮所用信息的类方法
+(id)tabBarItemWithTitle:(NSString*)title normalImage:(NSString*)normalImage highlightedImage:(NSString*)highlightedImage{
    ChTabBarItem *item = [[[ChTabBarItem alloc] init] autorelease];
    item.title = title;
    item.normalImage = normalImage;
    item.highlightedImage = highlightedImage;
    return item;
}

-(void)dealloc{
    [_title release];
    [_normalImage release];
    [_highlightedImage release];
    [super dealloc];
}
@end
