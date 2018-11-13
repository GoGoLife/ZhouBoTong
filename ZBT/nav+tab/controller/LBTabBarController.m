//
//  LBTabBarController.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBTabBarController.h"
#import "LBNavigationController.h"
//#import "UIView+LBExtension.h"
#import "UIView+Extension.h"
#import "UIImage+Image.h"

#import "HomeViewController.h"
#import "ClassifyViewController.h"
#import "BuySellViewController.h"
#import "ShoppingViewController.h"
#import "MainViewController.h"

#import "LBTabBar.h"
#import "UIImage+Image.h"


@interface LBTabBarController ()<LBTabBarDelegate>

@property (nonatomic, strong) LBTabBar *tabbar;

@property (nonatomic, strong) BuySellViewController *sell;

@property (nonatomic, strong) LBNavigationController *lb3;

@end

@implementation LBTabBarController

#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize
{
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:11];

    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:11];

    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];

}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self setUpAllChildVc];
    
    [self setUpAllChildVc];

    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
//    LBTabBar *tabbar = [[LBTabBar alloc] init];
//    self.tabbar.myDelegate = self;
//    //kvc实质是修改了系统的_tabBar
//    [self setValue:_tabbar forKeyPath:@"tabBar"];

}

- (UITabBar *)tabbar {
    if (_tabbar == nil) {
        _tabbar = [[LBTabBar alloc] init];
    }
    return _tabbar;
}

//自定义tabar必须实现
-(void)viewWillAppear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

#pragma mark - ------------------------------------------------------------------
#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮

- (void)setUpAllChildVc {
    HomeViewController *HomeVC = [[HomeViewController alloc] init];
    LBNavigationController *lb1 = [[LBNavigationController alloc] initWithRootViewController:HomeVC];
    HomeVC.tabBarItem.image = [[UIImage imageNamed:@"shouye1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    HomeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"shouye2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    HomeVC.tabBarItem.title = @"首页";
    
    ClassifyViewController *classify = [[ClassifyViewController alloc] init];
    LBNavigationController *lb2 = [[LBNavigationController alloc] initWithRootViewController:classify];
    classify.tabBarItem.image = [[UIImage imageNamed:@"fenlei1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    classify.tabBarItem.selectedImage = [[UIImage imageNamed:@"fenlei2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    classify.tabBarItem.title = @"分类";
    
    self.sell = [[BuySellViewController alloc] init];
    self.lb3 = [[LBNavigationController alloc] initWithRootViewController:self.sell];
    self.sell.tabBarItem.image = [[UIImage imageNamed:@"fabu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.sell.tabBarItem.selectedImage = [[UIImage imageNamed:@"fabu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.sell.tabBarItem.title = @"发布";
    CGSize imageSize = [UIImage imageNamed:@"fabu"].size;
    [self.sell.tabBarItem setImageInsets:UIEdgeInsetsMake(-(imageSize.height), 0, 0, 0)];

    
    ShoppingViewController *shopping = [[ShoppingViewController alloc] init];
    LBNavigationController *lb4 = [[LBNavigationController alloc] initWithRootViewController:shopping];
    shopping.tabBarItem.image = [[UIImage imageNamed:@"gouwuzhou1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    shopping.tabBarItem.selectedImage = [[UIImage imageNamed:@"gouwuzhou2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    shopping.tabBarItem.title = @"购物舟";
    
    MainViewController *MineVC = [[MainViewController alloc] init];
    LBNavigationController *lb5 = [[LBNavigationController alloc] initWithRootViewController:MineVC];
    MineVC.tabBarItem.image = [[UIImage imageNamed:@"wode1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"wode2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MineVC.tabBarItem.title = @"我的";
    
    self.viewControllers = @[lb1, lb2, self.lb3, lb4, lb5];
    
}

//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    float  spacing = 15;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height) - 5, 0.0 - 5, 0.0 - 5, - titleSize.width - 5);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    LBNavigationController *nav = [[LBNavigationController alloc] initWithRootViewController:Vc];


    Vc.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:242/255.0 blue:247/255.0 alpha:1];

    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;

    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    Vc.tabBarItem.selectedImage = mySelectedImage;

    Vc.tabBarItem.title = title;

    Vc.navigationItem.title = title;

    [self addChildViewController:nav];
    
}



#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(LBTabBar *)tabBar
{


//    LBpostViewController *plusVC = [[LBpostViewController alloc] init];
//    plusVC.view.backgroundColor = [self randomColor];
//
//    LBNavigationController *navVc = [[LBNavigationController alloc] initWithRootViewController:plusVC];
//
//    [self presentViewController:navVc animated:YES completion:nil];



}




- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];

}

@end
