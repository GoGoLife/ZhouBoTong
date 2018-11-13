//
//  WaitSendViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/7.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "WaitSendViewController.h"
#import <Masonry.h>
#import "Globefile.h"

#import "OrderTableViewCell.h"
#import "OrderInfoViewController.h"
#import "Submit_AfterServiceViewController.h"

@interface WaitSendViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)NSArray *datatAry;

@end

@implementation WaitSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的订单";
}

- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat insertTopHeight = 0.0;
        if (IS_IPHONE_X) {
            insertTopHeight = 64;
        }else {
            insertTopHeight = 22;
        }
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - insertTopHeight) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
//        DropView(_tableView);
        
        [self.tableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"order"];
    }
    return _tableView;
}

- (void)addRefresh{
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self show];
//    }];
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController didViewDidLoad:(NSInteger)index{
    [self.view addSubview:self.tableView];
    [self show];
    NSString *url = @"https://zbt.change-word.com/index.php/home/order/orderList";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"state" : @(2)        //待支付
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"waitPayOrder +_+_+_+_+_+ ----%@", responseObject);
        [self hidden];
        [self.tableView.mj_header endRefreshing];
        weakSelf.datatAry = responseObject[@"data"];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datatAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.datatAry[section][@"goods"] count];
}

StringWidth();
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"order"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isShowTypeButton = YES;
    cell.type = TypeButtonWaitSend;
    if (!cell) {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    NSDictionary *dict = self.datatAry[indexPath.section][@"goods"][indexPath.row];
    [cell.orderImg sd_setImageWithURL:[NSURL URLWithString:isNullClass(dict[@"photo"])] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.nameTextF.text = cell.nameTextF.text = [NSString stringWithFormat:@"*%@", isNullClass(dict[@"goods_price"])];;
    CGFloat width = [self calculateRowWidth:isNullClass(dict[@"goods_name"]) withFont:17];
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, width, 40)];
    orderLabel.textAlignment = NSTextAlignmentLeft;
    orderLabel.text = isNullClass(dict[@"goods_name"]);
    cell.nameTextF.leftView = orderLabel;
    cell.nameTextF.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 50, 40)];
    rightLabel.font = SetFont(12);
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.text = [NSString stringWithFormat:@"*%@", isNullClass(dict[@"goods_number"])];
    cell.standerdTextF.rightView = rightLabel;
    cell.standerdTextF.rightViewMode = UITextFieldViewModeAlways;
    
    NSString *price = [isNullClass(dict[@"goods_price"]) isEqualToString:@""] ? @"0" : dict[@"goods_price"];
    CGFloat sum_price = [dict[@"goods_number"] integerValue] * [price integerValue];
    cell.totalLabel.text = [NSString stringWithFormat:@"%@件商品, 合计：￥%.2f", isNullClass(dict[@"goods_number"]), sum_price];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return OrderHeight - 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderInfoViewController *orderInfoVC = [[OrderInfoViewController alloc] init];
    orderInfoVC.cellType = 2;
    orderInfoVC.order_id = self.datatAry[indexPath.section][@"order_id"];
    [self.navigationController pushViewController:orderInfoVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = [UIColor whiteColor];
    UITextField *textF = [[UITextField alloc] init];
    textF.enabled = NO;
    textF.text = [@"    " stringByAppendingString:isNullClass(self.datatAry[section][@"merchant_name"])];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 20, 20)];
    img.image = [UIImage imageNamed:@"dianpu"];
    textF.leftView = img;
    textF.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *right = [[UILabel alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width / 2, 40)];
    right.textAlignment = NSTextAlignmentRight;
    right.textColor = [UIColor redColor];
    right.font = SetFont(12);
    right.text = @"等待买家发货";
    textF.rightView = right;
    textF.rightViewMode = UITextFieldViewModeAlways;
    
    [headerV addSubview:textF];
    [textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerV).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor whiteColor];
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.titleLabel.font = SetFont(12);
    [cancel setTitle:@"申请售后" forState:UIControlStateNormal];
    ViewBorderRadius(cancel, 10.0, 1.0, [UIColor redColor]);
    [cancel addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag = section;
    [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
    UIButton *pay = [UIButton buttonWithType:UIButtonTypeCustom];
    pay.titleLabel.font = SetFont(12);
    [pay setTitle:@"提醒发货" forState:UIControlStateNormal];
    ViewBorderRadius(pay, 10.0, 1.0, [UIColor grayColor]);
    [pay addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [pay setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [footer addSubview:pay];
    [footer addSubview:cancel];
    
    [pay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.centerY.equalTo(footer.mas_centerY);
        make.right.equalTo(footer.mas_right).offset(-15);
    }];
    
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.centerY.equalTo(footer.mas_centerY);
        make.right.equalTo(pay.mas_left).offset(-15);
    }];
    
    return footer;
}

- (void)cancelOrder:(UIButton *)sender {
    Submit_AfterServiceViewController *after = [[Submit_AfterServiceViewController alloc] init];
    after.shopping_id = self.datatAry[sender.tag][@"order_id"];
    after.goodsArr = self.datatAry[sender.tag][@"goods"];
    [self.navigationController pushViewController:after animated:YES];
}

- (void)sendAction {
    [ShowHUDView showHUDWithView:self.view AndTitle:@"已提醒卖家发货"];
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
