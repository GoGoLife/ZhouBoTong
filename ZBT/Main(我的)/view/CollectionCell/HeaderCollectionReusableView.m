//
//  HeaderCollectionReusableView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "HeaderCollectionReusableView.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation HeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.headerImg = [[UIImageView alloc] init];
//    self.headerImg.backgroundColor = RandomColor;
    self.headerImg.image = [UIImage imageNamed:@"public"];
    ViewRadius(self.headerImg, (self.bounds.size.height - 30) / 2);
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = SetFont(14);
    self.nameLabel.text = @"油纸伞";
    
    self.editLabel = [[UILabel alloc] init];
    self.editLabel.textAlignment = NSTextAlignmentLeft;
    self.editLabel.font = SetFont(12);
    self.editLabel.textColor = LineColor;
    self.editLabel.text = @"编辑个人信息";
    
    self.RZImg = [[UIImageView alloc] init];
    self.RZImg.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    
    [self addSubview:self.headerImg];
    [self addSubview:self.nameLabel];
    [self addSubview:self.editLabel];
    [self addSubview:self.RZImg];
    [self addSubview:line];
    
    __weak typeof(self) weakSelf = self;
    [self.headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.top.equalTo(weakSelf.mas_top).offset(15);
        make.left.equalTo(weakSelf.mas_left).offset(15);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-15);
        make.width.mas_equalTo(@(weakSelf.bounds.size.height - 30));
        
    }];
    
    CGFloat height = (self.bounds.size.height - 30) / 4;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(height);
        make.left.equalTo(weakSelf.headerImg.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake((SCREENBOUNDS.width - 30) / 2, height * 2));
    }];
    
    [self.editLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.mas_bottom);
        make.left.equalTo(weakSelf.headerImg.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake((SCREENBOUNDS.width - 30) / 2, height));
    }];
    
    [self.RZImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.nameLabel.mas_centerY);
        make.left.equalTo(weakSelf.nameLabel.mas_right).offset(20);
        make.right.equalTo(weakSelf.mas_right);
//        make.height.equalTo(self.nameLabel.mas_height);
        make.height.mas_equalTo(@(30));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.height.mas_equalTo(@(1));
    }];
}

@end
