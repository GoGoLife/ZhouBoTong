//
//  GoPaymentView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/19.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "GoPaymentView.h"
#import "Globefile.h"

@interface GoPaymentView()

@end

@implementation GoPaymentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.imageV = [[UIImageView alloc] init];
//    self.imageV.backgroundColor = RandomColor;
    self.imageV.image = [UIImage imageNamed:@"cars"];
    
    self.bageLabel = [[UILabel alloc] init];
    self.bageLabel.backgroundColor = [UIColor redColor];
    ViewRadius(self.bageLabel, 10.0);
    self.bageLabel.font = SetFont(12);
    
    self.firstLabel = [[UILabel alloc] init];
    self.firstLabel.text = @"总计：";
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textColor = [UIColor redColor];
    self.priceLabel.text = @"¥0.0";
    
    self.paymentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.paymentButton.backgroundColor = [UIColor redColor];
    [self.paymentButton setTitle:@"去结算" forState:UIControlStateNormal];
    
    [self addSubview:self.imageV];
    [self.imageV addSubview:self.bageLabel];
    [self addSubview:self.firstLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.paymentButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak typeof(self) weakSelf = self;
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(5);
        make.left.equalTo(weakSelf.mas_left).offset(15);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-5);
        make.width.mas_equalTo(@(weakSelf.bounds.size.height - 10));
    }];
    
    [self.bageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.imageV.mas_right);
        make.centerY.equalTo(weakSelf.imageV.mas_top);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imageV.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.firstLabel.mas_right).offset(0);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.paymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf.mas_top);
        make.size.mas_equalTo(CGSizeMake(140, weakSelf.bounds.size.height));
    }];
    
}

@end
