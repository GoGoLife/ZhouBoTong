//
//  SearchResultCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/13.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SearchResultCollectionViewCell.h"
#import "Globefile.h"

@implementation SearchResultCollectionViewCell

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
    
    self.bottomTextF = [[UITextField alloc] init];
    self.bottomTextF.enabled = NO;
    
    [self.contentView addSubview:self.leftImageV];
    [self.contentView addSubview:self.topTextF];
    [self.contentView addSubview:self.bottomTextF];
}

- (void)layoutSubviews {
    CGFloat width = ResultCellHeight - 20;
    __weak typeof(self) weakSelf = self;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];
    
    [self.topTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_top);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@(width / 2));
    }];
    
    [self.bottomTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topTextF.mas_bottom);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@(width / 2));
    }];
}

@end
