//
//  LeftTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/9.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "LeftTableViewCell.h"
#import <Masonry.h>
#import "Globefile.h"

@interface LeftTableViewCell()

@end

@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
        self.contentView.backgroundColor = SetColor(243, 242, 247, 1);
    }
    return self;
}

- (void)setUI {
    self.leftV = [[UIImageView alloc] init];
    self.leftV.backgroundColor = self.contentView.backgroundColor;
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.textColor = [UIColor blackColor];
    self.rightLabel.font = SetFont(15);
    self.rightLabel.text = @"船用设备";
    
    [self.contentView addSubview:self.leftV];
    [self.contentView addSubview:self.rightLabel];
    
    __weak typeof(self) weakSelf = self;
    [self.leftV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
//        make.top.equalTo(self.contentView.mas_top).offset(LeftCellHeight / 4);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(3, LeftCellHeight / 3));
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftV.mas_right).offset(10);
//        make.top.equalTo(self.leftV.mas_top);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(weakSelf.contentView.bounds.size.width / 2, LeftCellHeight / 2));
        
    }];
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.leftV.backgroundColor = [UIColor blueColor];
        self.rightLabel.textColor = [UIColor blueColor];
    }else {
        self.contentView.backgroundColor = SetColor(243, 242, 247, 1);
        self.leftV.backgroundColor = self.contentView.backgroundColor;
        self.rightLabel.textColor = [UIColor blackColor];
    }

    // Configure the view for the selected state
}

@end
