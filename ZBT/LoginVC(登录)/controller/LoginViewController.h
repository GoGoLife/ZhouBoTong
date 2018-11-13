//
//  LoginViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <WXApi.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) UIButton *QQLoginBtn;

@property (nonatomic, strong) UIButton *WXLoginBtn;

/** 通过block去执行AppDelegate中的wechatLoginByRequestForUserInfo方法 */
@property (copy, nonatomic) void(^requestForUserInfoBlock)(void);

@end
