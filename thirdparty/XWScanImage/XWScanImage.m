//
//  XWScanImage.m
//  XWScanImageDemo
//
//  Created by 邱学伟 on 16/4/13.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "XWScanImage.h"
#import "MessageCell.h"

@implementation XWScanImage

//原始尺寸
static CGRect oldframe;

/**
 *  浏览大图
 *
 *  @param currentImageview 图片所在的imageView
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview{
    //当前imageview的图片
    UIImage *image = currentImageview.image;
    //当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    oldframe = [currentImageview convertRect:currentImageview.bounds toView:window];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:99/255.0 alpha:0.6]];
    //此时视图不会显示
    [backgroundView setAlpha:0];
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    [imageView setImage:image];
    [imageView setTag:1024];
    [backgroundView addSubview:imageView];
    //将原始视图添加到背景视图中
    [window addSubview:backgroundView];
    
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    

    //动画放大所展示的ImageView

    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
        //添加常按手势，用于保存相册
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        
        [backgroundView addGestureRecognizer:longPressGr];
        
        //缩放手势
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        [backgroundView addGestureRecognizer:pinchGestureRecognizer];
    
        
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
+(void)hideImageView:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
    //原始imageview
    UIImageView *imageView = [tap.view viewWithTag:1024];
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
       //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}

//缩放手势
+(void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    UIView *view = pinchGestureRecognizer.view;
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
        
    {
        
    view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
        
    }
}

/**
 *  长按保存到相册
 *
 *  param tgesture点击事件
 */
+(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
   
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"长按手势。。。。。。");
//        UIView *backgroundView = gesture.view;
        //原始imageview
        UIImageView *imageView = [gesture.view viewWithTag:1024];
        
        [LEEAlert actionsheet].config
        .LeeAction(@"Save to photos", ^{
            dispatch_async(dispatch_get_main_queue(), ^{
//                UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
                UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            });
           
        
        })
//        .LeeDestructiveAction(@"Save to photos", ^{
//
//            // 点击事件Block
//        })
        .LeeCancelAction(@"Cancel", ^{
            
            // 点击事件Block
        })
        .LeeShow();
    }
}


+(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error !=NULL) {
        NSLog(@"保存失败");
        [self showMessage:@"Save failed"];
        
    }else {
        NSLog(@"保存成功");
         [self showMessage:@"Save success"];
    }
}



+(void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - LabelSize.width - 20)/2, [UIScreen mainScreen].bounds.size.height - 100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:3 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}




#pragma mark - UIAlertViewDelegate
//+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//
//    NSLog(@"点击的是几个按钮==%ld",(long)buttonIndex);
//    if (buttonIndex ==1) {
//        
//    }
////    self.type =[NSString stringWithFormat:@"%ld",(long)buttonIndex];
//    
//    
//    
//}

@end
