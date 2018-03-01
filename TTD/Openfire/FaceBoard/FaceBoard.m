//
//  FaceBoard.m
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#import "FaceBoard.h"

@implementation FaceBoard
@synthesize delegate=_delegate;
- (void)dealloc
{
    
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 216)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
//        if ([[languages objectAtIndex:0] hasPrefix:@"zh"]) {
//            _faceMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"faceMap_ch" ofType:@"plist"]];
//        } else {
            _faceMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"faceMap_en" ofType:@"plist"]];
       // }
       
        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 190)];
        faceView.pagingEnabled = YES;
        faceView.contentSize = CGSizeMake((85/28+1)*320, 190);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        
        for (int i = 1; i<=85; i++) {
            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            //计算每一个表情按钮的坐标和在哪一屏
            faceButton.frame = CGRectMake((((i-1)%28)%7)*44+6+((i-1)/28*320), (((i-1)%28)/7)*44+8, 44, 44);
            
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d",i]] forState:UIControlStateNormal];
            [faceView addSubview:faceButton];
        }
        
        //添加PageControl
        facePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(110, 190, 100, 20)];
        
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = 85/28+1;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        //添加键盘View
        [self addSubview:faceView];
        
      /*  //删除键
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setTitle:@"删除" forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"backFace"] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"backFaceSelect"] forState:UIControlStateSelected];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        back.frame = CGRectMake(270, 185, 38, 27);
        [self addSubview:back];
       */ 
    }
    return self;
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [facePageControl setCurrentPage:faceView.contentOffset.x/320];
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {
    [faceView setContentOffset:CGPointMake(facePageControl.currentPage*320, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(id)sender {
    NSInteger i = ((FaceButton*)sender).buttonIndex;
    
    NSString *str=[_faceMap objectForKey:[NSString stringWithFormat:@"%03ld",i]];
    //判断delegate是否存在，防止程序崩溃
    if(_delegate&&[_delegate respondsToSelector:@selector(selectedFaceBoard:)])
    {
     [_delegate selectedFaceBoard:str];
    }
    
   }



@end
