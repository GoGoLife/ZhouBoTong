//
//  ProjectCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/23.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ProjectCollectionViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@interface ProjectCollectionViewCell()

@end

@implementation ProjectCollectionViewCell

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
    self.topTextF.textAlignment = NSTextAlignmentRight;
    self.topTextF.enabled = NO;
    self.topTextF.font = SetFont(12);
//    self.topTextF.textColor = SetColor(163, 163, 163, 1);
//    self.topTextF.text = @"0条评价";
    
    
    self.centerTextF = [[UITextField alloc] init];
    self.centerTextF.enabled = NO;
    self.centerTextF.font = SetFont(12);
//    self.centerTextF.text = @"已售0件";
    
    self.bottomTextF = [[UITextField alloc] init];
    self.bottomTextF.enabled = NO;
    self.bottomTextF.font = SetFont(12);
    self.bottomTextF.textColor = SetColor(163, 163, 163, 1);
    
    [self.contentView addSubview:self.leftImageV];
    [self.contentView addSubview:self.topTextF];
    [self.contentView addSubview:self.centerTextF];
    [self.contentView addSubview:self.bottomTextF];
}

- (void)layoutSubviews {
    CGFloat height = self.contentView.bounds.size.height - 20;
    __weak typeof(self) weakSelf = self;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(0);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(0);
        make.width.mas_equalTo(@(weakSelf.contentView.bounds.size.height));
    }];
    
    [self.topTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_top);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(0);
        make.height.mas_equalTo(@(height * 0.4));
    }];
    
    [self.centerTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topTextF.mas_bottom);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(0);
        make.height.mas_equalTo(@(height * 0.4));
    }];
    
    [self.bottomTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerTextF.mas_bottom);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(0);
        make.height.mas_equalTo(@(height * 0.2));
    }];
}

StringWidth();
- (void)setTopLeftString:(NSString *)topLeftString {
    CGFloat width = [self calculateRowWidth:topLeftString withFont:17];
    [self.topTextF creatLeftView:FRAME(0, 0, width, self.topTextF.bounds.size.height) AndTitle:topLeftString TextAligment:NSTextAlignmentCenter Font:SetFont(17) Color:[UIColor blackColor]];
}

- (void)setTopRightString:(NSString *)topRightString {
    CGFloat width = [self calculateRowWidth:topRightString withFont:12];
    [self.topTextF creatRightView:FRAME(0, 0, width + 2, self.topTextF.bounds.size.height) AndTitle:topRightString TextAligment:NSTextAlignmentRight Font:SetFont(12) Color:SetColor(163, 163, 163, 1)];
}

- (void)setCenterLeftString:(NSString *)centerLeftString {
    CGFloat width = [self calculateRowWidth:centerLeftString withFont:12];
    [self.centerTextF creatLeftView:FRAME(0, 0, width + 20, self.centerTextF.bounds.size.height) AndTitle:centerLeftString TextAligment:NSTextAlignmentLeft Font:SetFont(12) Color:SetColor(163, 163, 163, 1)];
}

- (void)setCenterRightString:(NSString *)centerRightString {
    CGFloat width = [self calculateRowWidth:centerRightString withFont:12];
    [self.centerTextF creatRightView:FRAME(0, 0, width, self.centerTextF.bounds.size.height) AndTitle:centerRightString TextAligment:NSTextAlignmentCenter Font:SetFont(12) Color:SetColor(163, 163, 163, 1)];
}

- (void)setBottomLeftString:(NSString *)bottomLeftString {
    CGFloat width = [self calculateRowWidth:bottomLeftString withFont:12];
    [self.bottomTextF creatLeftView:FRAME(0, 0, width, self.bottomTextF.bounds.size.height) AndTitle:bottomLeftString TextAligment:NSTextAlignmentCenter Font:SetFont(12) Color:SetColor(163, 163, 163, 1)];
}

- (void)setBottomRightString:(NSString *)bottomRightString {
    CGFloat width = [self calculateRowWidth:bottomRightString withFont:12];
    [self.bottomTextF creatRightView:FRAME(0, 0, width, self.bottomTextF.bounds.size.height) AndTitle:bottomRightString TextAligment:NSTextAlignmentCenter Font:SetFont(12) Color:SetColor(163, 163, 163, 1)];
}


@end
