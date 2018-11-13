//
//  SecondCollectionReusableView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/10.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PushIndexDelegate <NSObject>

- (void)pushIndexVC:(NSIndexPath *)indexPath;

@end


@interface SecondCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UITextField *textF;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<PushIndexDelegate> delegate;

@property (nonatomic, strong) UILabel *label;

@end
