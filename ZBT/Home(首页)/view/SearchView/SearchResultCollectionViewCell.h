//
//  SearchResultCollectionViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/13.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ResultCellHeight 80

@interface SearchResultCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *leftImageV;

@property (nonatomic, strong) UITextField *topTextF;

@property (nonatomic, strong) UITextField *bottomTextF;

@end
