//
//  Publish_infoViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/12.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Customzation_InfoViewController.h"

@interface Publish_infoViewController : Customzation_InfoViewController

@property (nonatomic, assign) BOOL isShowBottomView;

//发布类型    1 === 我要买    2 === 我要卖
@property (nonatomic, assign) NSInteger publish_type;

@property (nonatomic, assign) BOOL isEdit;

@end
