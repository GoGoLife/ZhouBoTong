//
//  ProjectTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/23.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ProjectTableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>
#import "UITextField+LeftRightView.h"

@implementation ProjectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.leftImageV = [[UIImageView alloc] init];
//    self.leftImageV.backgroundColor = RandomColor;
    self.leftImageV.image = [UIImage imageNamed:@"public"];
    
    self.topTextF = [[UITextField alloc] init];
    self.topTextF.enabled = NO;
    self.topTextF.text = @"租艇钓鱼";
    
    self.centerTextF = [[UITextField alloc] init];
    self.centerTextF.enabled = NO;
    self.centerTextF.font = SetFont(12);
    self.centerTextF.text = @"各种游艇出租，快艇，摩托艇，豪华游艇";
    
    self.bottomTextF = [[UITextField alloc] init];
    self.bottomTextF.enabled = NO;
    self.bottomTextF.font = SetFont(12);
    self.bottomTextF.text = @"定金：¥50";
    
    [self.contentView addSubview:self.leftImageV];
    [self.contentView addSubview:self.topTextF];
    [self.contentView addSubview:self.centerTextF];
    [self.contentView addSubview:self.bottomTextF];
}


- (void)layoutSubviews {
    CGFloat height = self.contentView.bounds.size.height - 30;
    __weak typeof(self) weakSelf = self;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-15);
        make.width.mas_equalTo(@(height));
    }];
    
    [self.topTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_top);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(@(height / 3));
    }];
    
    [self.centerTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topTextF.mas_bottom);
        make.left.equalTo(weakSelf.topTextF.mas_left);
        make.right.equalTo(weakSelf.topTextF.mas_right);
        make.height.mas_equalTo(@(height / 3 / 2));
    }];
    
    [self.bottomTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topTextF.mas_left);
        make.right.equalTo(weakSelf.topTextF.mas_right);
        make.bottom.equalTo(weakSelf.leftImageV.mas_bottom);
        make.height.mas_equalTo(@(height / 3));
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
