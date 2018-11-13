//
//  BaseViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYSSlideMenuController.h"
#import <MJRefresh.h>
#import "AppDelegate.h"
#import "ShowHUDView.h"

@interface BaseViewController : UIViewController
- (void)show;
- (void)hidden;
- (void)setUpNav;
@end
