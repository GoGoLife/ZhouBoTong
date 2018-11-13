//
//  AppDelegate+HuanXin.h
//  ZBT
//
//  Created by 钟文斌 on 2018/8/3.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AppDelegate.h"
#import <Hyphenate/Hyphenate.h>
@interface AppDelegate (HuanXin)

- (BOOL)HuanXin_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)HuanXin_applicationDidEnterBackground:(UIApplication *)application;

- (void)HuanXin_applicationWillEnterForeground:(UIApplication *)application;

- (void)Huanxin_Register;

@end
