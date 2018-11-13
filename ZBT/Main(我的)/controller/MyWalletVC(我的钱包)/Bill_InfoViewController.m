//
//  Bill_InfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/12.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Bill_InfoViewController.h"
#import "Globefile.h"
#import "CustomTableViewCell.h"

@interface Bill_InfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *leftTitleArray;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation Bill_InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单详情";
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    leftTitleArray = @[@"付款方式", @"商品说明", @"创建时间", @"订单号", @"商户订单号"];
    
    [self setUpNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

StringWidth();
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textF.textAlignment = NSTextAlignmentRight;
    CGFloat width = [self calculateRowWidth:@"商户订单号" withFont:14];
    [cell.textF creatLeftView:FRAME(0, 0, width, 50) AndTitle:leftTitleArray[indexPath.row] TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:[UIColor blackColor]];
    cell.textF.text = @[@"余额", @"豪华艇", @"2018.7.12 01:15", @"2018HVHVHV63", @"2018HVHVHV63"][indexPath.row];
    [cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self setHeaderView:view];
    return view;
}

- (void)setHeaderView:(UIView *)view {
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.backgroundColor = RandomColor;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"油纸伞";
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.textColor = [UIColor redColor];
    label1.font = SetFont(30);
    NSString *money = [self.dataDic[@"income"] integerValue] < 0 ? self.dataDic[@"income"] : [NSString stringWithFormat:@"+%@", self.dataDic[@"income"]];
    label1.text = money;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = SetColor(154, 154, 154, 1);
    if ([self.dataDic[@"type"] integerValue] == 1) {
        label2.text = @"提现中";
    }else if ([self.dataDic[@"type"] integerValue] == 2) {
        label2.text = @"已提现";
    }
    
    [view addSubview:imageV];
    [view addSubview:label];
    [view addSubview:label1];
    [view addSubview:label2];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(10);
        make.centerX.equalTo(label1.mas_centerX);
    }];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(label1.mas_top).offset(-10);
        make.left.equalTo(label1.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageV.mas_centerY);
        make.left.equalTo(imageV.mas_right).offset(10);
    }];
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
