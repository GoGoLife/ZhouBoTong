//
//  HeaderCollectionReusableView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCollectionReusableView : UICollectionReusableView

//头像
@property (nonatomic, strong) UIImageView *headerImg;

//名称
@property (nonatomic, strong) UILabel *nameLabel;

//显示点击编辑label
@property (nonatomic, strong) UILabel *editLabel;

//认证图片
@property (nonatomic, strong) UIImageView *RZImg;

@end
