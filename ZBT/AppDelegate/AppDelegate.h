//
//  AppDelegate.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/3.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXApi.h>
#import "LoginViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setHomeVC;

- (void)setLoginVC;

- (void)wechatLoginByRequestForUserInfo;

@end

