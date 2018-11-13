//
//  MarchantListTableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MARCHANTLISTCELLHEIGHT 110.0

@interface MarchantListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *marchantLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UITextField *bottomTextF;

@end
