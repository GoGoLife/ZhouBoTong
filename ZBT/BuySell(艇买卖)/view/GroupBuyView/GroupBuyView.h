//
//  GroupBuyView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/14.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupBuyView : UIView

@property (nonatomic, strong) UITextField *topTextF;

@property (nonatomic, strong) UITextField *priceTextF;

@property (nonatomic, strong) UITextField *dateTextF;

@property (nonatomic, strong) UILabel     *remarkLabel;

@property (nonatomic, strong) NSString    *priceLeftString;

@property (nonatomic, strong) NSString    *dateLeftString;

@property (nonatomic, strong) NSString    *dateRightString;

@property (nonatomic, assign) BOOL         isNewLayout;

//收藏
@property (nonatomic, strong) UIButton *collectBtn;

@property (nonatomic, strong) UIButton *shareBtn;

@end
