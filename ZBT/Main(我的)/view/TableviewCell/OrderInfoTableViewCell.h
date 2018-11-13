//
//  OrderInfoTableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OrderInfoCellHeight 60

@interface OrderInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgV;

@property (nonatomic, strong) UITextField *topInfoTextF;

@property (nonatomic, strong) UITextField *bottomInfoTextF;

@property (nonatomic, strong) NSString *topLeftStr;

@property (nonatomic, strong) NSString *topRightStr;

@property (nonatomic, strong) NSString *bottomLeftStr;

@property (nonatomic, strong) NSString *bottomRightStr;

@end
