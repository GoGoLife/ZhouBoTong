//
//  SecondSectionView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/23.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SecondButtonDelegate <NSObject>

- (void)touchButton:(UIButton *)button withIndex:(NSInteger)index;

@end

@interface SecondSectionView : UIView

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, weak) id<SecondButtonDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame ItemNumber:(NSInteger)itemNumber AndTitle:(NSArray *)titleArray;

@end
