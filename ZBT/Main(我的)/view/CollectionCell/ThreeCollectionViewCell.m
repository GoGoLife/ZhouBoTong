//
//  ThreeCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ThreeCollectionViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation ThreeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    
    return self;
}

- (void)setUI {
    self.nameLabel = [[UILabel alloc] init];
//    self.nameLabel.backgroundColor = RandomColor;
    self.nameLabel.font = SetFont(14);
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    self.imgV = [[UIImageView alloc] init];
//    self.imgV.backgroundColor = RandomColor;
    self.imgV.image = [UIImage imageNamed:@"right"];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.imgV];
    
    __weak typeof(self) weakSelf = self;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 20));
    }];
    
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, SCREENBOUNDS.width - 35, 0, 15));
//        make.left.equalTo(self.nameLabel.mas_right);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.mas_equalTo(@(10));
        make.height.mas_equalTo(@(ThreeCellHeight / 4));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.height.mas_equalTo(@(1));
        
    }];
    
}


@end
