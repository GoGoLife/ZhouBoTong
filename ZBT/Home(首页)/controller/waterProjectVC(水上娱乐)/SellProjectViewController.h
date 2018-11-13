//
//  SellProjectViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/24.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "SellHeaderView.h"
#import "CustomTableViewCell.h"
#import "Globefile.h"
#import "LoopView.h"

@interface SellProjectViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isWharfGoVC;

@property (nonatomic, strong) SellHeaderView *SellView;

@property (nonatomic, strong) NSString *SellHeaderTopString;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *serve_id;

@property (nonatomic, strong) NSString *commission_id;

@property (nonatomic, strong) NSString *train_type_id;

@property (nonatomic, strong) NSDictionary *dataDic;

@end
