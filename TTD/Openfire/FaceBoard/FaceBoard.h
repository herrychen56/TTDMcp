//
//  FaceBoard.h
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#import <UIKit/UIKit.h>
#import "FaceButton.h"
#import "GrayPageControl.h"
@protocol faceBoardDelegate <NSObject>

-(void)selectedFaceBoard:(NSString*)str;

@end
@interface FaceBoard : UIView<UIScrollViewDelegate>{
    UIScrollView *faceView;
    GrayPageControl *facePageControl;
    NSDictionary *_faceMap;
    @private id<faceBoardDelegate>_delegate;
}

@property (nonatomic)id<faceBoardDelegate>delegate;
@end
