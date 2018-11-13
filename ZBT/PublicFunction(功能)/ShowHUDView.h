//
//  ShowHUDView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/7/9.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface ShowHUDView : NSObject

+ (void)showHUDWithView:(UIView *)view AndTitle:(NSString *)title;

+ (void)showBigImageAtView:(UIView *)view AndImageURL:(NSArray *)URLArray;

+ (void)removeView;

@end
