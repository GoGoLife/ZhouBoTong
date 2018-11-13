//
//  CustomTableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+LeftRightView.h"

#define InfoCellHeight 60

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *textF;

@property (nonatomic, strong) NSString *leftString;

@property (nonatomic, strong) NSString *rightString;

@property (nonatomic, assign) BOOL isNewLayout;

@end
