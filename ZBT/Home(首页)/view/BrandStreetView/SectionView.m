//
//  SectionView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/11.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SectionView.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation SectionView

- (instancetype)initWithFrame:(CGRect)frame ItemNumber:(NSInteger)itemNumber AndTitle:(NSArray *)titleArray {
    
    if (self == [super initWithFrame:frame]) {
        [self setUIWithNumberItem:itemNumber AndTitle:titleArray];
    }
    return self;
}

- (void)setUIWithNumberItem:(NSInteger)itemNumber AndTitle:(NSArray *)titleArray {
    CGFloat buttonWidth = (SCREENBOUNDS.width - 30 - (self.bounds.size.height - 20) - 40) / itemNumber;
    for (NSInteger index = 0; index < itemNumber; index++) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = FRAME(15 + (index * (buttonWidth + 10)), 10, buttonWidth, 40);
        
        CGSize imageSize = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiala"]].bounds.size;
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 0, 20)];
        label.text = titleArray[index];
        [label sizeToFit];
        CGSize titleSize = label.bounds.size;
        
        self.button.imageEdgeInsets = UIEdgeInsetsMake(5, titleSize.width-15, 5, -titleSize.width);
        self.button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width);
        
        self.button.titleLabel.font = SetFont(13);
        [self.button setTitleColor:SetColor(103, 103, 103, 1) forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
        [self.button setTitle:titleArray[index] forState:UIControlStateNormal];
        [self addSubview:self.button];
        self.button.tag = index + 200;
        [self.button addTarget:self action:@selector(addAction:withTag:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changeBtn setImage:[UIImage imageNamed:@"pic"] forState:UIControlStateNormal];
    
    [self addSubview:self.changeBtn];
    __weak typeof(self) weakSelf = self;
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-15);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(weakSelf.bounds.size.height - 20, weakSelf.bounds.size.height - 20));
    }];
    
}

- (void)addAction:(UIButton *)sender withTag:(NSInteger)tag {
    for (UIButton *button in self.subviews) {
        if (button.tag == 100) {
            continue;
        }
        if (button.tag == sender.tag) {
            button.selected = !button.isSelected;
            if (button.selected) {
                [button setImage:[UIImage imageNamed:@"xialahou"] forState:UIControlStateNormal];
                [button setTitleColor:SetColor(23, 144, 214, 1) forState:UIControlStateNormal];
            }else {
                [button setTitleColor:SetColor(103, 103, 103, 1) forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
            }
            if ([_delegate respondsToSelector:@selector(touchButton:withTag:)]) {
                [_delegate touchButton:button withTag:button.tag];
            }
        }else {
            button.selected = NO;
            [button setTitleColor:SetColor(103, 103, 103, 1) forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
