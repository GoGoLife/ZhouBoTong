//
//  LBNavigationController.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBNavigationController.h"
#import "LBTabBarController.h"
#import "UIImage+Image.h"
//黄色导航栏
#define NavBarColor [UIColor colorWithRed:233/255.0 green:240/255.0 blue:245/255.0 alpha:1.0]
@interface LBNavigationController ()

@end

@implementation LBNavigationController

+ (void)load
{
//    UIBarButtonItem *item=[UIBarButtonItem appearanceWhenContainedIn:self, nil];
    UIBarButtonItem *item= [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    dic[NSForegroundColorAttributeName]=[UIColor blackColor];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];

    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];

    [bar setBackgroundImage:[UIImage imageWithColor:NavBarColor] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *dicBar=[NSMutableDictionary dictionary];

    dicBar[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    [bar setTitleTextAttributes:dic];

}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    return [super pushViewController:viewController animated:animated];
}

//- (UIViewController *)childViewControllerForStatusBarStyle {
//    return  self.topViewController;
//}
@end
