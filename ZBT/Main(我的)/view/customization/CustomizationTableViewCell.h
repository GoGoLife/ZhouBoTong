//
//  CustomizationTableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/31.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+LeftRightView.h"

@interface CustomizationTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *topTextF;

@property (nonatomic, strong) UITextField *nameTextF;

@property (nonatomic, strong) UIImageView *leftImageV;

@property (nonatomic, strong) UITextField *priceTextF;

@property (nonatomic, strong) UITextField *infoTextF;

@end
