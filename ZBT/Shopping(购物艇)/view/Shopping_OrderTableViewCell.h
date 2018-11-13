//
//  Shopping_OrderTableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/6.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ShoppingCellHeight 100.0

@protocol SelectCellDelegate<NSObject>

- (void)selectedCellIndexPath:(NSIndexPath *)indexPath AndChoose:(BOOL)isChoose;

- (void)addNumber:(NSIndexPath *)indexPath;

- (void)lessNumber:(NSIndexPath *)indexPath;

@end

@interface Shopping_OrderTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UIImageView *leftImageV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *lessesButton;

//商品数量
@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIButton *addButton;

//具体数量
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, assign) BOOL isMoved;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak)id<SelectCellDelegate> delegate;

@end
