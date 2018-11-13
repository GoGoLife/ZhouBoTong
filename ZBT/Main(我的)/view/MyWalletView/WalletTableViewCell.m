//
//  WalletTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/12.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "WalletTableViewCell.h"
#import "Globefile.h"

@implementation WalletTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.topLabel = [[UILabel alloc] init];
    
    self.bottomLabel = [[UILabel alloc] init];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.textColor = [UIColor redColor];
    
    [self.contentView addSubview:self.topLabel];
    [self.contentView addSubview:self.bottomLabel];
    [self.contentView addSubview:self.rightLabel];
}

- (void)layoutSubviews {
    __weak typeof(self) weakSelf = self;
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topLabel.mas_left);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_top);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
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
