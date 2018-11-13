//
//  OrderTableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/7.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OrderCellHeight 200
#define OrderHeight 140

typedef NS_ENUM(NSInteger, TypeButton) {
    TypeButtonWaitPay = 0,
    TypeButtonWaitSend = 1,
    TypeButtonWaitGet = 2,
    TypeButtonWaitEvaluation = 3,
    TypeButtonDrawBack = 4,
    TypeButtonUnknow = 5
};

@interface OrderTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *topRightString;;

@property (nonatomic, strong) UIImageView *orderImg;

//名字
@property (nonatomic, strong) UITextField *nameTextF;

//规格
@property (nonatomic, strong) UITextField *standerdTextF;

//合计
@property (nonatomic, strong) UILabel     *totalLabel;

@property (nonatomic, strong) UIButton    *typeButton;

@property (nonatomic, strong) UIButton    *typeButton1;

@property (nonatomic, assign) BOOL       isShowTypeButton;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) TypeButton type;

@end
