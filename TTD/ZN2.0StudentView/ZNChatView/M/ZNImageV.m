//
//  ZNImageV.m
//  TTD
//
//  Created by quakoo on 2017/12/14.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "ZNImageV.h"
#import "AppDelegate.h"



@implementation ZNImageV
-(void)dealloc {
    _contenView = nil;
    _imageView = nil;
//    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame {
    _contenView = nil;
    _imageView = nil;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        _contenView = [[UIScrollView alloc]initWithFrame:frame];
        _contenView.backgroundColor = [UIColor whiteColor];
        _contenView.delegate = self;
        _contenView.bouncesZoom = YES;
        _contenView.minimumZoomScale = 0.5;
        _contenView.maximumZoomScale = 5.0;
        _contenView.showsHorizontalScrollIndicator = NO;
        _contenView.showsVerticalScrollIndicator = NO;
        [self addSubview:_contenView];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
        [_contenView addSubview:_imageView];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.enabled = YES;
        [tapGesture delaysTouchesBegan];
        [tapGesture cancelsTouchesInView];
        [_imageView addGestureRecognizer:tapGesture];
        
        _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionButton.frame = CGRectMake(frame.origin.x + frame.size.width -70,frame.origin.y+frame.size.height-50, 60, 40);
        [_collectionButton setTitle:@"Save" forState:UIControlStateNormal];
        [self addSubview:_collectionButton];
        [_collectionButton addTarget:self action:@selector(didClickCollectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _collectionButton.layer.masksToBounds = YES;
        _collectionButton.layer.cornerRadius =5.0;
        _collectionButton.layer.borderWidth =1.0;
        _collectionButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        [_collectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return self;
}

-(void)didClickCollectionButtonAction:(UIButton *)button {
    UIImageWriteToSavedPhotosAlbum(_imageView.image, nil, nil, nil);
    UIImageWriteToSavedPhotosAlbum(_imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error !=NULL) {
        NSLog(@"保存失败");
    }else {
        NSLog(@"保存成功");
    }
}

-(void)setImage:(UIImage *)image {
    CGSize size = [self preferredSize:image];
    _imageView.frame = CGRectMake(0, 0, size.width, size.height);
    _contenView.contentSize = size;
    _imageView.center = self.center;
    _imageView.image =  image;
}

-(CGSize)preferredSize:(UIImage *)image {
    CGFloat width =0.0,height =0.0;
    CGFloat rat0 = image.size.width/image.size.height;
    CGFloat rat1 = self.frame.size.width/self.frame.size.height;
    if(rat0>rat1){
        height = self.frame.size.height;
        width = height *rat0;
    }
    return CGSizeMake(width, height);
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat x = scrollView.center.x , y=scrollView.center.y;
    x = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2:x;
    y = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2:y;
    _imageView.center =CGPointMake(x, y);
}

-(void)showIamge {
    _contenView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    _contenView.alpha = 0;
    _collectionButton.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        _contenView.alpha =1.0;
        _collectionButton.alpha = 1.0;
        _contenView.transform = CGAffineTransformMakeScale(1, 1);
        _contenView.center = self.center;
    }];
}

-(void)hideImage {
    [UIView animateWithDuration:0.25 animations:^{
        _contenView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        _contenView.alpha =0 ;
        _collectionButton.alpha =0;
    } completion:^(BOOL finished) {
        if (finished) {
            _contenView.alpha = 1;
            [_contenView removeFromSuperview];
            [_imageView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

+(void)viewWithImage:(UIImage *)image {
    AppDelegate * delegate =((AppDelegate *)[UIApplication sharedApplication].delegate);
    UIWindow * window = delegate.window;
    ZNImageV * imagevv = [[ZNImageV alloc]initWithFrame:window.frame];
    [imagevv setImage:image];
    [window addSubview:imagevv];
    [imagevv showIamge];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
