//
//  ChatSessionTableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/8/13.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ChatCellHeight 60

@interface ChatSessionTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *header_imageV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@end
