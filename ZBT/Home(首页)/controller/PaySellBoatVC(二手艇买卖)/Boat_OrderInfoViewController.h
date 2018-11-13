//
//  Boat_OrderInfoViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface Boat_OrderInfoViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *dataDic;

//是否显示配送方式View
@property (nonatomic, assign) BOOL isShowAway;

@property (nonatomic, strong) NSString *number;

@property (nonatomic, strong) NSString *order_type;

//唯有售后服务传值
@property (nonatomic, assign) NSInteger after_type;

@end
