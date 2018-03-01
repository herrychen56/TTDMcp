//
//  ZNTestsViewController.m
//  TTD
//
//  Created by quakoo on 2018/1/26.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "ZNTestsViewController.h"
#import "SPPageMenu.h"
#import "TestBaseViewController.h"
#import "ActListViewController.h"
#import "APListViewController.h"
#import "LeLtsListViewController.h"
#import "LseeListViewController.h"
#import "SatIILIstViewController.h"
#import "SatNewListViewController.h"
#import "SatOidListViewController.h"
#import "SSatListViewController.h"
#import "ToefiListViewController.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define pageMenuH 40
#define NaviH (screenH == 812 ? 88 : 64) // 812是iPhoneX的高度
#define scrollViewHeight (screenH-88-pageMenuH)
@interface ZNTestsViewController ()<SPPageMenuDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property(nonatomic,strong) NSMutableArray * dataarr;
@property(nonatomic,strong)NSMutableArray * actlistArr;
@property(nonatomic,strong)NSMutableArray * aplistArr;
@property(nonatomic,strong)NSMutableArray * leltslistArr;
@property(nonatomic,strong)NSMutableArray * lseelistArr;
@property(nonatomic,strong)NSMutableArray * SatiilistArr;
@property(nonatomic,strong)NSMutableArray * SatNewlistArr;
@property(nonatomic,strong)NSMutableArray * SatoidlArr;
@property(nonatomic,strong)NSMutableArray *SSatlistArr;
@property(nonatomic,strong)NSMutableArray *ToefilistArr;


@end

@implementation ZNTestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataarr =[[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr  = [[NSArray alloc]initWithObjects:@"ACT",@"APL",@"IELTS",@"ISEE",@"SAT II",@"SAT(New)",@"SAT(Old)",@"SSAT",@"TOEFL", nil];
//    self.dataArr = @[@"ActList",@"APList",@"IeltsList",@"IseeList",@"SatIIList",@"SatNewList",@"SatOldList",@"SSatList",@"ToeflList"];
    [MBManager showLoading];
    [self getTest];
    
//
}
-(void)createUI {
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, screenW, pageMenuH) trackerStyle:SPPageMenuTrackerStyleRoundedRect];
    pageMenu.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    [pageMenu setItems:self.dataArr selectedItemIndex:0];
    
    pageMenu.delegate = self;
    [self.view addSubview:pageMenu];
    _pageMenu = pageMenu;
    
//    NSArray *controllerClassNames = [NSArray arrayWithObjects:@"ActListViewController",@"APListViewController",@"LeLtsListViewController",@"LseeListViewController",@"SatIILIstViewController",@"SatNewListViewController",@"SatOidListViewController",@"SSatListViewController",@"ToefiListViewController", nil];
    
    
    ActListViewController * one = [[ActListViewController alloc]init];
    one.datasout =_dataarr[0];
    APListViewController *two = [[APListViewController alloc]init];
    two.datasout =_dataarr[1];
    LeLtsListViewController * three = [[LeLtsListViewController alloc]init];
    three.datasout =_dataarr[2];
    LseeListViewController * four = [[LseeListViewController alloc]init];
    four.datasout = _dataarr[3];
    SatIILIstViewController * five = [[SatIILIstViewController alloc]init];
    five.datasout = _dataarr[4];
    SatNewListViewController * six = [[SatNewListViewController alloc]init];
    six.datasout = _dataarr[5];
    SatOidListViewController * seven = [[SatOidListViewController alloc]init];
    seven.datasout = _dataarr[6];
    SSatListViewController * eigh = [[SSatListViewController alloc]init];
    eigh.datasout = _dataarr[7];
    ToefiListViewController * nine = [[ToefiListViewController alloc]init];
    nine.datasout = _dataarr[8];
    
    [self addChildViewController:one];
    [self addChildViewController:two];
    [self addChildViewController:three];
    [self addChildViewController:four];
    [self addChildViewController:five];
    [self addChildViewController:six];
    [self addChildViewController:seven];
    [self addChildViewController:eigh];
    [self addChildViewController:nine];
    
     [self.myChildViewControllers addObject:one];
    [self.myChildViewControllers addObject:two];
    [self.myChildViewControllers addObject:three];
    [self.myChildViewControllers addObject:four];
    [self.myChildViewControllers addObject:five];
    [self.myChildViewControllers addObject:six];
    [self.myChildViewControllers addObject:seven];
    [self.myChildViewControllers addObject:eigh];
    [self.myChildViewControllers addObject:nine];
    
//    for (int i = 0; i < self.dataArr.count; i++) {
//        if (controllerClassNames.count > i) {
//            TestBaseViewController *baseVc = [[NSClassFromString(controllerClassNames[i]) alloc] init];
//            //            NSString *text = [self.pageMenu titleForItemAtIndex:i];
//            baseVc.datasout =_dataarr[i];
//            [self addChildViewController:baseVc];
//
//            [self.myChildViewControllers addObject:baseVc];
//        }
//    }
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0+pageMenuH, screenW, scrollViewHeight)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
    self.pageMenu.bridgeScrollView = self.scrollView;
    
    // pageMenu.selectedItemIndex就是选中的item下标
    if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
//        BaseViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
        one = self.myChildViewControllers[0];
        two = self.myChildViewControllers[1];
        three =  self.myChildViewControllers[2];
        four = self.myChildViewControllers[3];
        five = self.myChildViewControllers[4];
        six = self.myChildViewControllers[5];
        seven = self.myChildViewControllers[6];
        eigh = self.myChildViewControllers[7];
        nine = self.myChildViewControllers[8];
        
        [scrollView addSubview:one.view];
        [scrollView addSubview:two.view];
        [scrollView addSubview:three.view];
        [scrollView addSubview:four.view];
        [scrollView addSubview:five.view];
        [scrollView addSubview:six.view];
        [scrollView addSubview:seven.view];
        [scrollView addSubview:eigh.view];
        [scrollView addSubview:nine.view];

//        baseVc.view.frame = CGRectMake(screenW*self.pageMenu.selectedItemIndex, 0, screenW, scrollViewHeight);
        one.view.frame = CGRectMake(screenW*0, 0, screenW, scrollViewHeight);
        two.view.frame =  CGRectMake(screenW*1, 0, screenW, scrollViewHeight);
        three.view.frame =  CGRectMake(screenW*2, 0, screenW, scrollViewHeight);
        four.view.frame = CGRectMake(screenW*3, 0, screenW, scrollViewHeight);
        five.view.frame =  CGRectMake(screenW*4, 0, screenW, scrollViewHeight);
        six.view.frame =  CGRectMake(screenW*5, 0, screenW, scrollViewHeight);
        seven.view.frame =  CGRectMake(screenW*6, 0, screenW, scrollViewHeight);
        eigh.view.frame =  CGRectMake(screenW*7, 0, screenW, scrollViewHeight);
        nine.view.frame =  CGRectMake(screenW*8, 0, screenW, scrollViewHeight);
        scrollView.contentOffset = CGPointMake(screenW*self.pageMenu.selectedItemIndex, 0);
        scrollView.contentSize = CGSizeMake(self.dataArr.count*screenW, 0);
    }
}
-(void)getTest {
    
   
    NSURL *url = [NSURL URLWithString:WEBRTC_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_Tests parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         ZNgetTests * znallet = [ZNgetTests responseWithDDXMLDocument:XMLDocument];
         NSString * json = znallet.getTests;
         NSDictionary  * jsondic = [SharedAppDelegate dictionaryWithJsonString:json];
//         NSLog(@"===getALLEA === %@",jsondic);
         _actlistArr = [jsondic objectForKey:@"TestsActList"];
         _aplistArr = [jsondic objectForKey:@"TestsAPList"];
         _leltslistArr = [jsondic objectForKey:@"TestsIeltsList"];
         _lseelistArr = [jsondic objectForKey:@"TestsIseeList"];
         _SatiilistArr = [jsondic objectForKey:@"TestsSatIIList"];
         _SatNewlistArr = [jsondic objectForKey:@"TestsSatNewList"];
         _SatoidlArr = [jsondic objectForKey:@"TestsSatOldList"];
         _SSatlistArr = [jsondic objectForKey:@"TestsSSatList"];
         _ToefilistArr = [jsondic objectForKey:@"TestsToeflList"];

//         [self createUI];
         [_dataarr addObject:_actlistArr];
         [_dataarr addObject: _aplistArr ];
         [_dataarr addObject:_leltslistArr ];
         [_dataarr addObject:_lseelistArr];
         [_dataarr addObject:_SatiilistArr ];
         [_dataarr addObject:_SatNewlistArr ];
         [_dataarr addObject:_SatoidlArr ];
         [_dataarr addObject:_SSatlistArr ];
         [_dataarr addObject:_ToefilistArr ];
         
         [self createUI];
         [MBManager hideAlert];
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
         NSLog(@"getUPCOMINGMEETING失败===%@",error);
     }];
    [operation start];
}




#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"===%zd",index);
}

-(void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    NSLog(@"pageMenu%zd------->%zd",fromIndex,toIndex);
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:YES];
    }
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(screenW * toIndex, 0, screenW, scrollViewHeight);
    [_scrollView addSubview:targetViewController.view];
    
}

#pragma mark - insert or remove

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pageMenu moveTrackerFollowScrollView:scrollView];
}


- (void)removeItemAtIndex:(NSInteger)index {
    
    if (index >= self.myChildViewControllers.count) {
        return;
    }
    
    [self.pageMenu removeItemAtIndex:index animated:YES];
    
    // 删除之前，先将新控制器之后的控制器view往前偏移
    for (int i = 0; i < self.myChildViewControllers.count; i++) {
        if (i >= index) {
            UIViewController *childController = self.myChildViewControllers[i];
            childController.view.frame = CGRectMake(screenW * (i>0?(i-1):i), 0, screenW, scrollViewHeight);
            [self.scrollView addSubview:childController.view];
        }
    }
    if (index <= self.pageMenu.selectedItemIndex) { // 移除的item在当前选中的item之前
        // scrollView往前偏移
        NSInteger offsetIndex = self.pageMenu.selectedItemIndex-1;
        if (offsetIndex < 0) {
            offsetIndex = 0;
        }
        self.scrollView.contentOffset = CGPointMake(screenW*offsetIndex, 0);
    }
    
    UIViewController *vc = [self.myChildViewControllers objectAtIndex:index];
    [self.myChildViewControllers removeObjectAtIndex:index];
    [vc removeFromParentViewController];
    [vc.view removeFromSuperview];
    
    // 重新设置scrollView容量
    self.scrollView.contentSize = CGSizeMake(screenW*self.myChildViewControllers.count, 0);
}



//- (void)removeAllItems {
//    [self.pageMenu removeAllItems];
//    for (UIViewController *vc in self.myChildViewControllers) {
//        [vc removeFromParentViewController];
//        [vc.view removeFromSuperview];
//    }
//    [self.myChildViewControllers removeAllObjects];
//
//    self.scrollView.contentOffset = CGPointMake(0, 0);
//    self.scrollView.contentSize = CGSizeMake(0, 0);
//
//}



#pragma mark - getter

- (NSMutableArray *)myChildViewControllers {
    
    if (!_myChildViewControllers) {
        _myChildViewControllers = [[NSMutableArray alloc]init] ;
        
    }
    return _myChildViewControllers;
}

- (void)dealloc {
    NSLog(@"父控制器被销毁了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
