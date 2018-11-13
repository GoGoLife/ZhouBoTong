//
//  MineTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/7.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "MineTableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation MineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.leftImageV = [[UIImageView alloc] init];
//    self.leftImageV.backgroundColor = RandomColor;
    
    self.topTextF = [[UITextField alloc] init];
    self.topTextF.enabled = NO;
    
    self.centerTextF = [[UITextField alloc] init];
    self.centerTextF.enabled = NO;
    
    self.bottomTextF = [[UITextField alloc] init];
    self.bottomTextF.enabled = NO;
    
    [self.contentView addSubview:self.leftImageV];
    [self.contentView addSubview:self.topTextF];
    [self.contentView addSubview:self.centerTextF];
    [self.contentView addSubview:self.bottomTextF];
}

- (void)layoutSubviews {
    CGFloat width = MineCellHeight - 20;
    __weak typeof(self) weakSelf = self;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(@(width));
    }];
    
    [self.topTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_top);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(5);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@(width / 3));
    }];
    
    [self.centerTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topTextF.mas_bottom);
        make.left.equalTo(weakSelf.topTextF.mas_left);
        make.right.equalTo(weakSelf.topTextF.mas_right);
        make.height.equalTo(weakSelf.topTextF.mas_height);
    }];
    
    [self.bottomTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerTextF.mas_bottom);
        make.left.equalTo(weakSelf.topTextF.mas_left);
        make.right.equalTo(weakSelf.topTextF.mas_right);
        make.height.equalTo(weakSelf.topTextF.mas_height);
    }];
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
