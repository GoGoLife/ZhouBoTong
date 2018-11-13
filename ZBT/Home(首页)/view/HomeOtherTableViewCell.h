//
//  HomeOtherTableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#define OtherCellHeight 100.0

@protocol callPhoneDelegate<NSObject>

- (void)callPhoneWithPhoneTitle:(NSIndexPath *)indexPath;

@end

@interface HomeOtherTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) UILabel *centerLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UIImageView *rightImageV;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<callPhoneDelegate> delegate;

@end
