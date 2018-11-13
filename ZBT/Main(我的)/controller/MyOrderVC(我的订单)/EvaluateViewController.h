//
//  EvaluateViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/28.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface EvaluateViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *dataDic;

//传递预约的Image
@property (nonatomic, strong) NSString *imageURL;

//区分是实物类评价   还是预约类评价   1 == 实物类   2 === 预约类
@property (nonatomic, assign) NSInteger orderType;

@end
