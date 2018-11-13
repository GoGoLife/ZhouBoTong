//
//  GroupBuy_infoViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/28.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "HotYachtViewController.h"
#import "AddCartsView.h"
#import "CustomTableViewCell.h"
#import "GroupBuyView.h"

@interface GroupBuy_infoViewController : HotYachtViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AddCartsView *addV;

@property (nonatomic, strong) GroupBuyView *GroupHeaderView;

@property (nonatomic, strong) NSString *group_id;

@end
