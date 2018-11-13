//
//  AddressTableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AddressCellHeight 100

@interface AddressTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *nameTextF;

@property (nonatomic, strong) UITextField *cityTextF;

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, assign) BOOL isDefultAddress;

@property (nonatomic, strong) NSString *nameString;

@end
