//
//  GoodReputationViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/1.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "GoodReputationViewController.h"
#import "Globefile.h"
#import <Masonry.h>
#import "UITextField+LeftRightView.h"

@interface GoodReputationViewController ()

@property (nonatomic, strong) UIView *oneView;

@property (nonatomic, strong) UIView *twoView;

@property (nonatomic, strong) UIView *threeView;

@end

@implementation GoodReputationViewController
setBack();
pop();
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好评";
    // Do any additional setup after loading the view.
    [self setUpNav];
    
    CGFloat oneHeight = 110.0;
    self.oneView = [[UIView alloc] init];
    self.oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.oneView];
    __weak typeof(self) weakSelf = self;
    [self.oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(oneHeight));
    }];
    
    //分割view
    UIView *oneLine = [[UIView alloc] init];
    oneLine.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:oneLine];
    [oneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oneView.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(10));
    }];
    
    UIImageView *imageV = [[UIImageView alloc] init];
//    imageV.backgroundColor = RandomColor;
    imageV.image = [UIImage imageNamed:@"public"];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"游艇渔利";
    
    [self.oneView addSubview:imageV];
    [self.oneView addSubview:label];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oneView.mas_top).offset(10);
        make.left.equalTo(weakSelf.oneView.mas_left).offset(10);
        make.size.mas_equalTo(@(CGSizeMake(oneHeight - 20, oneHeight - 20)));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_top);
        make.left.equalTo(imageV.mas_right).offset(10);
        make.right.equalTo(weakSelf.oneView.mas_right);
        make.height.mas_equalTo(@(40));
    }];
    
    
    CGFloat twoHeight = 60.0;
    self.twoView = [[UIView alloc] init];
    self.twoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.twoView];
    [self.twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneLine.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(twoHeight));
    }];
    
    UIView *twoLine = [[UIView alloc] init];
    twoLine.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:twoLine];
    [twoLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.twoView.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(10));
    }];
    
    UITextField *twoTextF = [[UITextField alloc] init];
    twoTextF.enabled = NO;
    twoTextF.textColor = [UIColor redColor];
    twoTextF.text = @"99.88%";
    
    [twoTextF creatLeftView:FRAME(0, 0, [self calculateRowWidth:@"好评" withFont:15] + 10, twoHeight - 20) AndTitle:@"好评" TextAligment:NSTextAlignmentLeft Font:SetFont(15) Color:[UIColor blackColor]];
    
    [self.twoView addSubview:twoTextF];
    [twoTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.twoView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    CGFloat threeHeight = 120;
    self.threeView = [[UIView alloc] init];
    self.threeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.threeView];
    [self.threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoLine.mas_bottom);
        make.left.equalTo(twoLine.mas_left);
        make.right.equalTo(twoLine.mas_right);
        make.height.mas_equalTo(@(threeHeight));
    }];
    
    UIView *threeLine = [[UIView alloc] init];
    threeLine.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:threeLine];
    [threeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.threeView.mas_bottom);
        make.left.equalTo(weakSelf.threeView.mas_left);
        make.right.equalTo(weakSelf.threeView.mas_right);
        make.height.mas_equalTo(@(10));
    }];
    
    CGFloat textFHeight = (threeHeight - 20) / 3;
    CGFloat width = [self calculateRowWidth:@"联系电话：" withFont:17];
    
    UITextField *oneText = [[UITextField alloc] init];
    oneText.enabled = NO;
    oneText.text = @"浙江省  温州市";
    
    UITextField *twoText = [[UITextField alloc] init];
    twoText.enabled = NO;
    twoText.text = @"长安路 二十二大街";
    
    UITextField *threeText = [[UITextField alloc] init];
    threeText.enabled = NO;
    threeText.text = @"18268865135";
    
    [self.threeView addSubview:oneText];
    [self.threeView addSubview:twoText];
    [self.threeView addSubview:threeText];
    
    [oneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.threeView.mas_top).offset(10);
        make.left.equalTo(weakSelf.threeView.mas_left).offset(10);
        make.right.equalTo(weakSelf.threeView.mas_right);
        make.height.mas_equalTo(@(textFHeight));
    }];
    [oneText creatLeftView:FRAME(0, 0, width - 30, textFHeight) AndTitle:@"区域：" TextAligment:NSTextAlignmentLeft Font:SetFont(17) Color:[UIColor blackColor]];
    
    [twoText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneText.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.threeView.mas_left).offset(10);
        make.right.equalTo(weakSelf.threeView.mas_right);
        make.height.mas_equalTo(@(textFHeight));
    }];
    
    [twoText creatLeftView:FRAME(0, 0, width, textFHeight) AndTitle:@"友情地址：" TextAligment:NSTextAlignmentLeft Font:SetFont(17) Color:[UIColor blackColor]];
    
    [threeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoText.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.threeView.mas_left).offset(10);
        make.right.equalTo(weakSelf.threeView.mas_right);
        make.height.mas_equalTo(@(textFHeight));
    }];
    
    [threeText creatLeftView:FRAME(0, 0, width, textFHeight) AndTitle:@"联系电话：" TextAligment:NSTextAlignmentLeft Font:SetFont(17) Color:[UIColor blackColor]];
    
    
    
}

StringWidth();

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
