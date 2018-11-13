//
//  First_usedCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/25.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "First_usedCollectionViewCell.h"
#import "Globefile.h"

@implementation First_usedCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        ViewRadius(self.contentView, self.bounds.size.height / 2);
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.textColor = SetColor(88, 88, 88, 1);
        self.label.font = SetFont(12);
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)setIsSelect:(BOOL)isSelect {
    if (isSelect) {
        self.contentView.backgroundColor = SetColor(67, 165, 249, 1);
    }else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}



@end
