//
//  BrandHeaderView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/11.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BrandHeaderView.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation BrandHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    
    return self;
}

- (void)setUI {
    self.leftV = [[UIImageView alloc] init];
//    self.leftV.backgroundColor = RandomColor;
    self.leftV.image = [UIImage imageNamed:@"public"];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = SetFont(17);
    self.nameLabel.text = @"拿破仑导航";
    
    self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.collectButton setBackgroundColor:[UIColor redColor]];
    self.collectButton.titleLabel.font = SetFont(12);
    ViewRadius(self.collectButton, 10.0);
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.font = SetFont(12);
    self.numberLabel.text = @"已售0单 | 0人收藏";
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.font = SetFont(14);
    self.priceLabel.text = @"¥0元起送 | 配送费：¥2000";
    
    [self addSubview:self.leftV];
    [self addSubview:self.nameLabel];
    [self addSubview:self.collectButton];
    [self addSubview:self.numberLabel];
    [self addSubview:self.priceLabel];
    
    __weak typeof(self) weakSelf = self;
    [self.leftV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(15);
        make.left.equalTo(weakSelf.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(HeaderHeight - 30, HeaderHeight - 30));
    }];
    
    CGFloat height = (HeaderHeight - 30) / 3;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftV.mas_top);
        make.left.equalTo(weakSelf.leftV.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREENBOUNDS.width / 2, height));
    }];
    
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-15);
        make.centerY.equalTo(weakSelf.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_left);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom);
        make.right.equalTo(weakSelf.collectButton.mas_right);
        make.height.mas_equalTo(@(height));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_left);
        make.top.equalTo(weakSelf.numberLabel.mas_bottom);
        make.right.equalTo(weakSelf.collectButton.mas_right);
        make.height.mas_equalTo(@(height));
    }];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
