//
//  BrandListViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "MineTableViewCell.h"

@interface BrandListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSString *category_top_id;

@end
