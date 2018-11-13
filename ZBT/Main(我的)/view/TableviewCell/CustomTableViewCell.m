//
//  CustomTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@implementation CustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.textF = [[UITextField alloc] init];
    self.textF.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.textF];
    
    __weak typeof(self) weakSelf = self;
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 10));
    }];
}

- (void)setLeftString:(NSString *)leftString {
    if (self.leftString != leftString) {
        CGFloat width = ((SCREENBOUNDS.width - 40) / 5);
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 0, width, InfoCellHeight)];
        label.font = SetFont(14);
        label.text = leftString;
        self.textF.leftView = label;
        self.textF.leftViewMode = UITextFieldViewModeAlways;
    }
}

- (void)setIsNewLayout:(BOOL)isNewLayout {
    if (isNewLayout) {
        __weak typeof(self) weakSelf = self;
        [self.textF mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 0));
        }];
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
