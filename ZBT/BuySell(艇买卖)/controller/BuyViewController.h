//
//  BuyViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/29.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "Buy_OneCollectionViewCell.h"
#import "Buy_TwoCollectionViewCell.h"

@interface BuyViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSString *titleString;

@property (nonatomic, assign) BOOL isShowSecond;

//底部button显示文字
@property (nonatomic, strong) NSString *buttonTitle;

//描述信息
@property (nonatomic, strong) NSString *describeString;

@end
