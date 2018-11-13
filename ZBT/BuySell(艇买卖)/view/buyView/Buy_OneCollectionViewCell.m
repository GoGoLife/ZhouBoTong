//
//  Buy_OneCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/29.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Buy_OneCollectionViewCell.h"
#import <Masonry.h>
#import "Globefile.h"

@interface Buy_OneCollectionViewCell()

@property (nonatomic, strong) UIView *line;

@end

@implementation Buy_OneCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creatUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)creatUI {
    self.TextF = [[UITextField alloc] init];
    self.TextF.textAlignment = NSTextAlignmentRight;
    self.TextF.font = SetFont(15);

    self.line = [[UIView alloc] init];
    self.line.backgroundColor = BaseViewColor;
    
    [self.contentView addSubview:self.TextF];
    [self.contentView addSubview:self.line];
}

- (void)layoutSubviews {
    __weak typeof(self) weakSelf = self;
    [self.TextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 15, 1, 15));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.TextF.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(@(1));
    }];
}

StringWidth();

- (void)setLeftString:(NSString *)leftString {
    [self layoutIfNeeded];
    CGFloat width = [self calculateRowWidth:leftString withFont:15];
    CGFloat height = self.contentView.bounds.size.height;
    [self.TextF creatLeftView:FRAME(0, 0, width, height) AndTitle:leftString TextAligment:NSTextAlignmentLeft Font:SetFont(15) Color:[UIColor blackColor]];
}

@end
