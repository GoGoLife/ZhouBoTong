
//
//  MarchantListTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "MarchantListTableViewCell.h"
#import "Globefile.h"
#import "UITextField+LeftRightView.h"

@implementation MarchantListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.imageV = [[UIImageView alloc] init];
//    self.imageV.backgroundColor = RandomColor;
    self.imageV.image = [UIImage imageNamed:@"public"];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = SetFont(17);
    self.nameLabel.text = @"庞巴迪火花 90";
    
    self.marchantLabel = [[UITextField alloc] init];
    self.marchantLabel.enabled = NO;
    self.marchantLabel.font = SetFont(12);
    self.marchantLabel.text = @"【水上娱乐-乐清波比水上娱乐运动中心】";
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textColor = [UIColor redColor];
    self.priceLabel.font = SetFont(15);
    self.priceLabel.text = @"¥1000";
    
    self.bottomTextF = [[UITextField alloc] init];
    self.bottomTextF.enabled = NO;
    self.bottomTextF.textAlignment = NSTextAlignmentLeft;
    self.bottomTextF.font = SetFont(13);
    self.bottomTextF.text = @"0%好评";
    
    CGFloat width = [self calculateRowWidth:@"0条评价" withFont:13] + 5;
    [self.bottomTextF creatLeftView:FRAME(0, 0, width, 20) AndTitle:@"0条评价" TextAligment:NSTextAlignmentLeft Font:SetFont(13) Color:[UIColor blackColor]];
    
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.marchantLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.bottomTextF];
}
StringWidth();

- (void)layoutSubviews {
    CGFloat width = MARCHANTLISTCELLHEIGHT - 20;
    __weak typeof(self) weakSelf = self;
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(@(width));
    }];
    
    width = (width - 40) / 2;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageV.mas_top);
        make.left.equalTo(weakSelf.imageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(@(width));
    }];
    
    [self.marchantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.mas_bottom);
        make.left.equalTo(weakSelf.nameLabel.mas_left);
        make.right.equalTo(weakSelf.nameLabel.mas_right).offset(-15);
        make.height.mas_equalTo(@(20));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.marchantLabel.mas_bottom);
        make.left.equalTo(weakSelf.nameLabel.mas_left);
        make.right.equalTo(weakSelf.nameLabel.mas_right);
        make.height.mas_equalTo(@(width));
    }];
    
    [self.bottomTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.priceLabel.mas_bottom);
        make.left.equalTo(weakSelf.nameLabel.mas_left);
        make.right.equalTo(weakSelf.nameLabel.mas_right).offset(-15);
        make.height.mas_equalTo(@(20));
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
