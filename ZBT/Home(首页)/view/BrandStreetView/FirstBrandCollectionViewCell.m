//
//  FirstBrandCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/11.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "FirstBrandCollectionViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation FirstBrandCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.imageV = [[UIImageView alloc] init];
//    self.imageV.backgroundColor = RandomColor;
    self.imageV.image = [UIImage imageNamed:@"public"];
    
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.font = SetFont(17);
    self.topLabel.text = @"二手游艇";
    
    self.centerLabel = [[UILabel alloc] init];
//    self.centerLabel.font = SetFont(12);
//    self.centerLabel.text = @"【舟博通-游艇】";
    self.centerLabel.textColor = [UIColor redColor];
    self.centerLabel.font = SetFont(17);
    
    self.bottomLeft = [[UILabel alloc] init];
    self.bottomLeft.font = SetFont(11);
//    self.bottomLeft.textColor = [UIColor redColor];
//    self.bottomLeft.font = SetFont(17);
//    self.bottomLeft.text = @"¥400";
    
    self.bottomCenter = [[UILabel alloc] init];
    self.bottomCenter.font = SetFont(11);
    self.bottomCenter.text = @"已售0件";
    
    self.bottomRight = [[UILabel alloc] init];
    self.bottomRight.font = SetFont(11);
    self.bottomRight.text = @"好评99%";
    
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.topLabel];
    [self.contentView addSubview:self.centerLabel];
    [self.contentView addSubview:self.bottomLeft];
    [self.contentView addSubview:self.bottomCenter];
    [self.contentView addSubview:self.bottomRight];
    
    __weak typeof(self) weakSelf = self;
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(weakSelf.contentView.mas_width);
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageV.mas_bottom);
        make.left.equalTo(weakSelf.imageV.mas_left);
        make.size.mas_equalTo(CGSizeMake(weakSelf.contentView.bounds.size.width, 30));
    }];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_bottom);
        make.left.equalTo(weakSelf.imageV.mas_left);
        make.size.mas_equalTo(CGSizeMake(weakSelf.contentView.bounds.size.width, 30));
    }];
    
    [self.bottomLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerLabel.mas_bottom);
        make.left.equalTo(weakSelf.imageV.mas_left);
        make.size.mas_equalTo(CGSizeMake(weakSelf.contentView.bounds.size.width / 3 + 15, 30));
    }];
    
    [self.bottomCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomLeft.mas_top);
        make.left.equalTo(weakSelf.bottomLeft.mas_right);
        make.size.mas_equalTo(CGSizeMake(weakSelf.contentView.bounds.size.width / 3 - 15, 30));
    }];
    
    [self.bottomRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomLeft.mas_top);
        make.left.equalTo(weakSelf.bottomCenter.mas_right);
        make.size.mas_equalTo(CGSizeMake(weakSelf.contentView.bounds.size.width / 3, 30));
    }];
}


@end
