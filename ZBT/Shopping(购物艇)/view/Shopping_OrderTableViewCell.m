//
//  Shopping_OrderTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/6.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Shopping_OrderTableViewCell.h"
#import "Globefile.h"

@implementation Shopping_OrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.backgroundColor = [UIColor grayColor];
    ViewRadius(self.selectButton, 12.0);
    [self.selectButton addTarget:self action:@selector(changeSelectState:) forControlEvents:UIControlEventTouchUpInside];
    self.selectButton.hidden = YES;
    
    self.leftImageV = [[UIImageView alloc] init];
//    self.leftImageV.backgroundColor = RandomColor;
    self.leftImageV.image = [UIImage imageNamed:@"public"];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"二手游艇";
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textColor = [UIColor redColor];
    self.priceLabel.text = @"¥400";
    
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.font = SetFont(14);
    
    self.lessesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lessesButton setBackgroundImage:[UIImage imageNamed:@"miss"] forState:UIControlStateNormal];
    ViewRadius(self.lessesButton, 12.0);
    self.lessesButton.hidden = YES;
    [self.lessesButton addTarget:self action:@selector(lessAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.hidden = YES;
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    ViewRadius(self.addButton, 12.0);
    self.addButton.hidden = YES;
    [self.addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.leftImageV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.lessesButton];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.addButton];
    
    __weak typeof(self) weakSelf = self;
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    CGFloat width = ShoppingCellHeight - 20;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(@(width));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_top);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(10);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_left);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(10);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.mas_top);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.countLabel.mas_right);
        make.bottom.equalTo(weakSelf.leftImageV.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.addButton.mas_left).offset(-5);
        make.centerY.equalTo(weakSelf.addButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [self.lessesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.numberLabel.mas_left).offset(-5);
        make.centerY.equalTo(weakSelf.addButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
}

- (void)layoutSubviews {
    
}

- (void)setIsMoved:(BOOL)isMoved {
    __weak typeof(self) weakSelf = self;
    if (isMoved) {
        self.countLabel.hidden = YES;
        self.selectButton.hidden = NO;
        self.lessesButton.hidden = NO;
        self.numberLabel.hidden = NO;
        self.addButton.hidden = NO;
        
        self.numberLabel.text = [NSString stringWithFormat:@"%ld", self.number];
        
        [self.leftImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
            make.left.equalTo(weakSelf.contentView.mas_left).offset(50);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
            make.width.mas_equalTo(@(80));
        }];
        [self layoutIfNeeded];
    }else {
        self.countLabel.hidden = NO;
        self.selectButton.hidden = YES;
        self.lessesButton.hidden = YES;
        self.numberLabel.hidden = YES;
        self.addButton.hidden = YES;
        
        self.numberLabel.text = [NSString stringWithFormat:@"%ld", self.number];
//        self.numberLabel.text = @"2";
        
        [self.leftImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
            make.width.mas_equalTo(@(80));
        }];
        [self layoutIfNeeded];
    }
}

- (void)setIsSelect:(BOOL)isSelect {
    if (isSelect) {
        self.selectButton.backgroundColor = [UIColor redColor];
    }else {
        self.selectButton.backgroundColor = [UIColor grayColor];
    }
}

- (void)changeSelectState:(UIButton *)button {
    button.selected = !button.isSelected;
    if (button.selected) {
        self.selectButton.backgroundColor = [UIColor redColor];
        if ([_delegate respondsToSelector:@selector(selectedCellIndexPath:AndChoose:)]) {
            [_delegate selectedCellIndexPath:self.indexPath AndChoose:button.selected];
        }
    }else {
        self.selectButton.backgroundColor = [UIColor grayColor];
        if ([_delegate respondsToSelector:@selector(selectedCellIndexPath:AndChoose:)]) {
            [_delegate selectedCellIndexPath:self.indexPath AndChoose:button.selected];
        }
    }
}

//增加  减少  按钮action
- (void)addAction {
    if ([_delegate respondsToSelector:@selector(addNumber:)]) {
        [_delegate addNumber:self.indexPath];
    }
}

- (void)lessAction {
    if ([_delegate respondsToSelector:@selector(lessNumber:)]) {
        [_delegate lessNumber:self.indexPath];
    }
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
