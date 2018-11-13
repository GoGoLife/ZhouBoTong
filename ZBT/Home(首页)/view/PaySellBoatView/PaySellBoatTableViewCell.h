//
//  PaySellBoatTableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/2.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySellBoatTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftImg;

@property (nonatomic, strong) UITextField *textF;

@property (nonatomic, strong) UILabel *price;

@property (nonatomic, strong) UITextField *bottomTextF;

@property (nonatomic, assign) BOOL isType;

@end
