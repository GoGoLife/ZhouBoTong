//
//  ChangeSexView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/24.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangSexDelegate <NSObject>
- (void)returnSexIndex:(NSInteger)index;
@end

@interface ChangeSexView : UIView

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, weak) id<ChangSexDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withNumber:(NSInteger)number titleArray:(NSArray *)titleArr;

@end
