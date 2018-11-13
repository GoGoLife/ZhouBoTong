//
//  URLImageScroll.h
//  ZBT
//
//  Created by 钟文斌 on 2018/8/28.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol URLImageTouchIndexDelegate <NSObject>

- (void)TouchImageIndexWithAction:(NSInteger) index;

@end

@interface URLImageScroll : UIView

- (instancetype)initWithFrame:(CGRect)frame withImageArray:(NSArray *)array;

@property (nonatomic, strong) NSArray *URLImageArr;

@property (nonatomic, weak) id<URLImageTouchIndexDelegate> delegate;

@end
