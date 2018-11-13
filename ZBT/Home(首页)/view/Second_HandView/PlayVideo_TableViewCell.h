//
//  PlayVideo_TableViewCell.h
//  ZBT
//
//  Created by 钟文斌 on 2018/8/29.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayVideo_TableViewCell : UITableViewCell

//描述信息
@property (nonatomic, strong) NSString *info_string;

@property (nonatomic, strong) NSString *video_URLString;

@property (nonatomic, strong) UILabel *info_label;

@end
