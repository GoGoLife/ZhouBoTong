//
//  Appointment_infoViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/12.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface Appointment_infoViewController : BaseViewController

/*
 区分售后订单状态
 0   代表未完成
 1   代表已完成
 2   代表待评价
 */
@property (nonatomic, assign) NSInteger orderType;

@property (nonatomic, strong) NSString *yuyue_id;

@property (nonatomic, strong) NSString *imageURL;

@end
