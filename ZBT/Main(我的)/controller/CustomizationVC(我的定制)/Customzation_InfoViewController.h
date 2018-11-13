//
//  Customzation_InfoViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BuyViewController.h"

@interface Customzation_InfoViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *button;

//买卖信息ID    用于获取个人发布的我要买的详情信息
@property (nonatomic, strong) NSString *sell_id;

//用于获取个人发布的我要卖的详情信息
@property (nonatomic, strong) NSString *buy_id;

//用于获取定制服务的详细信息
@property (nonatomic, strong) NSString *serve_id;

//用来存储详情数据
@property (nonatomic, strong) NSDictionary *dataDic;

//是否显示价格
@property (nonatomic, assign) BOOL isShowPrice;

@end
