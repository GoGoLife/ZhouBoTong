//
//  ProjectInfoViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/23.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface ProjectInfoViewController : BaseViewController

@property (nonatomic, assign) BOOL isWharfGoVC;

//立即预约按钮
@property (nonatomic, strong) UIButton *button;

- (void)removeTarget;

@property (nonatomic, strong) NSString *merchant_id;

@end
