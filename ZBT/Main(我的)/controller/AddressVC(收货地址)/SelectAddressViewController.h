//
//  SelectAddressViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface SelectAddressViewController : BaseViewController

@property (nonatomic, copy) void(^returnAddress)(NSString *string, NSString *name, NSString *phone);

@end
