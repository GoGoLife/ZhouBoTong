//
//  AllOrderViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/7.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AllOrderViewController.h"
#import <Masonry.h>
#import "Globefile.h"

#import "OrderTableViewCell.h"

#import "OrderInfoViewController.h"

@interface AllOrderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)NSArray *datatAry;

@end

@implementation AllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的订单";
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        DropView(_tableView);
        
        [self.tableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"order"];
    }
    return _tableView;
}

- (void)addRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self show];
        
        NSArray *dataAry = @[@{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hidden];
            [self.tableView.mj_header endRefreshing];
            self.datatAry = dataAry;
            [self.tableView reloadData];
        });
    }];
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController didViewDidLoad:(NSInteger)index{
    [self.view addSubview:self.tableView];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"order"];
    cell.isShowTypeButton = YES;
    cell.type = TypeButtonUnknow;
    if (!cell) {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
//    NSDictionary *dict = self.datatAry[indexPath.row];
//    cell.textLabel.text = dict[@"name"];
//    cell.detailTextLabel.text = dict[@"detail"];
//    cell.textLabel.font = [UIFont systemFontOfSize:16];
//    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return OrderCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderInfoViewController *orderInfoVC = [[OrderInfoViewController alloc] init];
    [self.navigationController pushViewController:orderInfoVC animated:YES];
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
