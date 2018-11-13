//
//  AddAddressViewController.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface AddAddressViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *dataDic;

//是否是修改地址
@property (nonatomic, assign) BOOL isChange;

//要修改的地址的ID
@property (nonatomic, strong) NSString *Address_id;

@end
