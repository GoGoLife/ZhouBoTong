//
//  SectionView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/11.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonDelegate <NSObject>
- (void)touchButton:(UIButton *)button withTag:(NSInteger)tag;
@end

@interface SectionView : UIView
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *changeBtn;

@property (nonatomic, weak) id<ButtonDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame ItemNumber:(NSInteger)itemNumber AndTitle:(NSArray *)titleArray;
@end
