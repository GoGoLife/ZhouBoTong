//
//  GroupBuyView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/14.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "GroupBuyView.h"
#import "Globefile.h"
#import "UITextField+LeftRightView.h"
#import <Masonry.h>

@interface GroupBuyView()<UITextFieldDelegate>

@end

@implementation GroupBuyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.topTextF = [[UITextField alloc] init];
    self.topTextF.delegate = self;
//    self.topTextF.enabled = NO;
    self.topTextF.text = @"Marquis yachts.LLC.USA";
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.shareBtn.frame = FRAME(0, 0, 60, 20);
    self.shareBtn.titleLabel.font = SetFont(12);
    [self.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [self.shareBtn setBackgroundColor:[UIColor redColor]];
    ViewRadius(self.shareBtn, 10.0);
    
    
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectBtn.frame = FRAME(0, 0, 60, 20);
    self.collectBtn.titleLabel.font = SetFont(12);
    [self.collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectBtn setBackgroundColor:[UIColor redColor]];
    ViewRadius(self.collectBtn, 10.0);
    [self.topTextF creatRightView:self.collectBtn.frame AndControl:self.collectBtn];
    
    
    
    self.priceTextF = [[UITextField alloc] init];
    self.priceTextF.enabled = NO;
    self.priceTextF.font = SetFont(12);
    
    self.dateTextF = [[UITextField alloc] init];
    self.dateTextF.enabled = NO;
//    self.dateTextF.text = @"2018-3-12 至 2018-12-12";
    
    
    self.remarkLabel = [[UILabel alloc] init];
//    self.remarkLabel.textColor = [UIColor redColor];
//    self.remarkLabel.text = @"注：团购未成功，款会按照原路径返还给用户";
    
    [self addSubview:self.topTextF];
    [self addSubview:self.shareBtn];
    [self addSubview:self.priceTextF];
    [self addSubview:self.dateTextF];
    [self addSubview:self.remarkLabel];
    
    __weak typeof(self) weakSelf = self;
    [self.topTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left).offset(15);
        make.right.equalTo(weakSelf.mas_right).offset(-85);
        make.height.mas_equalTo(@(weakSelf.bounds.size.height / 3));
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.topTextF.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [self.priceTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topTextF.mas_bottom);
        make.left.equalTo(weakSelf.topTextF.mas_left);
        make.right.equalTo(weakSelf.topTextF.mas_right);
        make.height.mas_equalTo(@(weakSelf.bounds.size.height / 3));
    }];
    
    CGFloat height = self.bounds.size.height / 3 / 2;
    [self.dateTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.priceTextF.mas_bottom);
        make.left.equalTo(weakSelf.topTextF.mas_left);
        make.right.equalTo(weakSelf.topTextF.mas_right);
        make.height.mas_equalTo(@(height));
    }];
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.dateTextF.mas_bottom);
        make.left.equalTo(weakSelf.topTextF.mas_left);
        make.right.equalTo(weakSelf.topTextF.mas_right);
        make.height.mas_equalTo(@(height));
    }];
    
}

- (void)setIsNewLayout:(BOOL)isNewLayout {
    if (isNewLayout) {
        __weak typeof(self) weakSelf = self;
        CGFloat height = self.bounds.size.height / 3;
        [self.priceTextF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.topTextF.mas_bottom);
            make.left.equalTo(weakSelf.topTextF.mas_left);
            make.right.equalTo(weakSelf.topTextF.mas_right);
            make.height.mas_equalTo(@(height));
        }];
        
        [self.dateTextF mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(0));
        }];
        
        [self.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.priceTextF.mas_bottom);
            make.left.equalTo(weakSelf.topTextF.mas_left);
            make.right.equalTo(weakSelf.topTextF.mas_right);
            make.height.mas_equalTo(@(height / 2));
        }];
    }
}

- (void)setPriceLeftString:(NSString *)priceLeftString {
    [self.priceTextF creatLeftView:FRAME(0, 0, [self calculateRowWidth:priceLeftString withFont:17] + 20, 40) AndTitle:priceLeftString TextAligment:NSTextAlignmentLeft Font:SetFont(17) Color:[UIColor redColor]];
}

- (void)setDateLeftString:(NSString *)dateLeftString {
    [self.dateTextF creatLeftView:FRAME(0, 0, [self calculateRowWidth:dateLeftString withFont:15], 40) AndTitle:dateLeftString TextAligment:NSTextAlignmentCenter Font:SetFont(15) Color:[UIColor redColor]];
}

- (void)setDateRightString:(NSString *)dateRightString {
    [self.dateTextF creatRightView:FRAME(0, 0, [self calculateRowWidth:dateRightString withFont:12], 20) AndTitle:dateRightString TextAligment:NSTextAlignmentCenter Font:SetFont(12) Color:[UIColor redColor]];
}

StringWidth();

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
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
