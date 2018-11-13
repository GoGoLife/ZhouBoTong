//
//  FirstCollectionReusableView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/10.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "FirstCollectionReusableView.h"

@interface FirstCollectionReusableView()

@end

@implementation FirstCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.Scroll = [[URLImageScroll alloc] initWithFrame:self.bounds withImageArray:self.dataArray];
//    self.loop = [[LoopView alloc] initWithFrame:self.bounds];
//    self.loop.imageArray = @[@"1", @"2", @"3", @"4"];
    [self addSubview:self.Scroll];
    
}


@end
