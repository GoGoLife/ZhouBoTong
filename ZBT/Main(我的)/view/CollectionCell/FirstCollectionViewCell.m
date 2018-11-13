//
//  FirstCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "FirstCollectionViewCell.h"
#import <Masonry.h>
#import "Globefile.h"

@implementation FirstCollectionViewCell

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
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = SetFont(14);
    self.nameLabel.backgroundColor = RandomColor;
    
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.nameLabel];
    
    CGFloat width = self.contentView.bounds.size.width / 3;
    
    __weak typeof(self) weakSelf = self;
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.imageV.mas_right);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.size.mas_equalTo(CGSizeMake(width * 2, width));
    }];
    
}


@end
