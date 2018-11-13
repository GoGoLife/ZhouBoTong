//
//  First_usedCollectionViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/25.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface First_usedCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) BOOL isSelect;

//记录cell的位置
@property (nonatomic, strong) NSIndexPath  *indexPath;

@end
