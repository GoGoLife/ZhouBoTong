//
//  CustomCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/31.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "CustomCollectionViewCell.h"
#import "Globefile.h"
#import <Masonry.h>
#import "UITextField+LeftRightView.h"

@interface CustomCollectionViewCell()

@property (nonatomic, strong) UIView *line;

@end

@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
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
    self.topTextF.text = @"收购摩托艇";
    
    self.centerLabel = [[UILabel alloc] init];
    self.centerLabel.textColor = [UIColor redColor];
    self.centerLabel.font = SetFont(14);
//    self.centerLabel.text = @"¥400";
    
    self.bottomTextF = [[UITextField alloc] init];
    self.bottomTextF.enabled = NO;
    self.bottomTextF.textColor = [UIColor redColor];
    self.bottomTextF.font = SetFont(14);
//    self.bottomTextF.textAlignment = NSTextAlignmentRight;
//    self.bottomTextF.textColor = SetColor(180, 180, 180, 1);
//    self.bottomTextF.font = SetFont(12);
//    self.bottomTextF.text = @"发布时间：2018-12-10 12:12";
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = LineColor;
    
    [self.contentView addSubview:self.leftImageV];
    [self.contentView addSubview:self.topTextF];
    [self.contentView addSubview:self.centerLabel];
    [self.contentView addSubview:self.bottomTextF];
    [self.contentView addSubview:self.line];
}

- (void)layoutSubviews {
    CGFloat height = 110.0 - 20;
    __weak typeof(self) weakSelf = self;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(height, height));
    }];
    
    [self.topTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_top);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@(height / 3));
    }];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topTextF.mas_bottom);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@(height / 3));
    }];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = FRAME(0, 0, [self calculateRowWidth:@"给他留言" withFont:13], height / 3);
    self.button.titleLabel.font = SetFont(13);
    [self.button setTitle:@"给他留言" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(leaveMessage) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomTextF creatLeftView:self.button.frame AndControl:self.button];
    
    [self.bottomTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerLabel.mas_bottom);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@(height / 3));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_right).offset(0);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(0);
        make.height.mas_equalTo(@(1));
    }];
    
//    [self.bottomTextF creatLeftView:FRAME(0, 0, [self calculateRowWidth:@"温州" withFont:12], height / 3) AndTitle:@"温州" TextAligment:NSTextAlignmentRight Font:SetFont(12) Color:SetColor(180, 180, 180, 1)];
}

StringWidth();

- (void)leaveMessage {
    if ([_delegate respondsToSelector:@selector(touchLeaveMessageButton)]) {
        [_delegate touchLeaveMessageButton];
    }
}

@end
