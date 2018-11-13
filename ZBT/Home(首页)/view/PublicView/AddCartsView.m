//
//  AddCartsView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AddCartsView.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation AddCartsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creatUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)creatUI {
    self.DPButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.DPButton setTitleColor:SetColor(149, 149, 149, 1) forState:UIControlStateNormal];
    self.DPButton.titleLabel.font = SetFont(12);
    [self.DPButton setImage:[UIImage imageNamed:@"dianpu"] forState:UIControlStateNormal];
    [self.DPButton setTitle:@"店铺" forState:UIControlStateNormal];
    [self initButton:self.DPButton];
    
    self.KFButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.KFButton setTitleColor:SetColor(149, 149, 149, 1) forState:UIControlStateNormal];
    self.KFButton.titleLabel.font = SetFont(12);
    [self.KFButton setImage:[UIImage imageNamed:@"kefu"] forState:UIControlStateNormal];
    [self.KFButton setTitle:@"聊天" forState:UIControlStateNormal];
    [self initButton:self.KFButton];
    
    self.AddCartsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.AddCartsButton.backgroundColor = SetColor(252, 174, 79, 1);
    self.AddCartsButton.titleLabel.font = SetFont(15);
    [self.AddCartsButton setTitle:@"加入购物舟" forState:UIControlStateNormal];
    
    self.PayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.PayButton.backgroundColor = SetColor(250, 70, 74, 1);
    self.PayButton.titleLabel.font = SetFont(15);
    [self.PayButton setTitle:@"立即购买" forState:UIControlStateNormal];
    
    [self addSubview:self.DPButton];
    [self addSubview:self.KFButton];
    [self addSubview:self.AddCartsButton];
    [self addSubview:self.PayButton];
    
    __weak typeof(self) weakSelf = self;
    CGFloat width = SCREENBOUNDS.width / 3;
    [self.DPButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.mas_top);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.width.mas_equalTo(@(width / 2));
    }];
    
    [self.KFButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.DPButton.mas_right);
        make.top.equalTo(weakSelf.mas_top);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.width.mas_equalTo(@(width / 2));
    }];
    
    width = (SCREENBOUNDS.width - width - 15) / 2;
    [self.AddCartsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.KFButton.mas_right).offset(15);
        make.top.equalTo(weakSelf.mas_top);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.width.mas_equalTo(@(width));
    }];
    
    [self.PayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.AddCartsButton.mas_right);
        make.top.equalTo(weakSelf.mas_top);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.width.mas_equalTo(@(width));
    }];
}

- (void)layoutSubviews {
    
}

//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    float  spacing = 15;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height) - 5, 0.0 - 5, 0.0 - 5, - titleSize.width - 5);
    btn.titleEdgeInsets = UIEdgeInsetsMake(10, - imageSize.width - 20, - (totalHeight - titleSize.height), 0);
}
@end
