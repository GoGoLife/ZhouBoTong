//
//  ChatSessionTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/8/13.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ChatSessionTableViewCell.h"
#import <Masonry.h>

@implementation ChatSessionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    [self.contentView addSubview:self.header_imageV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.messageLabel];
    
    __weak typeof(self) weakSelf = self;
    [_header_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(@(ChatCellHeight - 20));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.header_imageV.mas_top);
        make.left.equalTo(weakSelf.header_imageV.mas_right).offset(5);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@((ChatCellHeight - 20) / 2));
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_left);
        make.right.equalTo(weakSelf.nameLabel.mas_right);
        make.bottom.equalTo(weakSelf.header_imageV.mas_bottom);
        make.height.equalTo(weakSelf.nameLabel.mas_height);
    }];
}


- (UIImageView *)header_imageV {
    if (!_header_imageV) {
        _header_imageV = [[UIImageView alloc] init];
    }
    return _header_imageV;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
    }
    return _messageLabel;
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
