//
//  AppDelegate+UShare.h
//  ZBT
//
//  Created by 钟文斌 on 2018/7/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AppDelegate.h"
#import <UMShare/UMShare.h>

@interface AppDelegate (UShare)
- (void)UMengShareApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (BOOL)UMengApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (BOOL)UMengApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

- (BOOL)UMengApplication:(UIApplication *)application handleOpenURL:(NSURL *)url;
@end
