//
//  MarchantModel.h
//  ZBT
//
//  Created by 钟文斌 on 2018/6/29.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingModel.h"
#import <UIKit/UIKit.h>

@interface MarchantModel : NSObject
//商家ID
@property (nonatomic, strong) NSString* marchantID;

//商家名称
@property (nonatomic, strong) NSString *marchantName;

//会员ID
@property (nonatomic, strong) NSString *member_id;

//购物车ID
@property (nonatomic, strong) NSString *shopping_id;


//记录商家下的商品
@property (nonatomic, strong) NSMutableArray *shoppingArray;

@end
