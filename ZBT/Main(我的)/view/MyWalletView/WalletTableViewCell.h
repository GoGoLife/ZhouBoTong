//
//  WalletTableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/12.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WalletCellHeight 80

@interface WalletTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@end
