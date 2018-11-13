//
//  OrderInfoTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "OrderInfoTableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation OrderInfoTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.imgV = [[UIImageView alloc] init];
//    self.imgV.backgroundColor = RandomColor;
    
    self.topInfoTextF = [[UITextField alloc] init];
    self.topInfoTextF.font = SetFont(12);
    
    self.bottomInfoTextF = [[UITextField alloc] init];
    self.bottomInfoTextF.textColor = [UIColor grayColor];
    self.bottomInfoTextF.font = SetFont(12);
    
    [self.contentView addSubview:self.imgV];
    [self.contentView addSubview:self.topInfoTextF];
    [self.contentView addSubview:self.bottomInfoTextF];
    
    __weak typeof(self) weakSelf = self;
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(OrderInfoCellHeight / 2 - 15, OrderInfoCellHeight / 2 - 15));
    }];
    
    [self.topInfoTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imgV.mas_right).offset(30);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.height.mas_equalTo(@((OrderInfoCellHeight - 20) / 2));
    }];
    
    [self.bottomInfoTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imgV.mas_right).offset(30);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.top.equalTo(weakSelf.topInfoTextF.mas_bottom);
        make.height.mas_equalTo(weakSelf.topInfoTextF.mas_height);
    }];
}

- (void)setTopLeftStr:(NSString *)topLeftStr {
    UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 60, OrderInfoCellHeight / 2)];
    label.font = SetFont(12);
    label.text = topLeftStr;
    
    self.topInfoTextF.leftView = label;
    self.topInfoTextF.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setTopRightStr:(NSString *)topRightStr {
    UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width / 3, OrderInfoCellHeight / 2)];
    label.textAlignment = NSTextAlignmentRight;
    label.font = SetFont(12);
    label.text = topRightStr;
    
    self.topInfoTextF.rightView = label;
    self.topInfoTextF.rightViewMode = UITextFieldViewModeAlways;
}

- (void)setBottomLeftStr:(NSString *)bottomLeftStr {
    UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 60, OrderInfoCellHeight / 2)];
    label.font = SetFont(12);
    label.text = bottomLeftStr;
    label.textColor = [UIColor grayColor];
    
    self.bottomInfoTextF.leftView = label;
    self.bottomInfoTextF.leftViewMode = UITextFieldViewModeAlways;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
