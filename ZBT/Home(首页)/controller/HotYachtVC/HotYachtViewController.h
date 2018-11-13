//
//  HotYachtViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/14.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "SectionView.h"
#import "FirstBrandCollectionViewCell.h"
#import "SecondBarndCollectionViewCell.h"

@interface HotYachtViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) SectionView *sectionV;

@property (nonatomic, assign) BOOL         isChangeCellType;

@property (nonatomic, strong) NSString *secondCategory_id;

@property (nonatomic, strong) NSArray *serviceList;

//判断是是否是轮播图点击过来的
@property (nonatomic, assign) BOOL isSelectWheel;

//通过商家ID获取售后服务列表
@property (nonatomic, strong) NSString *merchant_id;

//通过二级分类ID获取到的数据
@property (nonatomic, strong) NSArray *secondCategoryGoodsArray;

@end
