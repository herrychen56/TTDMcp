//
//  ZNImageV.h
//  TTD
//
//  Created by quakoo on 2017/12/14.
//  Copyright © 2017年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNImageV : UIView<UIScrollViewDelegate>
{
    UIImageView * _imageView;
    UIScrollView * _contenView;
    UIButton * _collectionButton;
}

-(void)showIamge;

-(void)hideImage;

-(void)setImage:(UIImage *)image;

+(void)viewWithImage:(UIImage *)image;


@end
