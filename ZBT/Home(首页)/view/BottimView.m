//
//  BottimView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/2.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BottimView.h"
#import <Masonry.h>
#import "Globefile.h"

@interface BottimView()

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIButton *button;

@end

@implementation BottimView

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
    
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.text = @"码头出行";
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.textColor = [UIColor redColor];
    self.bottomLabel.text = @"¥400";
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = BaseViewColor;
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.textColor = SetColor(159, 159, 159, 1);
    self.numberLabel.font = SetFont(14);
    self.numberLabel.text = @"人数";
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureButton.backgroundColor = [UIColor redColor];
    self.sureButton.tag = 300;
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [self addSubview:self.leftImageV];
    [self addSubview:self.topLabel];
    [self addSubview:self.bottomLabel];
    [self addSubview:self.line];
    [self addSubview:self.numberLabel];
//    [self addSubview:self.button];
    [self addSubview:self.sureButton];
}

- (void)layoutSubviews {
    __weak typeof(self) weakSelf = self;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(25);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_top);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(@(30));
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_bottom);
        make.left.equalTo(weakSelf.topLabel.mas_left);
        make.right.equalTo(weakSelf.topLabel.mas_right);
        make.height.equalTo(weakSelf.topLabel.mas_height);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(@(1));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.line.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.leftImageV.mas_left);
    }];
    
    CGFloat width = 50;
    CGFloat height = 25;
    for (NSInteger index = 0; index < 4; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        ViewRadius(button, 5.0);
        button.backgroundColor = SetColor(238, 238, 238, 1);
        [button setTitle:[NSString stringWithFormat:@"%ld", index + 1] forState:UIControlStateNormal];
        [button setTitleColor:SetColor(153, 153, 153, 1) forState:UIControlStateNormal];
        button.tag = index + 1000;
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.numberLabel.mas_bottom).offset(10);
            make.left.equalTo(weakSelf.numberLabel.mas_left).offset((20 + width) *index);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
    }
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.height.mas_equalTo(@(44));
    }];
}

- (void)selectAction:(UIButton *)button {
    for (UIButton *btn in self.subviews) {
        if (btn.tag == 300 || btn.class != UIButton.class) {
            continue;
        }
        if (button.tag == btn.tag) {
            btn.backgroundColor = SetColor(252, 174, 59, 1);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if ([_delegate respondsToSelector:@selector(selectNumber:)]) {
                [_delegate selectNumber:button.tag - 1000 + 1];
            }
        }else {
            btn.backgroundColor = SetColor(238, 238, 238, 1);
            [btn setTitleColor:SetColor(153, 153, 153, 1) forState:UIControlStateNormal];
        }
    }
}



@end
