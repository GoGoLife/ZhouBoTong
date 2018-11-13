//
//  WaterProjectViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/23.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeCollectionViewCell.h"
#import "ProjectCollectionViewCell.h"
#import "Globefile.h"

@interface WaterProjectViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

//是否是码头出行跳转    yes代表是
@property (nonatomic, assign) BOOL isWharfGoVC;

//顶级分类ID   用来获取顶级分类下的二级分类
@property (nonatomic, strong) NSString *category_id;

//第二个section数据
@property (nonatomic, strong) NSString *topLeftString;

@property (nonatomic, strong) NSString *topText;

@property (nonatomic, strong) NSString *topRightString;

@property (nonatomic, strong) NSString *centerLeftString;

@property (nonatomic, strong) NSString *centerText;

@property (nonatomic, strong) NSString *centerRightString;

@property (nonatomic, strong) NSString *bottomLeftString;

@property (nonatomic, strong) NSString *bottomText;

@property (nonatomic, strong) NSString *bottomRightString;

//二级分类
@property (nonatomic, strong) NSArray *categoryArray;

//轮播图数据   分类
@property (nonatomic, assign) NSInteger type;


@end
