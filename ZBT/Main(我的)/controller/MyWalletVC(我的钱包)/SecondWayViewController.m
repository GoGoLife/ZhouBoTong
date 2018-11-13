//
//  SecondWayViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/12.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SecondWayViewController.h"
#import "Globefile.h"
#import "CustomTableViewCell.h"

@interface SecondWayViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)NSArray *datatAry;

@property (nonatomic, strong) UIButton *button;

@end

@implementation SecondWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的定制";
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - 64 - 35) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        DropView(_tableView);
        
        [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"order"];
    }
    return _tableView;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = FRAME(0, CGRectGetMaxY(_tableView.bounds), SCREENBOUNDS.width, 44);
        _button.backgroundColor = SetColor(36, 148, 217, 1);
        [_button setTitle:@"申请提现" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(submit_GetMoney) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)addRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self show];
        
        //数据请求 写这里
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hidden];
            [self.tableView.mj_header endRefreshing];
            //            self.datatAry = dataAry;
            [self.tableView reloadData];
        });
    }];
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController didViewDidLoad:(NSInteger)index{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.button];
    //    [self addRefresh];
    //    [self show];
    //
    //    NSArray *dataAry = @[@{
    //                             @"name": @"数码产品",
    //                             @"detail": @"手机,电脑等",
    //                             },
    //                         @{
    //                             @"name": @"数码产品",
    //                             @"detail": @"手机,电脑等",
    //                             },
    //                         @{
    //                             @"name": @"数码产品",
    //                             @"detail": @"手机,电脑等",
    //                             },
    //                         @{
    //                             @"name": @"数码产品",
    //                             @"detail": @"手机,电脑等",
    //                             }];
    //
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self hidden];
    //        [self.tableView.mj_header endRefreshing];
    //        self.datatAry = dataAry;
    //        [self.tableView reloadData];
    //    });
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewWillDisappear:(NSInteger)index{
    //    NSLog(@"将要消失---%ld",index);
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewDidDisappear:(NSInteger)index{
    //    NSLog(@"已经消失---%ld",index);
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewWillAppear:(NSInteger)index{
    //    NSLog(@"将要出现---%ld",index);
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewDidAppear:(NSInteger)index{
    //    NSLog(@"已经出现---%ld",index);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.datatAry.count;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"order"];
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    [self setCellContent:cell AtIndexPaht:indexPath];
    //    NSDictionary *dict = self.datatAry[indexPath.row];
    //    cell.textLabel.text = dict[@"name"];
    //    cell.detailTextLabel.text = dict[@"detail"];
    //    cell.textLabel.font = [UIFont systemFontOfSize:16];
    //    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

- (void)setCellContent:(CustomTableViewCell *)cell AtIndexPaht:(NSIndexPath *)indexPath {
    cell.textF.textAlignment = NSTextAlignmentRight;
    CGFloat width = [self calculateRowWidth:@"银行卡号" withFont:14];
    [cell.textF creatLeftView:FRAME(0, 0, width, InfoCellHeight) AndTitle:@[@"银行卡号", @"体现金额"][indexPath.row] TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:[UIColor blackColor]];
    cell.textF.placeholder = @[@"请输入银行卡账号", @"请输入体现金额"][indexPath.row];
    [cell layoutIfNeeded];
}
StringWidth();

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return InfoCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *foot = [[UIView alloc] init];
    for (UIView *vv in foot.subviews) {
        [vv removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = SetColor(157, 157, 157, 1);
    label.text = [NSString stringWithFormat:@"钱包金额：¥%@", self.sum_price];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = SetFont(15);
    [button setTitle:@"全部提现" forState:UIControlStateNormal];
    [button setTitleColor:SetColor(27, 167, 224, 1) forState:UIControlStateNormal];
    
    [foot addSubview:label];
    [foot addSubview:button];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(foot.mas_centerY);
        make.left.equalTo(foot.mas_left).offset(15);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(foot.mas_centerY);
        make.left.equalTo(label.mas_right).offset(30);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        
    }];
    
    return foot;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    Publish_infoViewController *info = [[Publish_infoViewController alloc] init];
    //    [self.navigationController pushViewController:info animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submit_GetMoney {
    NSString *account_number = [self getCellFromTabelview:[NSIndexPath indexPathForRow:0 inSection:0]].textF.text;
    NSString *income = [self getCellFromTabelview:[NSIndexPath indexPathForRow:1 inSection:0]].textF.text;
    if (!isPureInt(income)) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"金额只能为整数"];
        return;
    }
    if ([account_number isEqualToString:@""] || [income isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入提现账号或金额"];
        return;
    }
    
    NSString *url = @"https://zbt.change-word.com/index.php/home/wallet/putForward";
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"account_number" : account_number,
                            @"income" : @([income integerValue])
                            };
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject === %@", responseObject);
        if ([responseObject[@"resultCode"] integerValue] == 1) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"提现成功，金额会在7个工作日内到账"];
        }else {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"提现失败，请稍后重试"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"提现失败，请稍后重试"];
    }];
}

- (CustomTableViewCell *)getCellFromTabelview:(NSIndexPath *)indexPath {
    return [self.tableView cellForRowAtIndexPath:indexPath];
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
