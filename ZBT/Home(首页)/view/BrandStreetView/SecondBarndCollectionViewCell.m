//
//  SecondBarndCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/11.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SecondBarndCollectionViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation SecondBarndCollectionViewCell

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
    self.topLabel.text = @"二手游艇";
    
    self.centerLabel = [[UILabel alloc] init];
    self.centerLabel.textAlignment = NSTextAlignmentRight;
    self.centerLabel.text = @"【舟博通-游艇】";
    
    self.bottomLeft = [[UILabel alloc] init];
    self.bottomLeft.textColor = [UIColor redColor];
    self.bottomLeft.text = @"¥400";
    
    self.bottomCenter = [[UILabel alloc] init];
    self.bottomCenter.font = SetFont(14);
    self.bottomCenter.text = @"已售0件";
    
    self.bottomRight = [[UILabel alloc] init];
    self.bottomRight.font = SetFont(14);
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
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.width.mas_equalTo(weakSelf.contentView.mas_height);
    }];
    
    CGFloat width = SCREENBOUNDS.width - self.contentView.bounds.size.height - 40;
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageV.mas_top);
        make.left.equalTo(weakSelf.imageV.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(width / 2 - 30, weakSelf.contentView.bounds.size.height / 3));
    }];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_top);
        make.left.equalTo(weakSelf.topLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(width / 2 + 30, weakSelf.contentView.bounds.size.height / 3));
    }];
    
    
//    CGFloat bottomWidth = (SCREENBOUNDS.width - weakSelf.contentView.bounds.size.height - 40) / 3;
    [self.bottomLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_bottom);
        make.left.equalTo(weakSelf.topLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(width, weakSelf.contentView.bounds.size.height / 3));
    }];
    
    [self.bottomCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomLeft.mas_bottom);
        make.left.equalTo(weakSelf.topLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(width / 2, weakSelf.contentView.bounds.size.height / 3));
    }];
    
    [self.bottomRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomCenter.mas_top);
        make.left.equalTo(weakSelf.bottomCenter.mas_right);
        make.size.mas_equalTo(CGSizeMake(width / 2, weakSelf.contentView.bounds.size.height / 3));
    }];
}
@end
