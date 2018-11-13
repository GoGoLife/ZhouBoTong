//
//  ChangePasswordViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/22.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "Globefile.h"
#import "UITextField+LeftRightView.h"

@interface ChangePasswordViewController ()

@property (nonatomic, strong) UITextField *textF1;

@property (nonatomic, strong) UITextField *textF2;

@property (nonatomic, strong) UITextField *textF3;

@property (nonatomic, strong) UIButton *button;

@end

@implementation ChangePasswordViewController
StringWidth();
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改密码";
    
    self.textF1 = [[UITextField alloc] init];
    self.textF1.textAlignment = NSTextAlignmentRight;
    self.textF1.font = SetFont(14);
    self.textF1.placeholder = @"请输入原始密码";
    
    self.textF2 = [[UITextField alloc] init];
    self.textF2.textAlignment = NSTextAlignmentRight;
    self.textF2.font = SetFont(14);
    self.textF2.placeholder = @"请输入新密码";
    
    self.textF3 = [[UITextField alloc] init];
    self.textF3.textAlignment = NSTextAlignmentRight;
    self.textF3.font = SetFont(14);
    self.textF3.placeholder = @"请再次输入新密码";
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = SetColor(24, 148, 220, 1);
    [self.button setTitle:@"确定" forState:UIControlStateNormal];
    
    CGFloat width = [self calculateRowWidth:@"原始密码" withFont:14];
    [self.textF1 creatLeftView:FRAME(0, 0, width, 50) AndTitle:@"原始密码" TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:[UIColor blackColor]];
    
    [self.textF2 creatLeftView:FRAME(0, 0, width, 50) AndTitle:@"新密码" TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:[UIColor blackColor]];
    
    [self.textF3 creatLeftView:FRAME(0, 0, width, 50) AndTitle:@"确认密码" TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:[UIColor blackColor]];
    
    [self.view addSubview:self.textF1];
    [self.view addSubview:self.textF2];
    [self.view addSubview:self.textF3];
    [self.view addSubview:self.button];
    
    __weak typeof(self) weakSelf = self;
    [self.textF1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(5);
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.right.equalTo(weakSelf.view.mas_right).offset(-15);
        make.height.mas_equalTo(@(50));
    }];
    
    [self.textF2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textF1.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.textF1.mas_centerX);
        make.size.equalTo(weakSelf.textF1);
    }];
    
    [self.textF3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textF2.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.textF1.mas_centerX);
        make.size.equalTo(weakSelf.textF1);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(44));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
