//
//  ScrollTextView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/8/29.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollTextView : UIView

- (instancetype)initWithFrame:(CGRect)frame whitTextArray:(NSArray *)array;

@property (nonatomic, strong) NSArray *titleArray;

@end
