//
//  StandardsView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "StandardsView.h"
#import "Globefile.h"
#import <Masonry.h>

@interface StandardsView()

@end

@implementation StandardsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.leftImageV = [[UIImageView alloc] init];
//    self.leftImageV.backgroundColor = RandomColor;
    self.leftImageV.image = [UIImage imageNamed:@"public"];
    
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.textColor = [UIColor redColor];
    self.topLabel.text = @"¥400";
    
    self.bottomTextF = [[UITextField alloc] init];
    self.bottomTextF.enabled = NO;
    self.bottomTextF.textAlignment = NSTextAlignmentLeft;
    self.bottomTextF.textColor = SetColor(164, 164, 164, 1);
    self.bottomTextF.font = SetFont(12);
    self.bottomTextF.text = @"￥200";
    
    self.oneLine = [[UIView alloc] init];
    self.oneLine.backgroundColor = LineColor;
    
    self.colorLabel = [[UILabel alloc] init];
    self.colorLabel.font = SetFont(15);
    self.colorLabel.text = @"颜色";
    
    self.colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.colorButton.backgroundColor = SetColor(238, 238, 238, 1);
    self.colorButton.titleLabel.font = SetFont(14);
    [self.colorButton setTitle:@"蓝白" forState:UIControlStateNormal];
    
    self.twoLine = [[UIView alloc] init];
    self.twoLine.backgroundColor = LineColor;
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.font = SetFont(14);
    self.numberLabel.text = @"购买数量";
    
    //减
    self.subtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.subtractButton.backgroundColor = [UIColor redColor];
    
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.text = @"*1";
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.backgroundColor = [UIColor redColor];
    
    self.addCartsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addCartsButton.titleLabel.font = SetFont(15);
    [self.addCartsButton setTitle:@"加入购物舟" forState:UIControlStateNormal];
    self.addCartsButton.backgroundColor = [UIColor orangeColor];
    
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payButton.titleLabel.font = SetFont(15);
    [self.payButton setTitle:@"确定" forState:UIControlStateNormal];
    self.payButton.backgroundColor = [UIColor redColor];
    
    
    [self addSubview:self.leftImageV];
    [self addSubview:self.topLabel];
    [self addSubview:self.bottomTextF];
    [self addSubview:self.oneLine];
    [self addSubview:self.colorLabel];
    [self addSubview:self.colorButton];
    [self addSubview:self.twoLine];
    [self addSubview:self.numberLabel];
    [self addSubview:self.subtractButton];
    [self addSubview:self.countLabel];
    [self addSubview:self.addButton];
//    [self addSubview:self.addCartsButton];
    [self addSubview:self.payButton];
    
    __weak typeof(self) weakSelf = self;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(25);
        make.left.equalTo(weakSelf.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_top);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-25);
        make.height.mas_equalTo(@(30));
    }];
    
    [self.bottomTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_bottom);
        make.left.equalTo(weakSelf.topLabel.mas_left);
        make.right.equalTo(weakSelf.topLabel.mas_right);
        make.height.equalTo(weakSelf.topLabel.mas_height);
    }];
    
    [self.oneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(@(1));
    }];
    
    [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oneLine.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.leftImageV.mas_left);
    }];
    
    [self.colorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.colorLabel.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.colorLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(55, 25));
    }];
    
    [self.twoLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.colorButton.mas_bottom).offset(15);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(@(1));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.twoLine.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.leftImageV.mas_left);
    }];
    
    [self.subtractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.numberLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(weakSelf.mas_right).offset(-80);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.numberLabel.mas_centerY);
        make.left.equalTo(weakSelf.subtractButton.mas_right);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.numberLabel.mas_centerY);
        make.left.equalTo(weakSelf.countLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
//    [self.addCartsButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.mas_left);
//        make.bottom.equalTo(weakSelf.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(SCREENBOUNDS.width / 2, 44));
//    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREENBOUNDS.width, 44));
    }];
    
    
}

@end
