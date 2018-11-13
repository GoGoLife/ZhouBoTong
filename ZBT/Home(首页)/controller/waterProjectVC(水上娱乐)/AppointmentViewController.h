//
//  AppointmentViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/24.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface AppointmentViewController : BaseViewController

@property (nonatomic, assign) BOOL isWharfGOVC;

@property (nonatomic, strong) NSDictionary *currentDataDic;

@property (nonatomic, strong) NSString *number;

@end
