//
//  CollectTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "CollectTableViewCell.h"
#import <Masonry.h>
#import "Globefile.h"

@interface CollectTableViewCell()<UITextFieldDelegate>

@end

@implementation CollectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return self;
}

- (void)setUI {
    self.imgV = [[UIImageView alloc] init];
//    imgV.image = [UIImage imageNamed:@"public"];
    
    self.label = [[UILabel alloc] init];
    self.label.font = SetFont(15);
    self.label.text = @"二手游艇旗舰店";
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.text = @"最近上新：无";
    
    self.textF = [[UITextField alloc] init];
    self.textF.delegate = self;
    self.textF.font = SetFont(12);
    self.textF.textColor = [UIColor grayColor];
    self.textF.text = @"  23人收藏";
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 20, 20)];
//    leftImg.backgroundColor = RandomColor;
    leftImg.image = [UIImage imageNamed:@"dianpu"];
    self.textF.leftView = leftImg;
    self.textF.leftViewMode = UITextFieldViewModeAlways;
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = FRAME(0, 0, 80, 20);
    self.button.titleLabel.font = SetFont(12);
    [self.button setTitle:@"取消收藏" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    ViewBorderRadius(self.button, 10.0, 1, [UIColor grayColor]);
    self.textF.rightView = self.button;
    self.textF.rightViewMode = UITextFieldViewModeAlways;
    
    [self.contentView addSubview:self.imgV];
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.textF];
    
    __weak typeof(self) weakSelf = self;
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(20);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(CollectCellHeight - 40, CollectCellHeight - 40));
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imgV.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.top.equalTo(weakSelf.imgV.mas_top);
        make.height.mas_equalTo(@(25));
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.label.mas_left);
        make.right.equalTo(weakSelf.label.mas_right);
        make.top.equalTo(weakSelf.label.mas_bottom);
        make.height.equalTo(weakSelf.label.mas_height);
    }];
    
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.label.mas_left);
        make.right.equalTo(weakSelf.label.mas_right).offset(-15);
        make.top.equalTo(weakSelf.typeLabel.mas_bottom);
        make.height.mas_equalTo(@(20));
    }];
}

- (void)setType:(CollectCellType)type {
    switch (type) {
        case CollectCellTypeProduct:
        {
            self.typeLabel.textColor = [UIColor redColor];
            self.typeLabel.font = SetFont(15);
        }
            break;
        case CollectCellTypeStore:
        {
            self.typeLabel.textColor = [UIColor grayColor];
            self.typeLabel.font = SetFont(12);
        }
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dismiss {
    if ([_delegate respondsToSelector:@selector(dismissCollect:)]) {
        [_delegate dismissCollect:self.indexPath];
    }
}

@end
