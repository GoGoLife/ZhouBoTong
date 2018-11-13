//
//  CustomSearchView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/22.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSearchViewDelegate<NSObject>

- (void)touchSearchBar;

@end

@interface CustomSearchView : UIView

@property (nonatomic, strong) UISearchBar *search;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIButton *addBtn;

- (instancetype)initWithFrame:(CGRect)frame isShowAdd:(BOOL)isShowAdd;

@property (nonatomic, weak)id<CustomSearchViewDelegate> delegate;

@end
