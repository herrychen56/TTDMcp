//
//  NSObject+LCVoice.h
//  TTD
//  Created by andy on 14-2-13.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCVoice : NSObject

@property(nonatomic,retain) NSString * recordPath;
@property(nonatomic) CGFloat recordTime;

-(void) startRecordWithPath:(NSString *)path;
-(void) stopRecordWithCompletionBlock:(void (^)())completion;
-(void) cancelled;

@end