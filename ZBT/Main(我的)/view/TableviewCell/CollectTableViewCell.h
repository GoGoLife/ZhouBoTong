//
//  CollectTableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CollectCellHeight 110

typedef NS_ENUM(NSInteger, CollectCellType) {
    CollectCellTypeProduct,
    CollectCellTypeStore
};

@protocol DismissCollectDelegate <NSObject>

- (void)dismissCollect:(NSIndexPath *)indexPath;

@end

@interface CollectTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgV;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UITextField *textF;

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) CollectCellType type;

@property (nonatomic, weak) id<DismissCollectDelegate> delegate;

@end
