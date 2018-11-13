//
//  MarchantListViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "MarchantListTableViewCell.h"
#import "Globefile.h"

@interface MarchantListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

//数据
@property (nonatomic, strong) NSArray *dataArray;

//通过分类ID获取包含分类的商家商品信息
@property (nonatomic, strong) NSString *categoryID;

@property (nonatomic, assign) BOOL isWharfGoVC;

@property (nonatomic, strong) UITableView *tableView;

@end
