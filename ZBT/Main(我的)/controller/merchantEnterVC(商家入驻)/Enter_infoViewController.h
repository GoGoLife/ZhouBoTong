//
//  Enter_infoViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/19.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomTableViewCell.h"

@interface Enter_infoViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *leftTitleArray;

@property (nonatomic, strong) NSArray *placeholderArray;

//用于判断申请加盟的type
@property (nonatomic, assign) NSInteger type;

@end
