//
//  ChatSelectionView.h
//  TTD
//
//  Created by herry on 13-12-25.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol WCShareMoreDelegate <NSObject>

@optional
-(void)pickPhoto;
-(UIImage *)imageDidFinishPicking;
-(UIImage *)cameraDidFinishPicking;
-(CLLocation *)locationDidFinishPicking;

@end

@interface ChatSelectionView : UIView
@property (nonatomic,assign) id<WCShareMoreDelegate> delegate;
@property (nonatomic,retain) UIButton *photoButton;
@property (nonatomic,retain) UIButton *cameraButton;
@property (nonatomic,retain) UIButton *locationButton;
@property (nonatomic,retain) UIButton *vcardButton;
@property (nonatomic,retain) UIButton *voipChatButton;
@property (nonatomic,retain) UIButton *videoChatButton;
@property (nonatomic,retain) UIButton *voidInputButton;
@property (nonatomic,retain) UIButton *moreButton;
@end
