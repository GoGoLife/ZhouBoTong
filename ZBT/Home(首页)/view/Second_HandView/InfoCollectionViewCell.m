//
//  InfoCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/25.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "InfoCollectionViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation InfoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.topImageV = [[UIImageView alloc] init];
//    self.topImageV.backgroundColor = RandomColor;
    self.topImageV.image = [UIImage imageNamed:@"public"];
    
    self.label1 = [[UILabel alloc] init];
    self.label1.font = SetFont(12);
    
    self.label2 = [[UILabel alloc] init];
    self.label2.font = SetFont(12);
    
    self.label3 = [[UILabel alloc] init];
    self.label3.font = SetFont(12);
    
    self.label4 = [[UILabel alloc] init];
    self.label4.font = SetFont(12);
    
    self.label5 = [[UILabel alloc] init];
    self.label5.font = SetFont(12);
    
    [self.contentView addSubview:self.topImageV];
    [self.contentView addSubview:self.label1];
    [self.contentView addSubview:self.label2];
    [self.contentView addSubview:self.label3];
    [self.contentView addSubview:self.label4];
    [self.contentView addSubview:self.label5];
    
    CGFloat height = self.contentView.bounds.size.width;
    __weak typeof(self) weakSelf = self;
    [self.topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(@(height));
    }];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topImageV.mas_left);
        make.top.equalTo(weakSelf.topImageV.mas_bottom);
        make.right.equalTo(weakSelf.topImageV.mas_right);
        make.height.mas_equalTo(@(20));
    }];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topImageV.mas_left);
        make.top.equalTo(weakSelf.label1.mas_bottom);
        make.right.equalTo(weakSelf.topImageV.mas_right);
        make.height.mas_equalTo(@(20));
    }];
    
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topImageV.mas_left);
        make.top.equalTo(weakSelf.label2.mas_bottom);
        make.right.equalTo(weakSelf.topImageV.mas_right);
        make.height.mas_equalTo(@(20));
    }];
    
    [self.label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topImageV.mas_left);
        make.top.equalTo(weakSelf.label3.mas_bottom);
        make.right.equalTo(weakSelf.topImageV.mas_right);
        make.height.mas_equalTo(@(20));
    }];
    
    [self.label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topImageV.mas_left);
        make.top.equalTo(weakSelf.label4.mas_bottom);
        make.right.equalTo(weakSelf.topImageV.mas_right);
        make.height.mas_equalTo(@(20));
    }];
    
}

@end
