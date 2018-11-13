//
//  HomeCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/10.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation HomeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.topImageV = [[UIImageView alloc] init];
//    self.topImageV.backgroundColor = RandomColor;
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.textColor = SetColor(105, 105, 105, 1);
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.text = @"游艇买卖";
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.textColor = SetColor(173, 173, 173, 1);
    self.infoLabel.font = SetFont(12);
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.text = @"Yacht";
    
    
    
    [self.contentView addSubview:self.topImageV];
    [self.contentView addSubview:self.bottomLabel];
    [self.contentView addSubview:self.infoLabel];
    
    CGFloat width = self.contentView.bounds.size.width;
    __weak typeof(self) weakSelf = self;
    [self.topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(5);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(5);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-5);
        make.height.mas_equalTo(@(width - 10));
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topImageV.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.top.equalTo(weakSelf.bottomLabel.mas_bottom);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
    }];
}

- (void)layoutSubviews {
    
}

- (void)setIsNewLayout:(BOOL)isNewLayout {
    if (isNewLayout) {
        CGFloat width = self.contentView.bounds.size.width;
        __weak typeof(self) weakSelf = self;
        [self.topImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).offset(0);
            make.left.equalTo(weakSelf.contentView.mas_left).offset(0);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(0);
            make.height.mas_equalTo(@(width));
        }];
        
        [self.bottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.topImageV.mas_bottom);
            make.left.equalTo(weakSelf.topImageV.mas_left);
            make.right.equalTo(weakSelf.topImageV.mas_right);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        }];
        
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.topImageV.mas_left);
            make.right.equalTo(weakSelf.topImageV.mas_right);
            make.top.equalTo(weakSelf.bottomLabel.mas_bottom);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
    }
}

- (void)setIsCircle:(BOOL)isCircle {
    if (isCircle) {
        [self layoutIfNeeded];
        ViewRadius(self.topImageV, (self.topImageV.bounds.size.width - 10) / 2);
    }
}
@end
