//
//  Boat_footerView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Boat_footerView.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation Boat_footerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creaetUI];
    }
    return self;
}

- (void)creaetUI {
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.font = SetFont(15);
    self.leftLabel.textColor = SetColor(49, 49, 49, 1);
    self.leftLabel.text = @"配送方式";
    
    self.firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.firstBtn setTitle:@"快递物流" forState:UIControlStateNormal];
    self.firstBtn.titleLabel.font = SetFont(12);
    self.firstBtn.backgroundColor = BaseViewColor;
    ViewRadius(self.firstBtn, 10.0);
    self.firstBtn.tag = 400;
    [self.firstBtn addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    self.firstBtn.hidden = YES;
    
    self.secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.secondBtn setTitle:@"快递物流" forState:UIControlStateNormal];
    self.secondBtn.titleLabel.font = SetFont(12);
    self.secondBtn.backgroundColor = [UIColor redColor];
    ViewRadius(self.secondBtn, 10.0);
    self.secondBtn.tag = 401;
    [self.secondBtn addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.leftLabel];
    [self addSubview:self.firstBtn];
    [self addSubview:self.secondBtn];
}

- (void)layoutSubviews {
    __weak typeof(self) weakSelf = self;
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(weakSelf.mas_left).offset(15);
    }];
    
    [self.firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(-95);
        make.size.mas_equalTo(CGSizeMake(75, 20));
    }];
    
    [self.secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(weakSelf.firstBtn.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(75, 20));
    }];
}

- (void)touchAction:(UIButton *)button {
    for (UIButton *btn in self.subviews) {
        if (button.tag == btn.tag) {
            btn.backgroundColor = [UIColor redColor];
            if ([_delegate respondsToSelector:@selector(getWayIndex:)]) {
                [_delegate getWayIndex:button.tag - 400];
            }
        }else {
            btn.backgroundColor = BaseViewColor;
        }
    }
}

@end
