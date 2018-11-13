//
//  AboutUSViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/8/17.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AboutUSViewController.h"
#import "Globefile.h"

@interface AboutUSViewController ()

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = BaseViewColor;
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = @"主要提供船用设备的买卖以及定制服务、租赁服务、码头服务、售后服务和代办牌照等服务。";
    [self.view addSubview:label];
    __weak typeof(self) weakSelf = self;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
    }];
    
    [self setUpNav];
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
