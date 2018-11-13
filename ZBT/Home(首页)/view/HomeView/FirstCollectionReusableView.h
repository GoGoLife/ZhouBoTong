//
//  FirstCollectionReusableView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/10.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoopView.h"
#import "URLImageScroll.h"

@interface FirstCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) LoopView *loop;

@property (nonatomic, strong) URLImageScroll *Scroll;

@property (nonatomic, strong) NSArray *dataArray;

@end
