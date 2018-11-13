//
//  AddressTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AddressTableViewCell.h"
#import <Masonry.h>
#import "Globefile.h"

@implementation AddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    
    return self;
}

- (void)setUI {
    self.nameTextF = [[UITextField alloc] init];
    self.nameTextF.enabled = NO;
    self.nameTextF.font = SetFont(18);
    
    UIImageView *right = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 10, 20)];
    right.image = [UIImage imageNamed:@"right"];
    self.nameTextF.rightView = right;
    self.nameTextF.rightViewMode = UITextFieldViewModeAlways;
    
    self.cityTextF = [[UITextField alloc] init];
    self.cityTextF.enabled = NO;
    self.cityTextF.font = SetFont(15);
    self.cityTextF.textColor = [UIColor grayColor];
    self.cityTextF.text = @"浙江省杭州市余杭区";
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.textColor = [UIColor grayColor];
    self.infoLabel.font = SetFont(15);
    self.infoLabel.text = @"好运路幸福社区1号";
    
    [self.contentView addSubview:self.nameTextF];
    [self.contentView addSubview:self.cityTextF];
    [self.contentView addSubview:self.infoLabel];
    
    __weak typeof(self) weakSelf = self;
    [self.nameTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(40));
    }];
    
    [self.cityTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameTextF.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(20));
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.cityTextF.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(20));
    }];
    
}

- (void)setIsDefultAddress:(BOOL)isDefultAddress {
    if (isDefultAddress) {
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 100, 20)];
        label.font = SetFont(15);
        label.textColor = SetColor(252, 169, 61, 1);
        label.text = @"【默认地址】";
        
        self.cityTextF.leftView = label;
        self.cityTextF.leftViewMode = UITextFieldViewModeAlways;
    }else {
        self.cityTextF.leftView = nil;
    }
}

- (void)setNameString:(NSString *)nameString {
    UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 100, 40)];
    label.font = SetFont(18);
    label.text = nameString;
    
    self.nameTextF.leftView = label;
    self.nameTextF.leftViewMode = UITextFieldViewModeAlways;
    
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
