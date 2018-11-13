//
//  SecondCollectionReusableView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/10.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SecondCollectionReusableView.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation SecondCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(push)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setUI {
    self.textF = [[UITextField alloc] init];
    self.textF.font = SetFont(14);
    self.textF.text = @"    热门艇";
    self.textF.enabled = NO;
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 3, self.bounds.size.height / 2)];
//    leftImg.backgroundColor = RandomColor;
    leftImg.image = [UIImage imageNamed:@"biaoji"];
    
    self.textF.leftView = leftImg;
    self.textF.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *gengduo = [UIButton buttonWithType:UIButtonTypeCustom];
    gengduo.frame = FRAME(0, 0, 100, 30);
    
    CGSize imageSize = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gengduo"]].bounds.size;
    self.label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 0, 20)];
    self.label.text = @"更多";
    [self.label sizeToFit];
    CGSize titleSize = self.label.bounds.size;
    
    gengduo.imageEdgeInsets = UIEdgeInsetsMake(7, titleSize.width + 5, 7, -titleSize.width - 5);
    gengduo.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width);
    gengduo.titleLabel.font = SetFont(15);
    [gengduo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gengduo setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    [gengduo setTitle:@"更多" forState:UIControlStateNormal];
    
    self.textF.rightView = gengduo;
    self.textF.rightViewMode = UITextFieldViewModeAlways;
    
    [self addSubview:self.textF];
    __weak typeof(self) weakSelf = self;
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
}

- (void)push {
    if ([_delegate respondsToSelector:@selector(pushIndexVC:)]) {
        [_delegate pushIndexVC:self.indexPath];
    }
}


@end
