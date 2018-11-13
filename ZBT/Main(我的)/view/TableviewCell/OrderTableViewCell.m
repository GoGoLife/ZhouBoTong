//
//  OrderTableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/7.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@interface OrderTableViewCell()

@property (nonatomic, strong) UITextField *textF;

@end

@implementation OrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    //旗舰店
//    self.textF = [[UITextField alloc] init];
//    self.textF.enabled = NO;
//    self.textF.text = [@"  " stringByAppendingString:@"旗舰店"];
//
//    UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 20, 20)];
////    img.backgroundColor = RandomColor;
//    img.image = [UIImage imageNamed:@"dianpu"];
//    self.textF.leftView = img;
//    self.textF.leftViewMode = UITextFieldViewModeAlways;
    
    //订单详情
    self.orderImg = [[UIImageView alloc] init];
//    self.orderImg.backgroundColor = RandomColor;
    self.orderImg.image = [UIImage imageNamed:@"public"];
    
    self.nameTextF = [[UITextField alloc] init];
    self.nameTextF.enabled = NO;
    self.nameTextF.textAlignment = NSTextAlignmentRight;
    self.nameTextF.text = @"¥4000";
    
    self.standerdTextF = [[UITextField alloc] init];
    self.standerdTextF.enabled = NO;
    self.standerdTextF.font = SetFont(12);
    self.standerdTextF.text = @"蓝色";
    
    UILabel *left = [[UILabel alloc] initWithFrame:FRAME(0, 0, 60, 40)];
    left.font = SetFont(12);
    left.textAlignment = NSTextAlignmentLeft;
    left.text = @"规格：";
    self.standerdTextF.leftView = left;
    self.standerdTextF.leftViewMode = UITextFieldViewModeAlways;
    
    self.totalLabel = [[UILabel alloc] init];
    self.totalLabel.font = SetFont(12);
    self.totalLabel.textAlignment = NSTextAlignmentRight;
    self.totalLabel.text = @"2件商品 合计: ¥2222 (含运费 ¥22)";
    
    //分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    
    self.typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.typeButton.titleLabel.font = SetFont(12);
    
    self.typeButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.typeButton1.titleLabel.font = SetFont(12);
    
//    [self.contentView addSubview:self.textF];
    [self.contentView addSubview:self.orderImg];
    [self.contentView addSubview:self.nameTextF];
    [self.contentView addSubview:self.standerdTextF];
    [self.contentView addSubview:self.totalLabel];
    [self.contentView addSubview:line];
//    [self.contentView addSubview:self.typeButton];
//    [self.contentView addSubview:self.typeButton1];
    
    __weak typeof(self) weakSelf = self;
//    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.contentView.mas_top);
//        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
//        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
//        make.height.mas_equalTo(@(40));
//    }];
    
    [self.orderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.nameTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.orderImg.mas_top);
        make.left.equalTo(weakSelf.orderImg.mas_right).offset(5);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(30));
    }];
    
    [self.standerdTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameTextF.mas_bottom);
        make.left.equalTo(weakSelf.orderImg.mas_right).offset(5);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(30));
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.orderImg.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.orderImg.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(20));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.totalLabel.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(@(1));
    }];
    
//    [self.typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.totalLabel.mas_bottom).offset(15);
//        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
//        make.size.mas_equalTo(CGSizeMake(80, 20));
//    }];
//
//    [self.typeButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.typeButton.mas_top);
//        make.right.equalTo(weakSelf.typeButton.mas_left).offset(-10);
//        make.size.equalTo(weakSelf.typeButton);
//    }];
}

- (void)setIsShowTypeButton:(BOOL)isShowTypeButton {
    if (isShowTypeButton) {
        self.typeButton.hidden = NO;
        self.typeButton1.hidden = NO;
    }else {
        self.typeButton.hidden = YES;
        self.typeButton1.hidden = YES;
    }
}

- (void)setType:(TypeButton)type {
    switch (type) {
        case TypeButtonWaitPay:
        {
//            UILabel *right = [[UILabel alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width / 2, 40)];
//            right.textAlignment = NSTextAlignmentRight;
//            right.textColor = [UIColor redColor];
//            right.font = SetFont(12);
//            right.text = @"等待买家付款";
//            self.textF.rightView = right;
//            self.textF.rightViewMode = UITextFieldViewModeAlways;
            
            [self.typeButton1 setTitle:@"取消" forState:UIControlStateNormal];
            ViewBorderRadius(self.typeButton1, 10.0, 1.0, [UIColor redColor]);
            [self.typeButton1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [self.typeButton setTitle:@"付款" forState:UIControlStateNormal];
            ViewBorderRadius(self.typeButton, 10.0, 1.0, [UIColor redColor]);
            [self.typeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
            break;
        case TypeButtonWaitSend:
        {
//            UILabel *right = [[UILabel alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width / 2, 40)];
//            right.textAlignment = NSTextAlignmentRight;
//            right.textColor = [UIColor redColor];
//            right.font = SetFont(12);
//            right.text = @"等待卖家发货";
//            self.textF.rightView = right;
//            self.textF.rightViewMode = UITextFieldViewModeAlways;
            
            self.typeButton1.hidden = YES;
            [self.typeButton setTitle:@"提醒发货" forState:UIControlStateNormal];
            ViewBorderRadius(self.typeButton, 10.0, 1.0, [UIColor grayColor]);
            [self.typeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
            break;
        case TypeButtonWaitGet:
        {
//            UILabel *right = [[UILabel alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width / 2, 40)];
//            right.textAlignment = NSTextAlignmentRight;
//            right.textColor = [UIColor redColor];
//            right.font = SetFont(12);
//            right.text = @"等待买家收货";
//            self.textF.rightView = right;
//            self.textF.rightViewMode = UITextFieldViewModeAlways;
            
            self.typeButton1.hidden = YES;
            [self.typeButton setTitle:@"确认收货" forState:UIControlStateNormal];
            ViewBorderRadius(self.typeButton, 10.0, 1.0, [UIColor redColor]);
            [self.typeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
            break;
        case TypeButtonWaitEvaluation:
        {
//            UILabel *right = [[UILabel alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width / 2, 40)];
//            right.textAlignment = NSTextAlignmentRight;
//            right.textColor = [UIColor redColor];
//            right.font = SetFont(12);
//            right.text = @"等待买家评价";
//            self.textF.rightView = right;
//            self.textF.rightViewMode = UITextFieldViewModeAlways;
            
            self.typeButton1.hidden = YES;
            [self.typeButton setTitle:@"评价" forState:UIControlStateNormal];
            ViewBorderRadius(self.typeButton, 10.0, 1.0, [UIColor redColor]);
            [self.typeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
            break;
        case TypeButtonDrawBack:
        {
//            UILabel *right = [[UILabel alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width / 2, 40)];
//            right.textAlignment = NSTextAlignmentRight;
//            right.textColor = [UIColor redColor];
//            right.font = SetFont(12);
//            right.text = @"已确认收货";
//            self.textF.rightView = right;
//            self.textF.rightViewMode = UITextFieldViewModeAlways;
            
            self.typeButton1.hidden = YES;
            [self.typeButton setTitle:@"申请售后" forState:UIControlStateNormal];
            ViewBorderRadius(self.typeButton, 10.0, 1.0, [UIColor grayColor]);
            [self.typeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
            break;
        case TypeButtonUnknow:
        {
            [self.typeButton setTitle:@"售后中" forState:UIControlStateNormal];
            ViewBorderRadius(self.typeButton, 10.0, 1.0, [UIColor grayColor]);
            [self.typeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
