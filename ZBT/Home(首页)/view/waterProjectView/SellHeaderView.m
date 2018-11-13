//
//  SellHeaderView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/24.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SellHeaderView.h"
#import "Globefile.h"
#import <Masonry.h>
#import "UITextField+LeftRightView.h"

@implementation SellHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.font = SetFont(17);
    
    self.bottomTextF = [[UITextField alloc] init];
    self.bottomTextF.enabled = NO;
    self.bottomTextF.textColor = Color176;
    self.bottomTextF.font = SetFont(12);
//    self.bottomTextF.text = @"定金：100";
    
    [self addSubview:self.topLabel];
    [self addSubview:self.bottomTextF];
    
    CGFloat height = (self.bounds.size.height - 20) / 2;
    __weak typeof(self) weakSelf = self;
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.height.mas_equalTo(@(height));
    }];
    
    [self.bottomTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topLabel.mas_left);
        make.top.equalTo(weakSelf.topLabel.mas_bottom);
        make.right.equalTo(weakSelf.topLabel.mas_right);
        make.height.mas_equalTo(@(height));
    }];
}

@end
