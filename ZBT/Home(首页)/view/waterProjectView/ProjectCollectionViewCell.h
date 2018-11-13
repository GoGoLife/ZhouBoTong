//
//  ProjectCollectionViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/23.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+LeftRightView.h"

@interface ProjectCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *leftImageV;

@property (nonatomic, strong) UITextField *topTextF;

@property (nonatomic, strong) UITextField *centerTextF;

@property (nonatomic, strong) UITextField *bottomTextF;

@property (nonatomic, strong) NSString *topLeftString;

@property (nonatomic, strong) NSString *topRightString;

@property (nonatomic, strong) NSString *centerLeftString;

@property (nonatomic, strong) NSString *centerRightString;

@property (nonatomic, strong) NSString *bottomLeftString;

@property (nonatomic, strong) NSString *bottomRightString;

@end
