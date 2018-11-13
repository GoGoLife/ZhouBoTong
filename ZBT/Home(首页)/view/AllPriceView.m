//
//  AllPriceView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AllPriceView.h"
#import "Globefile.h"
#import <Masonry.h>

@interface AllPriceView()

@property (nonatomic, strong) UILabel *label;

@end

@implementation AllPriceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)creatUI {
    self.label = [[UILabel alloc] init];
    self.label.textColor = SetColor(78, 78, 78, 1);
    self.label.font = SetFont(13);
    self.label.text = @"合计金额";
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textColor = [UIColor redColor];
    
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payButton setTitle:@"立刻购买" forState:UIControlStateNormal];
    self.payButton.backgroundColor = [UIColor redColor];
    
    [self addSubview:self.label];
    [self addSubview:self.priceLabel];
    [self addSubview:self.payButton];
}

- (void)layoutSubviews {
    
}


@end
