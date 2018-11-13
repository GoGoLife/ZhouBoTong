//
//  AppDelegate+HuanXin.m
//  ZBT
//
//  Created by 钟文斌 on 2018/8/3.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AppDelegate+HuanXin.h"

@implementation AppDelegate (HuanXin)

- (BOOL)HuanXin_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"1113180714146940#zbt"];
    options.apnsCertName = @"aa";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    return YES;
}

// APP进入后台
- (void)HuanXin_applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)HuanXin_applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

//注册
- (void)Huanxin_Register {
    NSLog(@"11111111111111");
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    NSString *passWord = @"88888888";
    if (!userName) {
        NSLog(@"222222222222222");
        return;
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"register"] isEqualToString:@"1"]) {
        NSLog(@"333333333333");
        [self Huanxin_Login:userName AndPassword:passWord];
    }else {
        [[EMClient sharedClient] registerWithUsername:userName password:passWord completion:^(NSString *aUsername, EMError *aError) {
            BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
            if (!aError) {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"register"];
                NSLog(@"注册成功！！");
                if (!isAutoLogin) {
                    [self Huanxin_Login:userName AndPassword:passWord];
                }
                
            }else {
                NSLog(@"注册失败");
                if (!isAutoLogin) {
                    [self Huanxin_Login:userName AndPassword:passWord];
                }
            }
        }];
    }
    
}

- (void)Huanxin_Login:(NSString *)userName AndPassword:(NSString *)password {
    EMError *error = [[EMClient sharedClient] loginWithUsername:userName password:password];
    if (!error) {
        NSLog(@"登录成功");
        [[EMClient sharedClient].options setIsAutoLogin:YES];
    }else {
        NSLog(@"登录失败");
        NSLog(@"error == %@", error);
//        NSLog(@"error111 == %@", error.code);
        NSLog(@"error222 == %@", error.errorDescription);
    }
}

@end
