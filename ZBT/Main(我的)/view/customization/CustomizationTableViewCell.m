//
//  CustomizationTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/31.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "CustomizationTableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@interface CustomizationTableViewCell()

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation CustomizationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.topTextF = [[UITextField alloc] init];
    self.topTextF.enabled = NO;
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = Color176;
    
    self.nameTextF = [[UITextField alloc] init];
    self.nameTextF.enabled = NO;
    
    self.leftImageV = [[UIImageView alloc] init];
//    self.leftImageV.backgroundColor = RandomColor;
    self.leftImageV.image = [UIImage imageNamed:@"public"];
    
    self.priceTextF = [[UITextField alloc] init];
    self.priceTextF.enabled = NO;
    
    self.infoTextF = [[UITextField alloc] init];
    self.infoTextF.enabled = NO;
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = Color176;
    
    [self.contentView addSubview:self.topTextF];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.nameTextF];
    [self.contentView addSubview:self.leftImageV];
    [self.contentView addSubview:self.priceTextF];
    [self.contentView addSubview:self.infoTextF];
    [self.contentView addSubview:self.bottomLine];
}

- (void)layoutSubviews {
    CGFloat height = 170.0 / 3;
    __weak typeof(self) weakSelf = self;
    [self.topTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(height));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topTextF.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(@(1));
    }];
    
    [self.nameTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.line.mas_bottom);
        make.left.equalTo(weakSelf.topTextF.mas_left);
        make.right.equalTo(weakSelf.topTextF.mas_right);
        make.height.mas_equalTo(@(height * 2 / 3));
    }];
    
    
    CGFloat imageWidth = height * 2 / 3 * 2 - 20;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameTextF.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.topTextF.mas_left);
        make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
    }];
    
    [self.priceTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_top);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.topTextF.mas_right);
        make.height.mas_equalTo(@(imageWidth / 2));
    }];
    
    [self.infoTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.priceTextF.mas_bottom);
        make.left.equalTo(weakSelf.priceTextF.mas_left);
        make.right.equalTo(weakSelf.priceTextF.mas_right);
        make.height.equalTo(weakSelf.priceTextF.mas_height);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(@(1));
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
