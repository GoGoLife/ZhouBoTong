//
//  OrderInfoViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/7.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderInfoViewController : BaseViewController

@property (nonatomic, strong) NSString *order_id;

//区分是什么cell  付款，  评价等
@property (nonatomic, assign) NSInteger cellType;

@property (nonatomic, strong) NSDictionary *orderInfoDic;

@end
