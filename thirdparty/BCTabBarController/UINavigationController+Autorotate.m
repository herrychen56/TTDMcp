//
//  BCTabBarController+Autorotate.m
//  TTD
//
//  Created by andy on 16/3/8.
//  Copyright © 2016年 totem. All rights reserved.
//

#import "UINavigationController+Autorotate.h"


@implementation UINavigationController (BCTabBarController)

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
