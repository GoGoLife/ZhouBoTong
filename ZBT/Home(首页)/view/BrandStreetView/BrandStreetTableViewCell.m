//
//  BrandStreetTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/10.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BrandStreetTableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation BrandStreetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.textF = [[UITextField alloc] init];
    self.textF.enabled = NO;
    self.textF.text = @"拿破仑导航";
    
    CGFloat height = BrandCellHeight - 20;
//    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:FRAME(0, 0, height * 0.3, height * 0.3)];
////    rightImg.backgroundColor = RandomColor;
//    rightImg.image = [UIImage imageNamed:@"phone"];
//    self.textF.rightView = rightImg;
//    self.textF.rightViewMode = UITextFieldViewModeAlways;
    
    self.dateTextF = [[UITextField alloc] init];
    self.dateTextF.enabled = NO;
    self.dateTextF.font = SetFont(12);
    self.dateTextF.text = @"12:00 - 12:00";
    
    UILabel *left = [[UILabel alloc] initWithFrame:FRAME(0, 0, [self calculateRowWidth:@"营业时间：" withFont:12], height * 0.2)];
    left.textAlignment = NSTextAlignmentLeft;
    left.font = SetFont(12);
    left.text = @"营业时间：";
    self.dateTextF.leftView = left;
    self.dateTextF.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *right = [[UILabel alloc] initWithFrame:FRAME(0, 0, [self calculateRowWidth:@"36人浏览" withFont:12], height * 0.2)];
    right.textAlignment = NSTextAlignmentRight;
    right.font = SetFont(12);
    right.text = @"36人浏览";
    self.dateTextF.rightView = right;
    self.dateTextF.rightViewMode = UITextFieldViewModeAlways;
    
    self.addresstextF = [[UITextField alloc] init];
    self.addresstextF.enabled = NO;
    self.addresstextF.font = SetFont(12);
    self.addresstextF.text = @"相貌路11号";
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, [self calculateRowWidth:@"地址：" withFont:12], height * 0.2)];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = SetFont(12);
    addressLabel.text = @"地址：";
    self.addresstextF.leftView = addressLabel;
    self.addresstextF.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, [self calculateRowWidth:@"离我：12km" withFont:12], height * 0.2)];
    rightLabel.textAlignment = NSTextAlignmentLeft;
    rightLabel.font = SetFont(12);
    rightLabel.text = @"离我：12km";
    self.addresstextF.rightView = rightLabel;
    self.addresstextF.rightViewMode = UITextFieldViewModeAlways;
    
    [self.contentView addSubview:self.textF];
    [self.contentView addSubview:self.dateTextF];
    [self.contentView addSubview:self.addresstextF];
    
    __weak typeof(self) weakSelf = self;
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(height * 0.4));
    }];
    
    [self.dateTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textF.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(height * 0.2));
    }];
    
    [self.addresstextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.dateTextF.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(height * 0.2));
    }];
}

StringWidth();

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
