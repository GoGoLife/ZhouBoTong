//
//  MyWalletViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/12.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "MyWalletViewController.h"
#import "Globefile.h"
#import "WalletTableViewCell.h"
#import "Bill_InfoViewController.h"
#import "LYSSlideMenuController.h"
#import "FirstWayViewController.h"
#import "SecondWayViewController.h"

@interface MyWalletViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LYSSlideMenuController *wayMenu;

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation MyWalletViewController

- (LYSSlideMenuController *)wayMenu {
    _wayMenu = [[LYSSlideMenuController alloc] init];
    //已发布定制
    FirstWayViewController *two = [[FirstWayViewController alloc] init];
    two.sum_price = self.dataDic[@"total_money"];
    //已完成定制
    SecondWayViewController *one = [[SecondWayViewController alloc] init];
    one.sum_price = self.dataDic[@"total_money"];
    
    _wayMenu.controllers = @[one, two];
    _wayMenu.bottomLineWidth = SCREENBOUNDS.width / 4;
    _wayMenu.titles = @[@"银行卡", @"支付宝"];
    _wayMenu.titleColor = [UIColor blackColor];
    _wayMenu.titleSelectColor = [UIColor blueColor];
    _wayMenu.bottomLineColor = [UIColor blueColor];
    _wayMenu.pageNumberOfItem = 2;
    return _wayMenu;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backgroundColor = SetColor(24, 147, 219, 1);
    //    UIColor * cc = [UIColor whiteColor];
    ////    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    //    NSDictionary *dict = @{NSForegroundColorAttributeName : cc, NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
    //    self.navigationController.navigationBar.titleTextAttributes = dict;
    //
    //    self.navigationController.navigationBar.translucent = YES;
    //    //设置导航栏背景图片为一个空的image，这样就透明了
    //    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //
    //    //去掉透明后导航栏下边的黑边
    //    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self getWalletInfo];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    如果不想让其他页面的导航栏变为透明 需要重置
    //    self.navigationController.navigationBar.translucent = NO;
    //    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:nil];
    //
    //    UIColor * cc = [UIColor blackColor];
    //    NSDictionary *dict = @{NSForegroundColorAttributeName : cc, NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
    ////    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    //    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[WalletTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self setUpNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return [self.dataDic[@"bill"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.bottomLabel.font = SetFont(14);
    cell.bottomLabel.textColor = SetColor(152, 152, 152, 1);
    cell.topLabel.text = @"二手游艇收购";
    cell.bottomLabel.text = self.dataDic[@"bill"][indexPath.row][@"add_time"];//@"2018-09-18 13:00";
    NSString *money = [self.dataDic[@"bill"][indexPath.row][@"income"] integerValue] < 0 ? self.dataDic[@"bill"][indexPath.row][@"income"] : [NSString stringWithFormat:@"+%@", self.dataDic[@"bill"][indexPath.row][@"income"]];
    cell.rightLabel.text = money;//@"+2000";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WalletCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 200.0;
    }
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200)];
        view.backgroundColor = SetColor(24, 147, 219, 1);
        [self setFirstHeaderView:view];
        return view;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    for (UIView *vv in view.subviews) {
        [vv removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] init];
    label.textColor = SetColor(142, 142, 142, 1);
    label.text = @"账单";
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 0));
    }];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Bill_InfoViewController *info = [[Bill_InfoViewController alloc] init];
    info.dataDic = self.dataDic[@"bill"][indexPath.row];
    [self.navigationController pushViewController:info animated:YES];
}

- (void)setFirstHeaderView:(UIView *)view {
    //余额具体数值
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36.0]];
    label.text = isNullClass(self.dataDic[@"total_money"]);//@"¥10000";
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = SetFont(17);
    label1.textColor = SetColor(159, 214, 241, 1);
    label1.text = @"余额";
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = [UIColor whiteColor];
    label2.text = @"提现";
    label2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getMoney:)];
    [label2 addGestureRecognizer:tap];
    
    
    UIImageView *rightImageV = [[UIImageView alloc] init];
    rightImageV.image = [UIImage imageNamed:@"right"];
    
    [view addSubview:label];
    [view addSubview:label1];
    [view addSubview:label2];
    [view addSubview:rightImageV];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(20);
        make.bottom.equalTo(view.mas_bottom).offset(-40);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_left);
        make.bottom.equalTo(label1.mas_top).offset(-10);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.right.equalTo(view.mas_right).offset(-45);
    }];
    
    [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.left.equalTo(label2.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(10, 20));
    }];
}

- (void)getMoney:(UITapGestureRecognizer *)tap {
    self.wayMenu.title = @"提现";
    [self.navigationController pushViewController:_wayMenu animated:YES];
}

- (void)getWalletInfo {
    NSString *url = @"https://zbt.change-word.com/index.php/home/wallet/getBill";
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"]};
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject === %@", responseObject);
        weakSelf.dataDic = (NSDictionary *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
