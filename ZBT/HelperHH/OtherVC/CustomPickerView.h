//
//  CustomPickerView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/17.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPickerView : UIView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) void(^returnSelectData)(NSArray *arr);

@end
