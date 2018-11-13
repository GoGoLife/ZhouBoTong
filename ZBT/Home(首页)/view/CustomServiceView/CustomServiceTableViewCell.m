//
//  CustomServiceTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/31.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "CustomServiceTableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>
#import "UITextField+LeftRightView.h"

@implementation CustomServiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.topTextF = [[UITextField alloc] init];
    self.topTextF.enabled = NO;
    self.topTextF.text = @"收购摩托艇";
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.font = SetFont(12);
    self.bottomLabel.textColor = Color176;
    self.bottomLabel.text = @"发布时间：2018-12-10 12:12";
    
    [self.contentView addSubview:self.topTextF];
    [self.contentView addSubview:self.bottomLabel];
}

- (void)layoutSubviews {
    CGFloat height = (serviceCellHeight - 20) / 2;
    __weak typeof(self) weakSelf = self;
    [self.topTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@(height));
    }];
    
    UIImageView *right = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 20, 25)];
    right.image = [UIImage imageNamed:@"qiu"];
    [self.topTextF creatRightView:right.bounds AndControl:right];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topTextF.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(10);
        make.height.mas_equalTo(@(height));
    }];
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
