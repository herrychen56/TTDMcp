//
//  ZNLPImgViewController.m
//  TTD
//
//  Created by quakoo on 2017/12/28.
//  Copyright © 2017年 totem. All rights reserved.
//

#import "ZNLPImgViewController.h"
#import "Photo.h"
#import "FMDatabase.h"
@interface ZNLPImgViewController ()<UIScrollViewDelegate>
{
        UIImageView * imageView1;
        UIImageView * imageView2;
        UIImageView * imageView3;
        UIImage * image1;//contents
        CGFloat y,width,height;
        UIImage * image2;
        CGFloat ys,widths,heights;
        UIImage * image3;
        CGFloat yd,widthd,heightd;
        NSNumber * setindext;
    //
    NSNumber * upindext;
    NSNumber * downindex;
    
    //坐标判断
    CGFloat contentOffsetX;
    
    CGFloat statrContentOffsetX;
    
    CGFloat endContentOffsetX;
    
    
}
@end

@implementation ZNLPImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.indextstr);
    // Do any additional setup after loading the view, typically from a nib.
    
    //点击手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    //缩放
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    

    
    UIScrollView * scview = [[UIScrollView alloc] init];
      [scview addGestureRecognizer:tapGestureRecognizer];
    setindext = [[NSNumber alloc]init];
    upindext = [[NSNumber alloc]init];
    downindex = [[NSNumber alloc]init];
    scview.pagingEnabled = YES;
    NSString * nowimg =[self nowImageIndext:self.indextstr];
    NSString * upimg = [self upimageIndext:self.indextstr];
    NSString * down = [self downimageIndext:self.indextstr];
  
    
    
    image1 = [Photo string2Image:upimg];
    image2 = [Photo string2Image:nowimg];
    image3 = [Photo string2Image:down];
    
    if (image1 == nil) {
        
        image1 = [UIImage imageNamed:@"lastone"];
        
    }
    if (image3 == nil) {
        image3 = [UIImage imageNamed:@"lastone"];
        
    }
   
    
   
    
    imageView1 = [[UIImageView alloc] initWithImage:image1];
    imageView2 = [[UIImageView alloc] initWithImage:image2];
    imageView3 = [[UIImageView alloc] initWithImage:image3];
    imageView3.userInteractionEnabled=YES;;
    imageView2.userInteractionEnabled=YES;;
    imageView1.userInteractionEnabled=YES;;
    imageView3.tag=1013;
    imageView2.tag=1012;
    imageView1.tag=1011;
    
    //长按手势
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [imageView1 addGestureRecognizer:longPressGr];
    UILongPressGestureRecognizer * longPressGr2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo2:)];
    longPressGr2.minimumPressDuration = 1.0;
    [imageView2 addGestureRecognizer:longPressGr2];
    UILongPressGestureRecognizer * longPressGr3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo3:)];
    longPressGr3.minimumPressDuration = 1.0;
    [imageView3 addGestureRecognizer:longPressGr3];
    
    CGFloat y,width,height;
    y = ([UIScreen mainScreen].bounds.size.height - image1.size.height * [UIScreen mainScreen].bounds.size.width / image1.size.width) * 0.5;
    width = [UIScreen mainScreen].bounds.size.width;
    height = image1.size.height * [UIScreen mainScreen].bounds.size.width / image1.size.width;
    imageView1.frame = CGRectMake(0, y, width, height);
    CGFloat ys,widths,heights;
    ys = ([UIScreen mainScreen].bounds.size.height - image2.size.height * [UIScreen mainScreen].bounds.size.width / image2.size.width) * 0.5;
    widths = [UIScreen mainScreen].bounds.size.width;
    heights = image2.size.height * [UIScreen mainScreen].bounds.size.width / image2.size.width;
    imageView2.frame = CGRectMake(SCREEN_WIDTH, ys, widths, heights);
    CGFloat yd,widthd,heightd;
    yd = ([UIScreen mainScreen].bounds.size.height - image3.size.height * [UIScreen mainScreen].bounds.size.width / image3.size.width) * 0.5;
    widthd = [UIScreen mainScreen].bounds.size.width;
    heightd = image3.size.height * [UIScreen mainScreen].bounds.size.width / image3.size.width;
    
    imageView3.frame = CGRectMake(SCREEN_WIDTH*2, yd, widthd, heightd);
    scview.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_WIDTH);
    scview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    
    [scview addSubview:imageView1];
    [scview addSubview:imageView2];
    [scview addSubview:imageView3];
    [self.view addSubview:scview];
    scview.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    scview.delegate = self;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   
   
     endContentOffsetX = scrollView.contentOffset.x;
    if(endContentOffsetX < statrContentOffsetX && statrContentOffsetX < contentOffsetX)
    {
        if (upindext == nil) {
            upindext =self.indextstr;
            
        }
        [self changeImage:upindext];
       
         NSLog(@"➡️======%@",upindext);
        int x = imageView1.frame.origin.x + SCREEN_WIDTH;
        if(x>=SCREEN_WIDTH*3){ x = 0;
        imageView1.frame = CGRectMake(x, 0, imageView1.bounds.size.width, imageView1.bounds.size.height);
        x = x+SCREEN_WIDTH;
        }
        if(x>=SCREEN_WIDTH*3){ x = 0;
        imageView2.frame = CGRectMake(x, 0, imageView1.bounds.size.width, imageView1.bounds.size.height);
            x = x+SCREEN_WIDTH;
        }
        if(x>=SCREEN_WIDTH*3){ x = 0;
        imageView3.frame = CGRectMake(x, 0, imageView1.bounds.size.width, imageView1.bounds.size.height);
        }
    }
    if (endContentOffsetX > statrContentOffsetX && statrContentOffsetX > contentOffsetX) {//向左划
        if (downindex ==nil) {
            downindex =  self.indextstr;
            
        }
        [self changeImage:downindex];
        NSLog(@"左划======%@",downindex);
        
        
        int x = imageView1.frame.origin.x + SCREEN_WIDTH;
        if(x>=SCREEN_WIDTH*3){ x = 0;
            imageView1.frame = CGRectMake(x, 0, imageView1.bounds.size.width, imageView1.bounds.size.height);
            x = x+SCREEN_WIDTH;
        }
        if(x>=SCREEN_WIDTH*3){ x = 0;
            imageView2.frame = CGRectMake(x, 0, imageView1.bounds.size.width, imageView1.bounds.size.height);
            x = x+SCREEN_WIDTH;
        }
        if(x>=SCREEN_WIDTH*3){ x = 0;
            imageView3.frame = CGRectMake(x, 0, imageView1.bounds.size.width, imageView1.bounds.size.height);
        }
    }
    scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
}


#pragma mark scroller
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     contentOffsetX = scrollView.contentOffset.x;
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    statrContentOffsetX = scrollView.contentOffset.x;
    
}


-(NSString *)nowImageIndext:(NSNumber *)ind {
    
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    
    NSString *queryString=[NSString stringWithFormat:@"select * from `wcMessage` where messageId = ? "];//当前
    
    if (![db open]) {
        NSLog(@"数据打开失败");
        
    }
    FMResultSet * rs =[db executeQuery:queryString,ind];
    NSString * imgstr=[[NSString alloc]init];
    while ([rs next]) {
        imgstr = [rs objectForColumnName:@"messageContent"];
        setindext = [rs objectForColumnName:@"messageId"];
//        NSLog(@"cell rs ==%@",imgstr);
    }
    
    return imgstr;
}

-(void)changeImage:(NSNumber *)num {
    NSString * nowimg =[self nowImageIndext:num];
    NSString * upimg = [self upimageIndext:num];
    NSString * down = [self downimageIndext:num];
    image1 = [Photo string2Image:upimg];
    image2 = [Photo string2Image:nowimg];
    image3 = [Photo string2Image:down];
    imageView1.image = image1;
    imageView2.image = image2;
    imageView3.image = image3;
   
}

-(NSString *)upimageIndext:(NSNumber *)ind {
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
  
    NSString *queryString=[NSString stringWithFormat:@"select * from `wcMessage` where messageId < ? and messageType = 1 order by messageId desc limit 1"];//上一页
    if (![db open]) {
        NSLog(@"数据打开失败");
    }
    FMResultSet * rs =[db executeQuery:queryString,ind];
      NSString * imgstr=[[NSString alloc]init];
    while ([rs next]) {
        imgstr = [rs objectForColumnName:@"messageContent"];
        upindext = [rs objectForColumnName:@"messageId"];
        
    }
    return imgstr;
}
-(NSString * )downimageIndext:(NSNumber *)ind {
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
   
    NSString *queryString=[NSString stringWithFormat:@"select * from `wcMessage` where messageId > ? and messageType = 1 order by messageId asc limit 1"];// 下一页
    if (![db open]) {
        NSLog(@"数据打开失败");
    }
    FMResultSet * rs =[db executeQuery:queryString,ind];
    NSString * imgstr=[[NSString alloc]init];
    while ([rs next]) {
        imgstr = [rs objectForColumnName:@"messageContent"];
        downindex = [rs objectForColumnName:@"messageId"];
//        NSLog(@"cell rs ==%@",imgstr);
    }

    return imgstr;
}

#pragma mark - 手势
-(void)hideImageView:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//长按手势
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"长按手势。。。。。。");
        UIImageView *imageView = [gesture.view viewWithTag:1011];
        
        [LEEAlert actionsheet].config
        .LeeAction(@"Save to photos", ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                //                UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
                UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            });
            
            
        })
        .LeeCancelAction(@"Cancel", ^{
            
        })
        .LeeShow();
    }
}

-(void)longPressToDo2:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"长按手势。。。。。。");
        UIImageView *imageView = [gesture.view viewWithTag:1012];
        
        [LEEAlert actionsheet].config
        .LeeAction(@"Save to photos", ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                //                UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
                UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            });
            
            
        })
        .LeeCancelAction(@"Cancel", ^{
            
        })
        .LeeShow();
    }
}
-(void)longPressToDo3:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"长按手势。。。。。。");
        UIImageView *imageView = [gesture.view viewWithTag:1013];
        
        [LEEAlert actionsheet].config
        .LeeAction(@"Save to photos", ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                //                UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
                UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            });
            
            
        })
        .LeeCancelAction(@"Cancel", ^{
            
        })
        .LeeShow();
    }
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error !=NULL) {
        NSLog(@"保存失败");
        [self showMessage:@"Save failed"];
        
    }else {
        NSLog(@"保存成功");
        [self showMessage:@"Save success"];
    }
}
-(void)showMessage:(NSString *)message
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

#pragma mark - 缩放
-(void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    UIView *view = pinchGestureRecognizer.view;
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
        
    {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
        
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

 -(void)createBackScrolleview {
 FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
 NSString *queryString=[NSString stringWithFormat:@"select * from `wcMessage` where messageId = ? "];//当前
 
 if (![db open]) {
 NSLog(@"数据打开失败");
 
 }
 FMResultSet * rs =[db executeQuery:queryString,@"8"];
 NSString * imgstr=[[NSString alloc]init];
 while ([rs next]) {
 imgstr = [rs objectForColumnName:@"messageContent"];
 NSLog(@"cell rs ==%@",imgstr);
 }
 
 UIImageView * imageV = [[UIImageView alloc]init];
 imageV.frame = [UIScreen mainScreen].bounds;
 UIImage * image = [Photo string2Image:imgstr];
 imageV.image = image;
 [self.view addSubview:imageV];
 
 
 
 }
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
