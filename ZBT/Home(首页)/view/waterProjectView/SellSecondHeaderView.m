//
//  SellSecondHeaderView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/24.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SellSecondHeaderView.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation SellSecondHeaderView

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
    
    self.bottomLabel = [[UILabel alloc] init];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.textColor = [UIColor redColor];
    
    [self addSubview:self.leftImageV];
    [self addSubview:self.topLabel];
    [self addSubview:self.bottomLabel];
    [self addSubview:self.numberLabel];
    
    CGFloat height = self.bounds.size.height - 20;
    __weak typeof(self) weakSelf = self;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        make.width.mas_equalTo(@(height));
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.top.equalTo(weakSelf.leftImageV.mas_top);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.height.mas_equalTo(@(height / 2));
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.top.equalTo(weakSelf.topLabel.mas_bottom);
        make.right.equalTo(weakSelf.mas_right).offset(-50);
        make.height.mas_equalTo(@(height / 2));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomLabel.mas_top);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.bottomLabel.mas_bottom);
        make.width.mas_equalTo(@(40));
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
