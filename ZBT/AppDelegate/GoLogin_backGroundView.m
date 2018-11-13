//
//  GoLogin_backGroundView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/9/3.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "GoLogin_backGroundView.h"
#import "Globefile.h"

@implementation GoLogin_backGroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.goLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goLoginBtn.backgroundColor = [UIColor redColor];
    [self.goLoginBtn setTitle:@"去登录" forState:UIControlStateNormal];
    self.goLoginBtn.frame = FRAME(0, 0, 120, 30);
    self.goLoginBtn.center = CGPointMake(self.center.x, self.center.y);
    [self addSubview:self.goLoginBtn];
}

@end
