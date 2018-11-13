//
//  Wheel_infoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/20.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Wheel_infoViewController.h"
#import "Globefile.h"

@interface Wheel_infoViewController ()

@property (nonatomic, strong) UIScrollView *scrollV;

@end

@implementation Wheel_infoViewController
StringHeight()
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [NSString stringWithFormat:@"%@", [self.textString dataUsingEncoding:NSUTF8StringEncoding]];
    
}

- (void)viewDidLayoutSubviews {
//    self.textString = @"最新二手艇有售\n游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。";
    CGFloat height = [self calculateRowHeight:self.textString fontSize:15 withWidth:CGRectGetWidth(self.view.bounds) - 10] + 210;
    
//    [self.scrollV layoutIfNeeded];
//    [self.view layoutIfNeeded];
    self.scrollV.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), height + 10);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self setUpNav];
    // Do any additional setup after loading the view.
    self.scrollV = [[UIScrollView alloc] init];//WithFrame:self.view.frame];
    self.scrollV.showsVerticalScrollIndicator = NO;
    self.scrollV.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollV];
    __weak typeof(self) weakSelf = self;
    [self.scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    UIImageView *imageV = [[UIImageView alloc] init];
//    imageV.backgroundColor = RandomColor;
    imageV.image = [UIImage imageNamed:@"public"];
    
    UILabel *textLabel = [[UILabel alloc] init];
    [textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    textLabel.font = SetFont(15);
    textLabel.numberOfLines = 0;
    textLabel.text = self.textString;//@"最新二手艇有售\n游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。游艇，是一种水上娱乐高级耐用的消费品。";
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = SetFont(14);
    dateLabel.textColor = SetColor(137, 137, 137, 1);
    dateLabel.text = self.dateString;//@"发布时间：2018-12-12 13:00";
    
    [self.scrollV addSubview:imageV];
    [self.scrollV addSubview:textLabel];
    [self.scrollV addSubview:dateLabel];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.scrollV.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
//        make.width.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(150));
    }];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(10);
        make.left.equalTo(imageV.mas_left).offset(5);
//        make.width.equalTo(imageV);
        make.right.equalTo(imageV.mas_right).offset(-5);
    }];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel.mas_bottom).offset(10);
        make.right.equalTo(textLabel.mas_right).offset(-5);
    }];
    
//    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.view.mas_top);
//        make.left.equalTo(weakSelf.view.mas_left);
//        make.right.equalTo(weakSelf.view.mas_right);
//        make.bottom.equalTo(dateLabel.mas_bottom).offset(10);
//    }];
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
