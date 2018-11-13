//
//  HomeCollectionViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/10.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *topImageV;

@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UILabel *infoLabel;

//是否是圆形图片
@property (nonatomic, assign) BOOL isCircle;

//是否是新布局
@property (nonatomic, assign) BOOL isNewLayout;
@end
