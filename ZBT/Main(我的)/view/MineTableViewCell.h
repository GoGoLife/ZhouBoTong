//
//  MineTableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/7.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+LeftRightView.h"

#define MineCellHeight 110.0

@interface MineTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftImageV;

@property (nonatomic, strong) UITextField *topTextF;

@property (nonatomic, strong) UITextField *centerTextF;

@property (nonatomic, strong) UITextField *bottomTextF;

@property (nonatomic, assign) CGFloat CellHeight;

@end
