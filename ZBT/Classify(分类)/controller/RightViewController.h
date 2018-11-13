//
//  RightViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/9.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightViewController : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSString *category_name;

- (void)getSecondCategoryFromTopCategory:(NSString *)category_id;

@end
