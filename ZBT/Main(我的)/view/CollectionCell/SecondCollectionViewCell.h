//
//  SecondCollectionViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SecondCellHeight (SCREENBOUNDS.width - 70) / 5

@interface SecondCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UILabel     *nameLabel;

@end
