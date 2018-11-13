//
//  EquipmentTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/15.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "EquipmentTableViewCell.h"
#import <Masonry.h>

@implementation EquipmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.textF = [[UITextField alloc] init];
    self.textF.enabled = NO;
    
    [self.contentView addSubview:self.textF];
    
    __weak typeof(self) weakSelf = self;
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 0));
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
