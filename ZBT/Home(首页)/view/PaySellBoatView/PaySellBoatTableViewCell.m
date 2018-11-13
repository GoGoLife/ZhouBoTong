//
//  PaySellBoatTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/2.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "PaySellBoatTableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation PaySellBoatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.leftImg = [[UIImageView alloc] init];
//    self.leftImg.backgroundColor = RandomColor;
    self.leftImg.image = [UIImage imageNamed:@"public"];
    
    self.textF = [[UITextField alloc] init];
    self.textF.enabled = NO;
    self.textF.font = SetFont(18);
    self.textF.text = @"二手游艇";
    
    self.price = [[UILabel alloc] init];
    self.price.textColor = [UIColor redColor];
    self.price.font = SetFont(15);
    self.price.text = @"¥400";
    
    
    self.bottomTextF = [[UITextField alloc] init];
    self.bottomTextF.enabled = NO;
    self.bottomTextF.font = SetFont(12);
    self.bottomTextF.text = @"喜马拉雅店";
    
    UIImageView *bottomLeft = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 15, 15)];
    //    bottomLeft.backgroundColor = RandomColor;
    bottomLeft.image = [UIImage imageNamed:@"dianpu"];
    self.bottomTextF.leftView = bottomLeft;
    self.bottomTextF.leftViewMode = UITextFieldViewModeAlways;
    
    
    [self.contentView addSubview:self.leftImg];
    [self.contentView addSubview:self.textF];
    [self.contentView addSubview:self.price];
    [self.contentView addSubview:self.bottomTextF];
    
    CGFloat height = 110.0 - 20;
    __weak typeof(self) weakSelf = self;
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(height, height));
    }];
    
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImg.mas_top);
        make.left.equalTo(weakSelf.leftImg.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(height * 0.4));
    }];
    
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textF.mas_bottom);
        make.left.equalTo(weakSelf.leftImg.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(height * 0.4));
    }];
    
    [self.bottomTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.price.mas_bottom);
        make.left.equalTo(weakSelf.leftImg.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(height * 0.2));
    }];
}

- (void)setIsType:(BOOL)isType {
    CGFloat height = 110.0 - 20;
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 20, height * 0.3)];
    
    self.textF.rightView = rightImg;
    self.textF.rightViewMode = UITextFieldViewModeAlways;
    
    if (isType) {
        rightImg.image = [UIImage imageNamed:@"gong"];
    }else {
        rightImg.image = [UIImage imageNamed:@"qiu"];
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
