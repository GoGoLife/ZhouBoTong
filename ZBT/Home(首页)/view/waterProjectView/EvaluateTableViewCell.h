//
//  EvaluateTableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/23.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

//评价Cell

#import <UIKit/UIKit.h>

@interface EvaluateTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headerImageV;

@property (nonatomic, strong) UITextField *topTextF;

@property (nonatomic, strong) NSString *topRightString;

@property (nonatomic, strong) UILabel *remarkLabel;

@property (nonatomic, strong) NSString *remarkString;

@property (nonatomic, strong) UIImageView *bottomImageV;

@property (nonatomic, strong) NSArray *imageArray;

- (CGFloat)cellHeight:(NSString *)string WithFont:(NSInteger)fontSize;

@end
