//
//  EquipmentInfoViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/15.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "AddCartsView.h"
#import "GroupBuyView.h"
#import "EquipmentTableViewCell.h"
#import "Globefile.h"
#import "UITextField+LeftRightView.h"
#import "LoopView.h"
#import "PlayVideo_TableViewCell.h"

@interface EquipmentInfoViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AddCartsView *addView;

//获取商家发布的商品详情
@property (nonatomic, strong) NSString *goods_id;

@property (nonatomic, strong) NSDictionary *dataDic;

//判断是船舶设备      或者      售后服务
@property (nonatomic, assign) NSInteger type;

- (void)removeButtonTarget;

@end
