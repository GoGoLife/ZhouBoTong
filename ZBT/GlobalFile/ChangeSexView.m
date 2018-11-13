//
//  ChangeSexView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/24.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ChangeSexView.h"
#import <Masonry.h>
#import "Globefile.h"

@implementation ChangeSexView

- (instancetype)initWithFrame:(CGRect)frame withNumber:(NSInteger)number titleArray:(NSArray *)titleArr {
    if (self == [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self creatUI:number titleArray:titleArr];
    }
    return self;
}

- (void)creatUI:(NSInteger)number titleArray:(NSArray *)titleArr {
    CGFloat width = self.bounds.size.width / number;
    CGFloat height = self.bounds.size.height;
    for (NSInteger index = 0; index < number; index++) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setTitleColor:Color176 forState:UIControlStateNormal];
        self.button.titleLabel.font = SetFont(14);
        [self.button setImage:[UIImage imageNamed:@"xingbie1"] forState:UIControlStateNormal];
        [self.button setTitle:titleArr[index] forState:UIControlStateNormal];
        self.button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        self.button.tag = index + 300;
        [self.button addTarget:self action:@selector(chooseSexIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        
        __weak typeof(self) weakSelf = self;
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).offset(index * width);
            make.top.equalTo(weakSelf.mas_top);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
    }
}

- (void)chooseSexIndex:(UIButton *)sender {
    for (UIButton *button in self.subviews) {
        if (sender.tag == button.tag) {
            [button setImage:[UIImage imageNamed:@"xingbie2"] forState:UIControlStateNormal];
            if ([_delegate respondsToSelector:@selector(returnSexIndex:)]) {
                [_delegate returnSexIndex:sender.tag - 300];
            }
        }else {
            [button setImage:[UIImage imageNamed:@"xingbie1"] forState:UIControlStateNormal];
        }
    }
}

@end
