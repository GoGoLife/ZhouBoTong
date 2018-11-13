//
//  CustomSearchView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/22.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "CustomSearchView.h"
#import <Masonry.h>
#import "Globefile.h"

@interface CustomSearchView()<UISearchBarDelegate>
@property (nonatomic, strong) UIView *line;
@end

@implementation CustomSearchView

- (instancetype)initWithFrame:(CGRect)frame isShowAdd:(BOOL)isShowAdd {
    if (self == [super initWithFrame:frame]) {
        if (isShowAdd) {
            [self creatShowAddUI];
        }else {
            [self creatUI];
        }
        self.backgroundColor = [UIColor whiteColor];
        ViewRadius(self, self.bounds.size.height / 2);
    }
    return self;
}

- (void)creatUI {
    self.search = [[UISearchBar alloc] init];
//    self.search.backgroundColor = [UIColor redColor];
    self.search.delegate = self;
    self.search.placeholder = @"可搜索各种游艇";
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = SetColor(239, 239, 239, 1);
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 45);
    self.button.titleEdgeInsets = UIEdgeInsetsMake(5, -30, 5, 0);
    [self.button setImage:[UIImage imageNamed:@"weizhi"] forState:UIControlStateNormal];
    [self.button setTitle:@"杭州" forState:UIControlStateNormal];
    self.button.titleLabel.font = SetFont(12);
    [self.button setTitleColor:SetColor(113, 113, 113, 1) forState:UIControlStateNormal];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    
    
    [self addSubview:self.search];
    [self addSubview:self.line];
    [self addSubview:self.button];
    [self addSubview:self.addBtn];
    
    CGFloat width = (self.bounds.size.width - 20) / 4;
    __weak typeof(self) weakSelf = self;
    [self.search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.width.mas_equalTo(@(width * 3));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(5);
        make.left.equalTo(weakSelf.search.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-5);
        make.width.mas_equalTo(@(1));
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.line.mas_right).offset(15);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.height.mas_equalTo(@(weakSelf.bounds.size.height / 2));
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.button.mas_right).offset(0);
        //            make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo(@(0));
        make.height.mas_equalTo(@(weakSelf.bounds.size.height / 2));
    }];
}

- (void)creatShowAddUI {
    self.search = [[UISearchBar alloc] init];
    //    self.search.backgroundColor = [UIColor redColor];
    self.search.placeholder = @"可搜索各种游艇";
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = SetColor(239, 239, 239, 1);
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 45);
    self.button.titleEdgeInsets = UIEdgeInsetsMake(5, -30, 5, 0);
    [self.button setImage:[UIImage imageNamed:@"weizhi"] forState:UIControlStateNormal];
    [self.button setTitle:@"杭州" forState:UIControlStateNormal];
    self.button.titleLabel.font = SetFont(15);
    [self.button setTitleColor:SetColor(113, 113, 113, 1) forState:UIControlStateNormal];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    
    
    [self addSubview:self.search];
    [self addSubview:self.line];
    [self addSubview:self.button];
    [self addSubview:self.addBtn];
    CGFloat width1 = (self.bounds.size.width) / 3;

    __weak typeof(self) weakSelf = self;
    [self.search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.width.mas_equalTo(@(width1 * 2));
    }];

    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(5);
        make.left.equalTo(weakSelf.search.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-5);
        make.width.mas_equalTo(@(1));
    }];

    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.line.mas_right).offset(1);
//            make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo(@((width1 - 1) / 3 * 2));
        make.height.mas_equalTo(@(weakSelf.bounds.size.height / 2));
    }];

    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.button.mas_right).offset(0);
        //            make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo(@((width1 - 1) / 3));
        make.height.mas_equalTo(@(weakSelf.bounds.size.height));
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if ([_delegate respondsToSelector:@selector(touchSearchBar)]) {
        [_delegate touchSearchBar];
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
