//
//  Edit_InfoViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/8/28.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface Edit_InfoViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSDictionary *dataDic;

//发布类型    1 === 我要买    2 === 我要卖
@property (nonatomic, assign) NSInteger publish_type;

@end
