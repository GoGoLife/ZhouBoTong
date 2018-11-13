//
//  Boat_footerView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BoatFooterWayDelegate<NSObject>

- (void)getWayIndex:(NSInteger)index;

@end

@interface Boat_footerView : UIView

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UIButton *firstBtn;

@property (nonatomic, strong) UIButton *secondBtn;

@property (nonatomic, weak) id<BoatFooterWayDelegate> delegate;

@end
