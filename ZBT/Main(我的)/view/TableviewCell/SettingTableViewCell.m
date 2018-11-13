//
//  SettingTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/6.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SettingTableViewCell.h"
#import <Masonry.h>
#import "Globefile.h"

@implementation SettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
        
    }
    return self;
}

- (void)setUI {
    self.textF = [[UITextField alloc] init];
    self.textF.textAlignment = NSTextAlignmentRight;
    self.textF.enabled = NO;
    
    [self.contentView addSubview:self.textF];
    
    __weak typeof(self) weakSelf = self;
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 0));
    }];
}

- (void)setLeftString:(NSString *)leftString {
    UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width / 5, SCellHeight)];
    label.text = leftString;
    label.font = SetFont(14);
    self.textF.leftView = label;
    self.textF.leftViewMode = UITextFieldViewModeAlways;
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
