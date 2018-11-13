//
//  Buy_TwoCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/29.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Buy_TwoCollectionViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation Buy_TwoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.imageV = [[UIImageView alloc] init];
//    self.imageV.backgroundColor = RandomColor;
    self.imageV.image = [UIImage imageNamed:@"public"];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.backgroundColor = [UIColor redColor];
    ViewRadius(self.cancelButton, 8.0);
    
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.cancelButton];
}

- (void)layoutSubviews {
    __weak typeof(self) weakSelf = self;
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.0, 16.0));
        make.centerX.equalTo(weakSelf.contentView.mas_right);
        make.centerY.equalTo(weakSelf.contentView.mas_top);
    }];
}

- (void)setIsShowButton:(BOOL)isShowButton {
    if (isShowButton) {
        self.cancelButton.hidden = YES;
    }else {
        self.cancelButton.hidden = NO;
    }
}

@end
