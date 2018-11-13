//
//  EvaluateTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/23.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "EvaluateTableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation EvaluateTableViewCell

StringWidth();
StringHeight();

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.headerImageV = [[UIImageView alloc] init];
//    self.headerImageV.backgroundColor = RandomColor;
    self.headerImageV.image = [UIImage imageNamed:@"public"];
    ViewRadius(self.headerImageV, 20.0);
    
    self.topTextF = [[UITextField alloc] init];
    self.topTextF.enabled = NO;
    self.topTextF.text = @"油纸伞";
    
    self.remarkLabel = [[UILabel alloc] init];
//    self.remarkLabel.backgroundColor = RandomColor;
    
    [self.contentView addSubview:self.headerImageV];
    [self.contentView addSubview:self.topTextF];
    [self.contentView addSubview:self.remarkLabel];
    __weak typeof(self) weakSelf = self;
    [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.topTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerImageV.mas_top);
        make.left.equalTo(weakSelf.headerImageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@(30));
    }];
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topTextF.mas_left);
        make.top.equalTo(weakSelf.topTextF.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.topTextF.mas_right);
        make.height.mas_equalTo(@(0));
    }];
    
}

- (void)layoutSubviews {
    CGFloat width = (SCREENBOUNDS.width - 110) / 4;
    for (NSInteger index = 0; index < self.imageArray.count; index++) {
        self.bottomImageV = [[UIImageView alloc] init];
        self.bottomImageV.backgroundColor = RandomColor;
        self.bottomImageV.image = [UIImage imageNamed:@"public"];
        [self.contentView addSubview:self.bottomImageV];
        [self.bottomImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topTextF.mas_left).offset((width + 10) * index);
            make.top.equalTo(self.remarkLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(width, width));
        }];
    }
}

- (void)setRemarkString:(NSString *)remarkString {
    self.remarkLabel.text = remarkString;
    CGFloat height = [self calculateRowHeight:remarkString fontSize:14 withWidth:SCREENBOUNDS.width - 80];
    self.remarkLabel.font = SetFont(14);
    self.remarkLabel.numberOfLines = 0;
    __weak typeof(self) weakSelf = self;
    [self.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topTextF.mas_left);
        make.top.equalTo(weakSelf.topTextF.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.topTextF.mas_right);
        make.height.mas_equalTo(@(height));
    }];
    CGFloat width = (SCREENBOUNDS.width - 110) / 4;
    for (NSInteger index = 0; index < self.imageArray.count; index++) {
        self.bottomImageV = [[UIImageView alloc] init];
//        self.bottomImageV.backgroundColor = RandomColor;
        self.bottomImageV.image = [UIImage imageNamed:@"public"];
        [self.contentView addSubview:self.bottomImageV];
        [self.bottomImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.topTextF.mas_left).offset((width + 10) * index);
            make.top.equalTo(weakSelf.remarkLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(width, width));
        }];
    }
    
}

- (CGFloat)cellHeight:(NSString *)string WithFont:(NSInteger)fontSize {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREENBOUNDS.width - 80, 0) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height + 70 + (SCREENBOUNDS.width - 110) / 4;
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
