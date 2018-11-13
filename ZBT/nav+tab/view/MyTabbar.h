//
//  MyTabbar.h
//  demo
//
//  Created by 钟文斌 on 2018/5/3.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTabbar;
//创建一个代理  响应中间凸起按钮的点击事件
@protocol MyTabBarDelegate<NSObject>

- (void)tabbarCenterClicks:(MyTabbar *)tabbar;

@end

@interface MyTabbar : UITabBar

@property (nonatomic, weak) id<MyTabBarDelegate> mydelegate;

@end

