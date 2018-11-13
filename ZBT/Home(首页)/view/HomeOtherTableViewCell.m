//
//  HomeOtherTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "HomeOtherTableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation HomeOtherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.topLabel = [[UILabel alloc] init];
    
    self.centerLabel = [[UILabel alloc] init];
    
    self.bottomLabel = [[UILabel alloc] init];
    
    self.rightImageV = [[UIImageView alloc] init];
    self.rightImageV.image = [UIImage imageNamed:@"phone"];
    self.rightImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone)];
    [self.rightImageV addGestureRecognizer:tap];
//    self.rightImageV.backgroundColor = RandomColor;
    
    [self.contentView addSubview:self.topLabel];
    [self.contentView addSubview:self.centerLabel];
    [self.contentView addSubview:self.bottomLabel];
    [self.contentView addSubview:self.rightImageV];
}

- (void)layoutSubviews {
    CGFloat height = (OtherCellHeight - 10) / 3;
    __weak typeof(self) weakSelf = self;
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(5);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-60);
        make.height.mas_equalTo(@(height));
    }];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_bottom);
        make.left.equalTo(weakSelf.topLabel.mas_left);
        make.right.equalTo(weakSelf.topLabel.mas_right);
        make.height.equalTo(weakSelf.topLabel.mas_height);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerLabel.mas_bottom);
        make.left.equalTo(weakSelf.topLabel.mas_left);
        make.right.equalTo(weakSelf.topLabel.mas_right);
        make.height.equalTo(weakSelf.topLabel.mas_height);
    }];
    
    [self.rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topLabel.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)callPhone {
    if ([_delegate respondsToSelector:@selector(callPhoneWithPhoneTitle:)]) {
        [_delegate callPhoneWithPhoneTitle:self.indexPath];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
