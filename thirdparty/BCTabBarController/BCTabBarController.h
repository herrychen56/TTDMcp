#import "BCTabBar.h"

@class BCTabBarView;

@protocol BCTabBarControllerDelegate <NSObject>

- (void)didSelectedTabAtIndex:(int)index;

@end

@interface BCTabBarController : UIViewController <BCTabBarDelegate,UINavigationControllerDelegate>

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) BCTabBar *tabBar;
@property (nonatomic, retain) UIViewController *selectedViewController;
@property (nonatomic, retain) BCTabBarView *tabBarView;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, readonly) BOOL visible;
@property (nonatomic, assign) id<BCTabBarControllerDelegate> mDelegate;
@property (nonatomic, retain) UIView *BadgeView;
@end
