//
//  ShowHUDView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/7/9.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ShowHUDView.h"
#import "Globefile.h"
#import "AppDelegate.h"

@interface ShowHUDView()

@end

@implementation ShowHUDView
static UIView *backGroundView = nil;

+ (void)showHUDWithView:(UIView *)view AndTitle:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.0];
}

+ (void)showBigImageAtView:(UIView *)view AndImageURL:(NSArray *)URLArray {
    float c = [URLArray count];
    backGroundView = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, SCREENBOUNDS.height)];
    [view addSubview:backGroundView];
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:backGroundView.bounds];
    scroll.pagingEnabled = YES;
    scroll.contentSize = CGSizeMake(SCREENBOUNDS.width * c, SCREENBOUNDS.height);
    [backGroundView addSubview:scroll];
    for (NSInteger index = 0; index < URLArray.count; index++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:FRAME(index * SCREENBOUNDS.width, 0, SCREENBOUNDS.width, SCREENBOUNDS.height)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:URLArray[index]] placeholderImage:[UIImage imageNamed:@"public"]];
        [scroll addSubview:imageV];
        
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
        [imageV addGestureRecognizer:tap];
    }
}

+ (void)removeView {
    [backGroundView removeFromSuperview];
}


@end
