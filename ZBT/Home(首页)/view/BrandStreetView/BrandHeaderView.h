//
//  BrandHeaderView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/11.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HeaderHeight 100

@interface BrandHeaderView : UIView

@property (nonatomic, strong) UIImageView *leftV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *collectButton;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@end
