//
//  CreatShoppingOrderViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/7/27.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface CreatShoppingOrderViewController : BaseViewController

@property (nonatomic, strong) NSArray *firstShoppingArray;

@property (nonatomic, strong) NSArray *dataModel;

//记录商家ID  用来区分商品
@property (nonatomic, strong) NSArray *merchantArr;

//付款总金额
@property (nonatomic, strong) NSString *sum_price;

@end
