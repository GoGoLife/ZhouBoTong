//
//  LocationViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/14.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface LocationViewController : BaseViewController

@property (nonatomic, copy) void(^returnCityName)(NSString *city);

@end
