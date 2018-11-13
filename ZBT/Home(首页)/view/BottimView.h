//
//  BottimView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/2.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectNumberDelegate<NSObject>

- (void)selectNumber:(NSInteger)number;

@end

@interface BottimView : UIView

@property (nonatomic, strong) UIImageView *leftImageV;

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, weak) id<SelectNumberDelegate> delegate;


@end
