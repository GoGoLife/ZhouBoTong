//
//  BindPhoneViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/7/23.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface BindPhoneViewController : BaseViewController

@property (nonatomic, strong) NSString *WX_id;

@property (nonatomic, strong) NSString *QQ_id;

//1：QQ  2：微信
@property (nonatomic, assign) NSInteger type;

@end
