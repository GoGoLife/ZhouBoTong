//
//  ShoppingListViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/7/26.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface ShoppingListViewController : BaseViewController

@property (nonatomic, strong) NSArray *firstShoppingArray;

@property (nonatomic, strong) NSArray *dataModel;

//记录商家ID  用来区分商品
@property (nonatomic, strong) NSArray *merchantArr;

//付款总金额
@property (nonatomic, strong) NSString *sum_price;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *remark;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, assign) BOOL isChooseAddress;

@property (nonatomic, assign) NSInteger sex;

//区分是实物类型订单 1   服务类型订单 2
@property (nonatomic, strong) NSString *order_type;

@property (nonatomic, strong) NSString *number;

#pragma mark ------ 个人购买
@property (nonatomic, strong) NSString *buy_id;

@property (nonatomic, strong) NSString *order_price;

//唯有售后服务传值
@property (nonatomic, assign) NSInteger after_type;

@end
