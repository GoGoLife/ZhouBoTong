//
//  SecondCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SecondCollectionViewCell.h"
#import <Masonry.h>
#import "Globefile.h"

@implementation SecondCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.imageV = [[UIImageView alloc] init];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = SetFont(13);
    
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.nameLabel];
    
    CGFloat height = self.contentView.bounds.size.height / 3;
    
    __weak typeof(self) weakSelf = self;
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(height, height));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageV.mas_bottom);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.width.equalTo(weakSelf.contentView.mas_width);
    }];
}

@end
