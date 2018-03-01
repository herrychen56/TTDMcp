//
//  KKChatDelegate.h
//  BaseProject
//
//  Created by Huan Cho on 13-8-3.
//  Copyright (c) 2013年 ch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KKChatDelegate <NSObject>

-(void)newBuddyOnline:(NSString *)buddyName;
-(void)buddyWentOffline:(NSString *)buddyName;
-(void)rosterLiset:(NSMutableArray *)buddyName;
-(void)messageContentNotice;
-(void)reloadDataList;
//-(NSString *)iconImageName;
@end
