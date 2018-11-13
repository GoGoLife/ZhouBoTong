//
//  ShoppingModel.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/15.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShoppingModel : NSObject

//判断是否选中
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) BOOL isMoved;

//商品数量
@property (nonatomic, assign) NSInteger number;

//商品图片
@property (nonatomic, strong) UIImage *image;

//商品图片URL
@property (nonatomic, strong) NSString *imageURL;

//商品名称
@property (nonatomic, strong) NSString *goodsName;

//商品价格
@property (nonatomic, strong) NSString *goodsPrice;

//商品ID
@property (nonatomic, strong) NSString* goodsID;

//记录商品所在商家
@property (nonatomic, strong) NSString *merchantID;

@end
