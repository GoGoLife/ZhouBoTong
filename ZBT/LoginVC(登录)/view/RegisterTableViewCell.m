//
//  RegisterTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "RegisterTableViewCell.h"
#import <Masonry.h>
#import "Globefile.h"

@implementation RegisterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.textFiled = [[UITextField alloc] init];
    
    [self.contentView addSubview:self.textFiled];
    
    __weak typeof(self) weakSelf = self;
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).with.insets(UIEdgeInsetsMake(0, 15, 0, 0));
    }];
}

- (void)setTitleString:(NSString *)titleString {
    if (self.titleString != titleString) {
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width / 5, CELLHEIGHT)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.text = titleString;
        self.textFiled.leftView = label;
        self.textFiled.leftViewMode = UITextFieldViewModeAlways;
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
