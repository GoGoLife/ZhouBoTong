//
//  HistoryCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/13.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "HistoryCollectionViewCell.h"
#import "Globefile.h"

@implementation HistoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.textF = [[UITextField alloc] init];
    self.textF.enabled = NO;
    [self.contentView addSubview:self.textF];
}

- (void)layoutSubviews {
    __weak typeof(self) weakSelf = self;
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
}

- (void)setTextString:(NSString *)textString {
    self.textF.text = [@"   " stringByAppendingString:textString];
}


@end
