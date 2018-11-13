//
//  CustomCollectionViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/31.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeaveMessageDelegate<NSObject>

- (void)touchLeaveMessageButton;

@end

@interface CustomCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *leftImageV;

@property (nonatomic, strong) UITextField *topTextF;

@property (nonatomic, strong) UILabel *centerLabel;

@property (nonatomic, strong) UITextField *bottomTextF;

@property (nonatomic, weak) id<LeaveMessageDelegate> delegate;

//留言
@property (nonatomic, strong) UIButton *button;



@end
